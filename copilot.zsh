#!/bin/zsh
# Get the directory of the script
SCRIPT_DIR=${0:a:h}

PYTHON_SCRIPT="generate_completion.py"
COMPLETION_SCRIPT="completion.zsh"
CONTEXT_SCRIPT="context.zsh"

LOG_FILE="$SCRIPT_DIR/error.log"

pid=$$
OPTIONS_FILE=$(mktemp "$SCRIPT_DIR/.tmp/.options_${pid}_XXXXXX")
CONTEXT_FILE=$(mktemp "$SCRIPT_DIR/.tmp/.context_${pid}_XXXXXX")

# Check if the Python script is already running
if pgrep -f "$SCRIPT_DIR/$PYTHON_SCRIPT" > /dev/null; then
    # Script is already running, do nothing
else
    # Start the Python script in the background
    $(nohup $SCRIPT_DIR/venv/bin/python "$SCRIPT_DIR/$PYTHON_SCRIPT" >/dev/null 2>>"$LOG_FILE" &)
fi

# Function to kill the Python script
cleanup() {
    # Check if there are no other zsh sessions open
    if [ $(ps -eo pid,comm,tty,stat | grep -E 'zsh.*\+' | wc -l) -eq 1 ]; then
        # Kill the Python script
        PYTHON_PID=$(pgrep -f "$PYTHON_SCRIPT")
        kill "$PYTHON_PID"
    fi

    rm -f "$OPTIONS_FILE"
    rm -f "$CONTEXT_FILE"
}

# Set up trap to kill Python script when the last terminal is closed
trap cleanup EXIT

source "$SCRIPT_DIR/$COMPLETION_SCRIPT"
source "$SCRIPT_DIR/$CONTEXT_SCRIPT"