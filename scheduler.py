import tkinter as tk
from tkinter import messagebox
import requests
from datetime import datetime, timedelta
from deap import base, creator, tools, algorithms
import random
import json

# Configuration
API_BASE_URL = "https://nmiproduksie.azurewebsites.net/"  # Replace with your Azure app URL
API_TOKEN = "your_secure_api_token"  # Add authentication later

class SchedulerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Nigel Metal Scheduler")
        
        # GUI Elements
        tk.Label(root, text="Start Date:").pack(pady=5)
        self.start_date_entry = tk.Entry(root)
        self.start_date_entry.insert(0, datetime.now().strftime('%Y-%m-%dT%H:%M'))
        self.start_date_entry.pack(pady=5)
        
        self.status_label = tk.Label(root, text="Ready")
        self.status_label.pack(pady=5)
        
        tk.Button(root, text="Generate Schedule", command=self.run_schedule).pack(pady=10)

    def fetch_data(self):
        headers = {'Authorization': f'Bearer {API_TOKEN}'}
        response = requests.get(f"{API_BASE_URL}/api/schedule_data", headers=headers)
        if response.status_code != 200:
            raise Exception(f"Failed to fetch data: {response.text}")
        return response.json()

    def save_schedule(self, result):
        headers = {'Authorization': f'Bearer {API_TOKEN}', 'Content-Type': 'application/json'}
        response = requests.post(f"{API_BASE_URL}/api/save_schedule", json=result, headers=headers)
        if response.status_code != 200:
            raise Exception(f"Failed to save schedule: {response.text}")

    def run_schedule(self):
        self.status_label.config(text="Fetching data...")
        self.root.update()
        
        try:
            data = self.fetch_data()
            start_date = datetime.strptime(self.start_date_entry.get(), '%Y-%m-%dT%H:%M')
            
            self.status_label.config(text="Scheduling in progress...")
            self.root.update()

            # Prepare data
            jobs = data['jobs']
            tasks = data['tasks']
            resources = data['resources']
            calendar = {c['weekday']: (
                datetime.strptime(c['start_time'], '%H:%M').time(),
                datetime.strptime(c['end_time'], '%H:%M').time()
            ) for c in data['calendar']}

            # DEAP setup (your existing or enhanced logic)
            creator.create("FitnessMin", base.Fitness, weights=(-1.0,))
            creator.create("Individual", list, fitness=creator.FitnessMin)
            
            toolbox = base.Toolbox()
            toolbox.register("attr_task", random.randint, 0, len(tasks) - 1)
            toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_task, n=len(tasks))
            toolbox.register("population", tools.initRepeat, list, toolbox.individual)

            def evaluate(individual):
                # Simplified: minimize total duration (enhance as needed)
                current_time = start_date
                for idx in individual:
                    task = tasks[idx]
                    duration = task['setup_time'] + task['time_each']
                    current_time += timedelta(minutes=duration)
                return (current_time - start_date).total_seconds(),

            toolbox.register("evaluate", evaluate)
            toolbox.register("mate", tools.cxTwoPoint)
            toolbox.register("mutate", tools.mutShuffleIndexes, indpb=0.05)
            toolbox.register("select", tools.selTournament, tournsize=3)

            pop = toolbox.population(n=100)
            algorithms.eaSimple(pop, toolbox, cxpb=0.5, mutpb=0.2, ngen=40, verbose=False)
            best_ind = tools.selBest(pop, 1)[0]

            # Build schedule from best individual
            result = {'segments': []}
            current_time = start_date
            for idx in best_ind:
                task = tasks[idx]
                duration = task['setup_time'] + task['time_each']
                end_time = current_time + timedelta(minutes=duration)
                result['segments'].append({
                    'task_id': task['task_number'],
                    'start': current_time.isoformat(),
                    'end': end_time.isoformat(),
                    'machines': task['machines'],
                    'people': task['humans']
                })
                current_time = end_time

            self.status_label.config(text="Saving schedule...")
            self.root.update()
            self.save_schedule(result)

            self.status_label.config(text="Schedule generated and saved!")
            messagebox.showinfo("Success", "Schedule generated and saved successfully!")
        except Exception as e:
            self.status_label.config(text="Error occurred")
            messagebox.showerror("Error", str(e))

if __name__ == "__main__":
    root = tk.Tk()
    app = SchedulerApp(root)
    root.mainloop()