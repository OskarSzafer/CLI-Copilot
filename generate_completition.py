import os
import time
import linecache

import google.generativeai as genai


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TMP_FILES_DIR = os.path.join(SCRIPT_DIR, ".tmp")

MIN_IDLE_TIME = 0.3
CHECK_INTERVAL = 0.1

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=GOOGLE_API_KEY)
model = genai.GenerativeModel('gemini-1.5-flash')

template = """
You are command line copilot.
Command line history for context:
{command_history}
Output of ls command:
{ls_output}
Current working dirrectory: {current_directory}
Curremt command line prompt: {current_prompt}
Propose how current prompt should be completed,
return completed command line prompt aleone with no explanation.
"""


def read_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    current_prompt = lines[0].strip()
    current_directory = lines[1].strip()
    command_history = "".join(lines[3:18])
    ls_output = "".join(lines[18:])

    return template.format(command_history=command_history, ls_output=ls_output, current_directory=current_directory, current_prompt=current_prompt)

def save_output(file_path, output):
    with open(file_path, 'w') as file:
        file.write(output)
    print("updated")

def process_file(context_file_path, option_file_path):
    current_modified_time = os.path.getmtime(context_file_path)
    last_modified_time = os.path.getmtime(option_file_path)

    if current_modified_time > last_modified_time and (time.time() - current_modified_time) > MIN_IDLE_TIME:
        prompt = read_file(context_file_path)

        if not prompt:
            return

        chat = model.start_chat(history=[])
        response = chat.send_message(prompt)
        completion = response.text.strip()

        save_output(option_file_path, completion)

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for context_file in files:
            if ".context" in context_file:
                context_file_path = os.path.join(directory, context_file)
                option_file_path = os.path.join(directory, context_file.replace(".context", ".options"))

                try:
                    process_file(context_file_path, option_file_path)
                except Exception as e:
                    print(e)

def watch_files():
    while True:
        process_directory(TMP_FILES_DIR)
        
        # Wait for the specified interval before checking again
        time.sleep(CHECK_INTERVAL)


if __name__ == "__main__":
    watch_files()
