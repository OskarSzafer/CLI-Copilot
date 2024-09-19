#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}


PYTHON_SCRIPT="generate_completition.py"
PYTHON_SCRIPT_PATH="$SCRIPT_DIR/$PYTHON_SCRIPT"

# Check if the Python script is already running
if pgrep -f "$PYTHON_SCRIPT" > /dev/null; then
    # Script is already running, do nothing
else
    # Start the Python script in the background
    nohup python3 "$PYTHON_SCRIPT_PATH" &> /dev/null &
fi

# Function to kill the Python script
kill_python_script() {
    kill $! 2> /dev/null
}

# Set up trap to kill Python script when the last terminal is closed
trap kill_python_script EXIT


COMPLETITION_SCRIPT="completition.zsh"
COMPLETITION_SCRIPT_PATH="$SCRIPT_DIR/$COMPLETITION_SCRIPT"

source $COMPLETITION_SCRIPT_PATH