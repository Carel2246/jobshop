import tkinter as tk
from tkinter import messagebox
import requests
from datetime import datetime, timedelta, time
from deap import base, creator, tools, algorithms
import random
import json

API_BASE_URL = "https://nmiproduksie.azurewebsites.net"

class SchedulerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Nigel Metal Scheduler")
        
        tk.Label(root, text="Start Date:").pack(pady=5)
        self.start_date_entry = tk.Entry(root)
        self.start_date_entry.insert(0, datetime.now().strftime('%Y-%m-%dT%H:%M'))
        self.start_date_entry.pack(pady=5)
        
        self.status_label = tk.Label(root, text="Ready")
        self.status_label.pack(pady=5)
        
        tk.Button(root, text="Generate Schedule", command=self.run_schedule).pack(pady=10)

    def fetch_data(self):
        response = requests.get(f"{API_BASE_URL}/api/schedule_data")
        if response.status_code != 200:
            raise Exception(f"Failed to fetch data: {response.status_code} - {response.text}")
        return response.json()

    def save_schedule(self, result):
        response = requests.post(f"{API_BASE_URL}/api/save_schedule", json=result)
        if response.status_code != 200:
            raise Exception(f"Failed to save schedule: {response.status_code} - {response.text}")

    def resolve_resources(self, tasks, resources):
        """Resolve resource groups to the first available resource."""
        resource_dict = {r['name']: r['type'] for r in resources}
        # Placeholder for group resolution (assuming API doesn’t provide groups yet)
        # We’ll treat any resource not in resource_dict as a group and pick randomly
        for task in tasks:
            resource_names = [r.strip() for r in task['resources'].split(',') if r.strip()]
            resolved = []
            for res in resource_names:
                if res in resource_dict:
                    resolved.append(res)
                else:
                    # Assume it’s a group; pick a random resource (simplified)
                    # In a real scenario, fetch group members from API or DB
                    available = [r for r, t in resource_dict.items() if t in ['H', 'M']]
                    if available:
                        resolved.append(random.choice(available))
                    else:
                        resolved.append(res)  # Fallback to name if no match
            task['resolved_resources'] = resolved

    def adjust_to_working_hours(self, start_date, task_times, calendar):
        """Adjust task times to fit within working hours."""
        calendar_map = {c.weekday(): (c.start_time, c.end_time) for c in calendar}
        adjusted_times = {}

        for task_idx, duration in task_times.items():
            current = start_date
            remaining = duration

            while remaining > 0:
                weekday = current.weekday()
                work_start, work_end = calendar_map.get(weekday, (time(0, 0), time(0, 0)))
                day_start = datetime.combine(current.date(), work_start)
                day_end = datetime.combine(current.date(), work_end)
                day_minutes = (day_end - day_start).total_seconds() / 60 if work_start != work_end else 0

                if day_minutes == 0:  # Non-working day
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
                    if task_idx not in adjusted_times:
                        adjusted_times[task_idx] = {'start': current, 'end': end}
                    else:
                        adjusted_times[task_idx]['end'] = end
                    current = end
                    remaining -= duration_today

                if remaining > 0:
                    current = day_start + timedelta(days=1)

        return adjusted_times

    def run_schedule(self):
        self.status_label.config(text="Fetching data...")
        self.root.update()
        
        try:
            data = self.fetch_data()
            start_date = datetime.strptime(self.start_date_entry.get(), '%Y-%m-%dT%H:%M')
            
            self.status_label.config(text="Scheduling in progress...")
            self.root.update()

            jobs = data['jobs']
            tasks = [t for t in data['tasks'] if not t.get('completed', False)]  # Exclude completed tasks
            resources = data['resources']
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

            # Resolve resource groups
            self.resolve_resources(tasks, resources)

            # DEAP setup
            creator.create("FitnessMin", base.Fitness, weights=(-1.0,))
            creator.create("Individual", list, fitness=creator.FitnessMin)
            
            toolbox = base.Toolbox()
            toolbox.register("attr_task", random.randint, 0, len(tasks) - 1)
            toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_task, n=len(tasks))
            toolbox.register("population", tools.initRepeat, list, toolbox.individual)

            def evaluate(individual):
                task_times = {}
                resource_busy = {r['name']: [] for r in resources}
                current_time = start_date

                for idx in individual:
                    task = tasks[idx]
                    duration = task['setup_time'] + task['time_each']
                    required_res = task['resolved_resources']

                    # Find earliest start considering resource availability
                    latest_busy = current_time
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
                    task_times[idx] = duration  # Store duration for adjustment
                    for res in required_res:
                        resource_busy[res].append((start_time, end_time))

                adjusted_times = self.adjust_to_working_hours(start_date, task_times, calendar)
                total_time = max((t['end'] - start_date).total_seconds() for t in adjusted_times.values()) if adjusted_times else 0
                return (total_time,)

            toolbox.register("evaluate", evaluate)
            toolbox.register("mate", tools.cxTwoPoint)
            toolbox.register("mutate", tools.mutShuffleIndexes, indpb=0.05)
            toolbox.register("select", tools.selTournament, tournsize=3)

            pop = toolbox.population(n=100)
            algorithms.eaSimple(pop, toolbox, cxpb=0.5, mutpb=0.2, ngen=40, verbose=False)
            best_ind = tools.selBest(pop, 1)[0]

            # Build schedule with resource availability
            result = {'segments': []}
            resource_busy = {r['name']: [] for r in resources}
            current_time = start_date

            task_times = {}
            for idx in best_ind:
                task = tasks[idx]
                duration = task['setup_time'] + task['time_each']
                required_res = task['resolved_resources']

                latest_busy = current_time
                for res in required_res:
                    busy_times = resource_busy.get(res, [])
                    for start, end in sorted(busy_times, key=lambda x: x[0]):
                        if start <= latest_busy < end:
                            latest_busy = end
                        elif start > latest_busy and (start - latest_busy).total_seconds() / 60 >= duration:
                            break
                        else:
                            latest_busy = max(latest_busy, end)

                task_times[idx] = duration

            adjusted_times = self.adjust_to_working_hours(start_date, task_times, calendar)
            for idx, times in adjusted_times.items():
                task = tasks[idx]
                result['segments'].append({
                    'task_id': task['task_number'],
                    'start': times['start'].isoformat(),
                    'end': times['end'].isoformat(),
                    'resources': ','.join(task['resolved_resources'])
                })
                for res in task['resolved_resources']:
                    resource_busy[res].append((times['start'], times['end']))

            self.status_label.config(text="Saving schedule...")
            self.root.update()
            self.save_schedule(result)

            self.status_label.config(text="Schedule generated and saved!")
            messagebox.showinfo("Success", "Schedule generated and saved successfully!")
        except Exception as e:
            self.status_label.config(text=f"Error: {str(e)}")
            messagebox.showerror("Error", str(e))

if __name__ == "__main__":
    root = tk.Tk()
    app = SchedulerApp(root)
    root.mainloop()