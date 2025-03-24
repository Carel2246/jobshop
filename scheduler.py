import tkinter as tk
from tkinter import ttk, messagebox
import requests
from datetime import datetime, timedelta, time as dt_time
from deap import base, creator, tools, algorithms
import random
import json
import time

API_BASE_URL = "https://nmiproduksie.azurewebsites.net"

class SchedulerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Nigel Metal Scheduler")
        self.root.geometry("600x400")
        self.root.configure(bg="#1E1E1E")

        style = ttk.Style()
        style.theme_use("clam")
        style.configure("TLabel", background="#1E1E1E", foreground="#FF8C00", font=("Courier", 12))
        style.configure("TButton", background="#FF8C00", foreground="#1E1E1E", font=("Courier", 12, "bold"),
                        borderwidth=0, padding=5)
        style.map("TButton", background=[("active", "#FFA500")], foreground=[("active", "#000000")])
        style.configure("TEntry", fieldbackground="#333333", foreground="#FF8C00", font=("Courier", 12))

        self.main_frame = ttk.Frame(root, padding=10)
        self.main_frame.pack(fill="both", expand=True)

        ttk.Label(self.main_frame, text="Start Date:").pack(pady=5)
        self.start_date_entry = ttk.Entry(self.main_frame)
        self.start_date_entry.insert(0, datetime.now().strftime('%Y-%m-%dT%H:%M'))
        self.start_date_entry.pack(pady=5)

        self.generate_button = ttk.Button(self.main_frame, text="Generate Schedule", command=self.run_schedule)
        self.generate_button.pack(pady=10)

        self.terminal = tk.Text(self.main_frame, height=10, bg="#003300", fg="#00FF00", font=("Courier", 10),
                                borderwidth=0, relief="flat", wrap="word")
        self.terminal.pack(fill="both", expand=True, pady=10)
        self.terminal.insert("end", "Initializing Nigel Metal Scheduler...\n")
        self.terminal.config(state="disabled")

    def log_to_terminal(self, message):
        self.terminal.config(state="normal")
        self.terminal.insert("end", f"[{datetime.now().strftime('%H:%M:%S')}] {message}\n")
        self.terminal.see("end")
        self.terminal.config(state="disabled")
        self.root.update()

    def fetch_data(self):
        self.log_to_terminal("Fetching data from the mainframe...")
        response = requests.get(f"{API_BASE_URL}/api/schedule_data")
        if response.status_code != 200:
            raise Exception(f"Failed to fetch data: {response.status_code} - {response.text}")
        data = response.json()
        self.log_to_terminal("Raw task data sample:")
        for t in data['tasks'][:5]:  # Log first 5 tasks for debugging
            self.log_to_terminal(f"Task {t['task_number']}: {t}")
        self.log_to_terminal("Data retrieved successfully.")
        return data

    def save_schedule(self, result):
        self.log_to_terminal("Uploading schedule to the grid...")
        response = requests.post(f"{API_BASE_URL}/api/save_schedule", json=result)
        if response.status_code != 200:
            raise Exception(f"Failed to save schedule: {response.status_code} - {response.text}")
        self.log_to_terminal("Schedule synced with central systems.")

    def resolve_resources(self, tasks, resources):
        self.log_to_terminal("Reconfiguring resource matrix...")
        resource_dict = {r['name']: r['type'] for r in resources}
        for task in tasks:
            resource_names = [r.strip() for r in task['resources'].split(',') if r.strip()]
            resolved = []
            for res in resource_names:
                if res in resource_dict:
                    resolved.append(res)
                else:
                    available = [r for r, t in resource_dict.items() if t in ['H', 'M']]
                    if available:
                        resolved.append(random.choice(available))
                    else:
                        resolved.append(res)
            task['resolved_resources'] = resolved

    def is_task_completed(self, task):
        completed = task.get('completed', False)
        if isinstance(completed, str):
            return completed.lower() in ('true', '1', 'yes')
        return bool(completed)

    def adjust_to_working_hours(self, start_date, task_schedule, calendar):
        self.log_to_terminal("Adjusting timelines to operational hours...")
        calendar_map = {c.weekday: (c.start_time, c.end_time) for c in calendar}
        adjusted_schedule = {}

        for task_idx, (duration, resources) in task_schedule.items():
            current = start_date if not adjusted_schedule else max(t['end'] for t in adjusted_schedule.values())
            remaining = duration

            while remaining > 0:
                weekday = current.weekday()
                work_start, work_end = calendar_map.get(weekday, (dt_time(0, 0), dt_time(0, 0)))
                day_start = datetime.combine(current.date(), work_start)
                day_end = datetime.combine(current.date(), work_end)
                day_minutes = (day_end - day_start).total_seconds() / 60 if work_start != work_end else 0

                if day_minutes == 0:
                    current = current.replace(hour=0, minute=0, second=0, microsecond=0) + timedelta(days=1)
                    continue

                if current < day_start:
                    current = day_start

                minutes_until_end = (day_end - current).total_seconds() / 60
                if minutes_until_end <= 0:
                    current = day_start + timedelta(days=1)
                    continue

                duration_today = min(remaining, minutes_until_end)
                if duration_today > 0:
                    end = current + timedelta(minutes=duration_today)
                    adjusted_schedule[task_idx] = {'start': current, 'end': end, 'resources': resources}
                    current = end
                    remaining -= duration_today

                if remaining > 0:
                    current = day_start + timedelta(days=1)

        return adjusted_schedule

    def run_schedule(self):
        self.generate_button.config(state="disabled")
        self.log_to_terminal("Initiating scheduling sequence...")
        maxis_messages = [
            "Reconfiguring the universe...",
            "Making coffee for the robots...",
            "Optimizing reality subroutines...",
            "Consulting the quantum overlords...",
            "Reticulating splines...",
            "Calibrating flux capacitors...",
            "Simulating alternate timelines..."
        ]

        try:
            data = self.fetch_data()
            start_date = datetime.strptime(self.start_date_entry.get(), '%Y-%m-%dT%H:%M')
            
            self.log_to_terminal("Processing job data...")
            jobs = data['jobs']
            tasks = [t for t in data['tasks'] if not self.is_task_completed(t)]
            self.log_to_terminal(f"Filtered tasks: {len(tasks)} out of {len(data['tasks'])}")
            
            resources = data['resources']
            # Note: resource_groups are available in data['resource_groups'] but not used in scheduling yet
            calendar = []
            for c in data['calendar']:
                try:
                    start_time = datetime.strptime(c['start_time'], '%H:%M').time()
                except ValueError:
                    start_time = datetime.strptime(c['start_time'], '%H:%M:%S').time()
                try:
                    end_time = datetime.strptime(c['end_time'], '%H:%M').time()
                except ValueError:
                    end_time = datetime.strptime(c['end_time'], '%H:%M:%S').time()
                calendar.append(type('Calendar', (), {'weekday': c['weekday'], 'start_time': start_time, 'end_time': end_time}))

            self.resolve_resources(tasks, resources)

            creator.create("FitnessMin", base.Fitness, weights=(-1.0, -1.0))
            creator.create("Individual", list, fitness=creator.FitnessMin)
            
            toolbox = base.Toolbox()
            toolbox.register("attr_task", random.randint, 0, len(tasks) - 1)
            toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_task, n=len(tasks))
            toolbox.register("population", tools.initRepeat, list, toolbox.individual)

            def evaluate(individual):
                resource_busy = {r['name']: [] for r in resources}
                task_times = {}
                conflicts = 0

                for idx in individual:
                    task = tasks[idx]
                    duration = task['setup_time'] + task['time_each']
                    required_res = task['resolved_resources']

                    earliest_start = start_date if not task_times else max(t[1] for t in task_times.values())
                    latest_busy = earliest_start
                    for res in required_res:
                        busy_times = resource_busy.get(res, [])
                        for start, end in sorted(busy_times, key=lambda x: x[0]):
                            if start <= latest_busy < end:
                                latest_busy = end
                            elif start > latest_busy and (start - latest_busy).total_seconds() / 60 >= duration:
                                break
                            else:
                                latest_busy = max(latest_busy, end)

                    start_time = latest_busy
                    end_time = start_time + timedelta(minutes=duration)

                    for res in required_res:
                        overlaps = [t for t in resource_busy[res] if not (t[1] <= start_time or t[0] >= end_time)]
                        conflicts += len(overlaps)
                        resource_busy[res].append((start_time, end_time))

                    task_times[idx] = (start_time, end_time)

                adjusted_schedule = self.adjust_to_working_hours(start_date, 
                                                                {idx: (task['setup_time'] + task['time_each'], task['resolved_resources']) 
                                                                 for idx, task in enumerate(tasks)}, 
                                                                calendar)
                total_time = max((t['end'] - start_date).total_seconds() for t in adjusted_schedule.values()) if adjusted_schedule else 0
                return (total_time, conflicts)

            toolbox.register("evaluate", evaluate)
            toolbox.register("mate", tools.cxTwoPoint)
            toolbox.register("mutate", tools.mutShuffleIndexes, indpb=0.05)
            toolbox.register("select", tools.selTournament, tournsize=3)

            self.log_to_terminal("Spinning up genetic algorithms...")
            pop = toolbox.population(n=100)
            for gen in range(40):
                algorithms.eaSimple(pop, toolbox, cxpb=0.5, mutpb=0.2, ngen=1, verbose=False)
                self.log_to_terminal(random.choice(maxis_messages))
                time.sleep(0.1)

            best_ind = tools.selBest(pop, 1)[0]

            self.log_to_terminal("Constructing final schedule...")
            result = {'segments': []}
            resource_busy = {r['name']: [] for r in resources}
            task_schedule = {}

            for idx in best_ind:
                task = tasks[idx]
                duration = task['setup_time'] + task['time_each']
                required_res = task['resolved_resources']

                earliest_start = start_date if not task_schedule else max(t[1] for t in task_schedule.values())
                latest_busy = earliest_start
                for res in required_res:
                    busy_times = resource_busy.get(res, [])
                    for start, end in sorted(busy_times, key=lambda x: x[0]):
                        if start <= latest_busy < end:
                            latest_busy = end
                        elif start > latest_busy and (start - latest_busy).total_seconds() / 60 >= duration:
                            break
                        else:
                            latest_busy = max(latest_busy, end)

                task_schedule[idx] = (duration, required_res)

            adjusted_schedule = self.adjust_to_working_hours(start_date, task_schedule, calendar)
            for idx, times in adjusted_schedule.items():
                task = tasks[idx]
                start_time = times['start']
                end_time = times['end']
                required_res = times['resources']
                result['segments'].append({
                    'task_id': task['task_number'],
                    'start': start_time.isoformat(),
                    'end': end_time.isoformat(),
                    'resources': ','.join(required_res)
                })
                for res in required_res:
                    resource_busy[res].append((start_time, end_time))

            self.save_schedule(result)
            self.log_to_terminal("Schedule generation complete!")
            messagebox.showinfo("Success", "Schedule generated and saved successfully!")
        except Exception as e:
            self.log_to_terminal(f"Critical error: {str(e)}")
            messagebox.showerror("Error", str(e))
        finally:
            self.generate_button.config(state="normal")

if __name__ == "__main__":
    root = tk.Tk()
    app = SchedulerApp(root)
    root.mainloop()