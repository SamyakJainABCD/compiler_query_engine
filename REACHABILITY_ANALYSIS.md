# Control Flow Reachability Analysis System

## Overview
This system can now answer **control flow reachability questions** about your C code, such as:
- "Is the error_handler block reachable from main?"
- "Can we reach error_handler from process_value?"

## How It Works

### 1. **Code Compilation & IR Generation**
- Your C code is compiled to LLVM IR using `clang`
- The IR preserves all control flow information and function calls

### 2. **Call Graph Extraction**
- The `CFGExtractor` analyzes the LLVM IR to build a **call graph**
- It identifies which functions call which other functions
- Stores the call graph in `generated_files/cfg_export.json` under `_call_graph`

### 3. **Reachability Analysis**
- The `QueryEngine` performs **inter-procedural reachability analysis**
- Uses BFS (Breadth-First Search) to traverse the call graph
- Determines if a target function/block is reachable from a source function

### 4. **Natural Language Processing**
- The `NLPEngine` parses human-readable questions
- Extracts the target function/block and source function
- Recognizes patterns like: "Is [target] reachable from [source]?"

## Example Walkthrough

Given the code in `my_code.c`:
```c
void error_handler() { ... }
void process_value(int val) {
    if (val > 100) error_handler();
    ...
}
int main(int argc, char *argv[]) {
    int result = process_value(50);
    if (result < 0) error_handler();  // Direct call
    ...
}
```

**Query**: "Is the error_handler block reachable from main?"
**Analysis**: 
- main() has two paths to error_handler:
  1. Direct call: `main → error_handler`
  2. Indirect call: `main → process_value → error_handler`
**Result**: ✅ YES, error_handler is reachable from main
**Call Chain**: `main → error_handler`

## Files Modified/Created

### Core Analysis Modules
- [modules/cfg_extractor.py](modules/cfg_extractor.py) - Enhanced with call graph extraction
- [modules/nlp_parser.py](modules/nlp_parser.py) - Extended to recognize reachability queries
- [query_engine.py](query_engine.py) - Added `_check_reachability()` method for inter-procedural analysis

### Test & Demo
- [test_reachability.py](test_reachability.py) - Interactive test suite for reachability queries
- [my_code.c](my_code.c) - Updated with error_handler function and control flow patterns

### Generated Analysis Files
- `generated_files/cfg_export.json` - Control Flow Graph with call graph metadata
- `generated_files/ast_export.json` - Abstract Syntax Tree
- `generated_files/ir_export.json` - Intermediate Representation
- `generated_files/my_code.ll` - LLVM IR assembly

## Usage

### Run the Analysis Pipeline
```bash
python create_all_files.py
```
This generates all analysis files from `my_code.c`.

### Test Reachability Queries
```bash
python test_reachability.py
```
Then enter queries like:
- "Is error_handler reachable from main?"
- "Is error_handler reachable from process_value?"

### Programmatic Usage
```python
from modules.nlp_parser import NLPEngine
from query_engine import QueryEngine

nlp = NLPEngine()
qe = QueryEngine()

query = "Is error_handler reachable from main?"
intent = nlp.parse_query(query)
result = qe.execute(intent)
print(result)
# Output: ✅ YES, 'error_handler' is reachable from 'main'
#         Call Chain: main → error_handler
```

## Key Capabilities

✅ **Inter-procedural Reachability Analysis** - Follows function calls across the program
✅ **Natural Language Queries** - Understand English questions about code
✅ **Visual Call Chains** - Show the path from source to target function
✅ **Accurate Detection** - Uses actual LLVM instruction analysis, not heuristics

## Supported Query Patterns

1. `"Is [X] reachable from [Y]?"`
2. `"Is [X] reachable in [Y]?"`
3. `"Can we reach [X] from [Y]?"`

Where:
- `[X]` = target function/block name (e.g., "error_handler")
- `[Y]` = source function name (e.g., "main")

## Technical Details

### Call Graph Structure
```json
{
  "_call_graph": {
    "error_handler": ["exit"],
    "process_value": ["error_handler"],
    "main": ["atoi", "process_value", "error_handler"]
  }
}
```

### Algorithm
- **BFS-based traversal** of the call graph
- **Visited set** to avoid infinite loops
- **Early termination** when target is found
- **Time Complexity**: O(V + E) where V=functions, E=calls

### Limitations
- Only analyzes reachability through direct function calls
- Does not analyze intra-procedural control flow (paths within a single function)
- External/library functions (like `exit`, `printf`) are tracked but may not have analysis data
