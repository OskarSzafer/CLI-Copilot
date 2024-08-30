import subprocess
import os
from time import sleep

class CLI_Interface:
    def __init__(self):
        self.script_prepare_history = os.path.join(os.path.dirname(__file__), 'prepare_history.sh')
        
        # Check if the scripts exist
        if not os.path.exists(self.script_prepare_history):
            print("Shell script not found")
            return

        self.history_file = os.path.join(os.path.dirname(__file__), 'history.txt')
        self.previous_mtime = 0

    def prepare_history(self):
        # Get the current modification time of the history file
        current_mtime = os.path.getmtime(self.history_file)

        # Check if the file modification time has changed
        if self.previous_mtime != current_mtime:
            subprocess.run(['bash', self.script_prepare_history], check=True, text=True)
            self.previous_mtime = current_mtime


# Create an instance of the CLI_Interface
interface = CLI_Interface()
while True:
    print("Checking for updates")
    interface.prepare_history()
    sleep(1)
