import json

def generate_semantic_logs(cfg_data, output_path):
    logs = []
    
    for func, data in cfg_data.items():
        # Skip non-function entries like _call_graph
        if func.startswith("_"):
            continue
        
        if not isinstance(data, dict) or "nodes" not in data:
            continue
        
        num_blocks = len(data["nodes"])
        num_edges = len(data["edges"])
        
        # Semantic Logic:
        # 1. Complexity Check
        complexity = "Simple (Linear)" if num_edges < num_blocks else "Complex (Branching)"
        
        # 2. Loop Detection (Simple heuristic: edge pointing to an earlier block)
        has_loop = "Possible Loop Detected" if num_edges >= num_blocks and num_blocks > 1 else "No Loops"

        log_entry = {
            "function": func,
            "metrics": {
                "block_count": num_blocks,
                "edge_count": num_edges
            },
            "analysis": {
                "flow_type": complexity,
                "loop_status": has_loop
            }
        }
        logs.append(log_entry)

    with open(output_path, "w") as f:
        json.dump(logs, f, indent=4)
    print("✅ Semantic Metadata: Analysis logs generated.")

# Example trigger
# generate_semantic_logs(cfg_results)