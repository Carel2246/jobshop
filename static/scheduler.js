// static/scheduler.js
async function runScheduler(form, resultCallback) {
    const loadingMessage = "Scheduling in Progress... (This may take a few minutes)";
    const formData = new FormData(form);
    sessionStorage.setItem('schedulingInProgress', 'true');

    try {
        const response = await fetch('/schedule', {
            method: 'POST',
            body: formData
        });
        if (!response.ok) throw new Error(`Server error: ${response.status}`);
        const data = await response.json();
        if (data.error) throw new Error(data.error);

        let pyodide = await loadPyodide();
        console.log('Pyodide loaded');
        try {
            await pyodide.loadPackage('deap');
            console.log('DEAP loaded');
        } catch (e) {
            throw new Error('Failed to load DEAP: ' + e.message);
        }

        pyodide.globals.set('start_date', data.start_date);
        pyodide.globals.set('jobs', data.jobs);
        pyodide.globals.set('tasks', data.tasks);
        pyodide.globals.set('resources', data.resources);
        pyodide.globals.set('calendar', data.calendar);

        await pyodide.runPythonAsync(`
            from deap import base, creator, tools, algorithms
            import random
            from datetime import datetime, timedelta
            import json

            start_date = datetime.fromisoformat(start_date)
            jobs = [dict(j) for j in jobs]
            tasks = [dict(t) for t in tasks]
            resources = [dict(r) for r in resources]
            calendar = {c['weekday']: (
                datetime.strptime(c['start_time'], '%H:%M').time(),
                datetime.strptime(c['end_time'], '%H:%M').time()
            ) for c in calendar}

            # [YOUR EXISTING PYTHON SCHEDULING CODE HERE]
            # For example:
            # result = {'segments': []}
            # for task in tasks:
            #     result['segments'].append({
            #         'task_id': task['task_number'],
            #         'start': start_date.isoformat(),
            #         'end': (start_date + timedelta(minutes=task['setup_time'] + task['time_each'])).isoformat(),
            #         'machines': task['machines'],
            #         'people': task['humans']
            #     })
        `);

        const result = pyodide.globals.get('result').toJs();

        const saveResponse = await fetch('/save_schedule', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(result)
        });
        const saveData = await saveResponse.json();
        if (saveData.success) {
            sessionStorage.removeItem('schedulingInProgress');
            resultCallback(null, 'Schedule generated and saved successfully!');
        } else {
            throw new Error('Failed to save schedule');
        }
    } catch (error) {
        console.error('Scheduling error:', error);
        sessionStorage.removeItem('schedulingInProgress');
        resultCallback(error, null);
    }
}

function updateSchedulingMessage() {
    const message = document.getElementById('scheduling-message');
    if (message) {
        if (sessionStorage.getItem('schedulingInProgress') === 'true') {
            message.style.display = 'block';
        } else {
            message.style.display = 'none';
        }
    }
}