import os
import time

import google.generativeai as genai


OPTIONS_FILE=".options"
CONTEXT_FILE=".context"

model = None

def read_file():
    with open(CONTEXT_FILE, 'r') as file:
        data = file.read()
    
    return data

def save_output(output):
    with open(OPTIONS_FILE, 'w') as file:
        file.write(output)

def watch_file(check_interval):
    # Get the initial modification time of the file
    last_modified_time = os.path.getmtime(CONTEXT_FILE)

    while True:
        # Check the modification time of the file
        current_modified_time = os.path.getmtime(CONTEXT_FILE)
        
        if current_modified_time != last_modified_time:
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
                completion = response.text
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
    GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-1.5-flash')

    watch_file(1)
