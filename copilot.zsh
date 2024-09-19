#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

PYTHON_SCRIPT="generate_completition.py"
COMPLETITION_SCRIPT="completition.zsh"
CONTEXT_SCRIPT="context.zsh"

# Check if the Python script is already running
if pgrep -f "$PYTHON_SCRIPT" > /dev/null; then
    # Script is already running, do nothing
else
    # Start the Python script in the background
    $(nohup python3 "$SCRIPT_DIR/$PYTHON_SCRIPT" &> /dev/null &)
fi

# Function to kill the Python script
kill_python_script() {
    # Check if there are no other zsh sessions open
    if [ $(ps -eo pid,comm,tty,stat | grep -E 'zsh.*\+' | wc -l) -eq 1 ]; then
        PYTHON_PID=$(pgrep -f "$PYTHON_SCRIPT")
        kill "$PYTHON_PID"
    fi
}

# Set up trap to kill Python script when the last terminal is closed
trap kill_python_script EXIT

source "$SCRIPT_DIR/$COMPLETITION_SCRIPT"
source "$SCRIPT_DIR/$CONTEXT_SCRIPT"