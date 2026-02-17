import subprocess
import os

def generate_llvm_ir(source_file, output_file=None):
    # If no output name provided, change .c to .ll
    if not output_file:
        output_file = source_file.rsplit('.', 1)[0] + '.ll'

    # The exact command you ran in the terminal
    command = [
        "clang", 
        "-S", 
        "-emit-llvm", 
        source_file, 
        "-o", 
        output_file
    ]

    try:
        # run() waits for the command to finish
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"✅ IR Generated: {output_file}")
        return output_file
    except subprocess.CalledProcessError as e:
        print(f"❌ Clang Error:\n{e.stderr}")
        return None

# Usage
# ir_path = generate_llvm_ir('my_code.c')