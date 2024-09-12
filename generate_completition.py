import sys
import os
import google.generativeai as genai


def generate_completition_function(arg1, arg2, arg3):
    print(f"{arg1} hi")

if __name__ == "__main__":
    arg1 = sys.argv[1]
    arg2 = sys.argv[2]
    arg3 = sys.argv[3]
    
    # Call the function with the provided arguments
    generate_completition_function(arg1, arg2, arg3)
