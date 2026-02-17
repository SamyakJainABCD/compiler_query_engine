# run clang -S -emit-llvm my_code.c -o my_code.ll before executing this script

import llvmlite.binding as llvml
import json

def export_ir_to_json(ir_file, output_path):
    with open(ir_file, 'r') as f:
        mod = llvml.parse_assembly(f.read())
    
    ir_structure = {"functions": []}

    for func in mod.functions:
        func_data = {
            "name": func.name,
            "blocks": []
        }
        for block in func.blocks:
            block_data = {
                "id": block.name,
                "instructions": [str(inst).strip() for inst in block.instructions]
            }
            func_data["blocks"].append(block_data)
        
        ir_structure["functions"].append(func_data)
    with open(output_path, "w") as f:
        json.dump(ir_structure, f, indent=4)
    print("✅ IR exported to ir_export.json")


# example usage
# export_ir_to_json('my_code.ll')