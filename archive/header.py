# -*- coding: utf-8 -*-
"""
Created on Sun Dec  8 20:56:52 2024

@author: iT
"""

import os

def get_user_input():
    """
    Prompt the user to input header information.
    """
    print("Please provide the following header information:")
    file_name = input("File name (without extension): ").strip()
    description = input("Description: ").strip()
    author = input("Author: ").strip()
    history = input("History: ").strip()
    
    return {
        "file_name": file_name,
        "description": description,
        "author": author,
        "history": history
    }

def create_header(header_info):
    """
    Create a formatted header string using the provided header information.
    """
    header_lines = [
        "// =========================================================",
        f"// File Name : {header_info['file_name']}.sv",
        f"// Description: {header_info['description']}",
        f"// Author     : {header_info['author']}",
        f"// History    : {header_info['history']}",
        "// =========================================================\n"
    ]
    return "\n".join(header_lines)

def add_header_to_file(file_path, header):
    """
    Prepend the header to the specified file.
    """
    try:
        with open(file_path, 'r') as file:
            original_content = file.read()
        
        with open(file_path, 'w') as file:
            file.write(header + original_content)
        
        print(f"Header successfully added to {file_path}")
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' does not exist.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def main():
    """
    Main function to execute the header addition process.
    """
    # Get header information from the user
    header_info = get_user_input()
    
    # Define the .sv file name
    sv_file = f"{header_info['file_name']}.sv"
    
    # Check if the file exists in the current directory
    if not os.path.isfile(sv_file):
        print(f"Error: The file '{sv_file}' was not found in the current directory.")
        return
    
    # Create the header string
    header = create_header(header_info)
    
    # Add the header to the file
    add_header_to_file(sv_file, header)

if __name__ == "__main__":
    main()
