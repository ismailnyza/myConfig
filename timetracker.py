import time
import csv

class Timer:
    def __init__(self, task_name):
        self.task_name = task_name
        self.start_time = time.time()
        self.end_time = None
        self.paused_time = 0
        self.notes = []

    def pause(self):
        if not self.end_time:
            self.paused_time += time.time() - self.start_time

    def resume(self):
        if not self.end_time:
            self.start_time = time.time() - self.paused_time

    def stop(self):
        if not self.end_time:
            self.end_time = time.time()

    def get_elapsed_time(self):
        if self.end_time:
            return self.end_time - self.start_time - self.paused_time
        else:
            return time.time() - self.start_time - self.paused_time

    def add_note(self, note):
        self.notes.append(note)

    def remove_note(self, index):
        del self.notes[index]

timers = []

def display_timers():
    for i, timer in enumerate(timers):
        print(f"{i+1}. {timer.task_name} - {time.strftime('%H:%M:%S', time.localtime(timer.start_time))} - {timer.get_elapsed_time():.2f} seconds")

def export_to_csv(filename):
    with open(filename, "w", newline="") as csvfile:
        fieldnames = ["Task Name", "Start Time", "End Time", "Elapsed Time (seconds)", "Notes"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for timer in timers:
            writer.writerow({
                "Task Name": timer.task_name,
                "Start Time": time.strftime("%H:%M:%S", time.localtime(timer.start_time)),
                "End Time": time.strftime("%H:%M:%S", time.localtime(timer.end_time)) if timer.end_time else "",
                "Elapsed Time (seconds)": timer.get_elapsed_time(),
                "Notes": "\n".join(timer.notes)
            })

def main():
    while True:
        command = input("Enter a command (start, stop, pause, resume, list, notes, export, exit): ")

        if command == "start":
            task_name = input("Enter task name: ")
            timers.append(Timer(task_name))
            print(f"Task started: {task_name}")
        elif command == "stop":
            task_name = input("Enter task name to stop: ")
            for timer in timers:
                if timer.task_name == task_name:
                    timer.stop()
                    print(f"Task stopped: {task_name}")
                    break
            else:
                print("Task not found.")
        elif command == "pause":
            task_name = input("Enter task name to pause: ")
            for timer in timers:
                if timer.task_name == task_name:
                    timer.pause()
                    print(f"Task paused: {task_name}")
                    break
            else:
                print("Task not found.")
        elif command == "resume":
            task_name = input("Enter task name to resume: ")
            for timer in timers:
                if timer.task_name == task_name:
                    timer.resume()
                    print(f"Task resumed: {task_name}")
                    break
            else:
                print("Task not found.")
        elif command == "list":
            display_timers()
        elif command == "notes":
            task_name = input("Enter task name to view notes: ")
            for timer in timers:
                if timer.task_name == task_name:
                    if timer.notes:
                        print(f"Notes for {task_name}:")
                        for i, note in enumerate(timer.notes):
                            print(f"{i+1}. {note}")
                    else:
                        print("No notes for this task.")
                    break
            else:
                print("Task not found.")
        elif command == "export":
            filename = input("Enter filename for CSV export: ")
            export_to_csv(filename)
        elif command == "exit":
            break
        else:
            print("Invalid command. Please enter 'start', 'stop', 'pause', 'resume', 'list', 'notes', 'export', or 'exit'.")

if __name__ == "__main__":
    main()
