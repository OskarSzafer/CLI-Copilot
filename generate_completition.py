import sys
import os
import google.generativeai as genai


def generate_completion_function(current_line, command_history, arg3, arg4):
    GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-1.5-flash')
    chat = model.start_chat(history=[])

    prompt = f"""Given the current terminal line and command history, suggest a completion for the current command. 
    Return only the completion text, without any explanation.
    Current terminal line: {current_line}
    Command history:
    {command_history}"""

    response = chat.send_message(prompt)
    
    completion = response.text

    print(completion)

if __name__ == "__main__":
    arg1 = sys.argv[1]
    arg2 = sys.argv[2]
    arg3 = sys.argv[3]
    arg4 = sys.argv[4]

    # Call the function with the provided arguments
    generate_completion_function(arg1, arg2, arg3, arg4)