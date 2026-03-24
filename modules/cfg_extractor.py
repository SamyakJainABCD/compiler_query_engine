# run clang -S -emit-llvm my_code.c -o my_code.ll before executing this script

import llvmlite.binding as llvm
import json


class CFGExtractor:
    def __init__(self, ir_file, output_path):
        self.output_path = output_path
        with open(ir_file, 'r') as f:
            self.module = llvm.parse_assembly(f.read())

    def extract_cfg(self):
        cfg_data = {}
        call_graph = {}  # Track which functions call which functions

        for func in self.module.functions:
            if func.is_declaration: # Skip external functions like printf
                continue
                
            func_name = func.name
            cfg_data[func_name] = {
                "nodes": [], 
                "edges": [],
                "calls": []  # Track function calls from this function
            }
            call_graph[func_name] = []

            block_counter = 0
            for block in func.blocks:
                # 1. Extract Node (Basic Block)
                # Use the block name if available, otherwise use a counter
                block_id = block.name if block.name else str(block_counter)
                block_counter += 1
                
                cfg_data[func_name]["nodes"].append({
                    "id": block_id,
                    "instruction_count": len(list(block.instructions))
                })

                # Check for function calls in this block
                for instr in block.instructions:
                    instr_str = str(instr)
                    # Look for "call" instructions
                    if "call " in instr_str:
                        # Extract the function name being called
                        # Pattern: "call returntype @funcname(...)"
                        import re
                        match = re.search(r'call\s+\w+\s+@(\w+)\(', instr_str)
                        if match:
                            called_func = match.group(1)
                            if called_func not in cfg_data[func_name]["calls"]:
                                cfg_data[func_name]["calls"].append(called_func)
                            if called_func not in call_graph[func_name]:
                                call_graph[func_name].append(called_func)

                # 2. Extract Edges (Control Flow)
                # The last instruction in a block is the 'Terminator' (Branch/Ret)
                instructions = list(block.instructions)
                if instructions:
                    terminator = instructions[-1]
                    term_str = str(terminator)

                    # Look for branch targets (e.g., "br label %5" or "br i1 %2, label %3, label %4")
                    if "br " in term_str:
                        parts = term_str.split("label %")
                        for target in parts[1:]:
                            clean_target = target.split(",")[0].split(")")[0].strip()
                            cfg_data[func_name]["edges"].append({
                                "from": block_id,
                                "to": clean_target
                            })

        # Store the call graph separately
        cfg_data["_call_graph"] = call_graph

        with open(self.output_path, "w") as f:
            json.dump(cfg_data, f, indent=4)
            
        return cfg_data

# --- Deliverable Implementation ---
# if __name__ == "__main__":
#     extractor = CFGExtractor('my_code.ll')
#     cfg_results = extractor.extract_cfg()
    
#     with open("cfg_export.json", "w") as f:
#         json.dump(cfg_results, f, indent=4)
#     print("✅ CFG Module: Exported basic blocks and edges to cfg_export.json")