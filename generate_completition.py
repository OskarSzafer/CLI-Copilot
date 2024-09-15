import os
import time
import linecache

import google.generativeai as genai

OPTIONS_FILE=".options"
CONTEXT_FILE=".context"

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


def read_file():
    with open(CONTEXT_FILE, 'r') as file:
        lines = file.readlines()
    
    current_prompt = lines[0].strip()
    current_directory = lines[1].strip()
    command_history = "".join(lines[3:18])
    ls_output = "".join(lines[18:])

    return template.format(command_history=command_history, ls_output=ls_output, current_directory=current_directory, current_prompt=current_prompt)

def save_output(output):
    with open(OPTIONS_FILE, 'w') as file:
        file.write(output)

def watch_file(check_interval, min_idle_time):
    # Get the initial modification time of the file
    last_modified_time = os.path.getmtime(CONTEXT_FILE)

    while True:
        # Check the modification time of the file
        current_modified_time = os.path.getmtime(CONTEXT_FILE)
        
        if current_modified_time != last_modified_time and (time.time() - current_modified_time) > min_idle_time:
            try:
                prompt = read_file()
            except Exception as e:
                print(e)
                continue

            if not prompt:
                continue

            try:
                chat = model.start_chat(history=[])
                response = chat.send_message(prompt)
                completion = response.text.strip()
            except Exception as e:
                print(e)
                continue

            try:
                save_output(completion)
                print("updated")
                
                # Update the last modified time
                last_modified_time = current_modified_time
            except Exception as e:
                print(e)
        
        # Wait for the specified interval before checking again
        time.sleep(check_interval)


if __name__ == "__main__":
    watch_file(0.1, 0.3)
