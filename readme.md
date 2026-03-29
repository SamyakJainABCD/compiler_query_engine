# Code Analysis Query Engine with Buffer Overflow Detection

A comprehensive C code analysis system that combines AST, IR, and CFG analysis with natural language query support and security vulnerability detection.

## Quick Start

### Setup
```bash
# Activate the Python environment
source env/bin/activate

# Create analysis files from a C source file
python create_all_files.py

# Run the interactive query engine
python query_engine.py
```

## Features

### 1. **Multi-Layer Code Analysis**
- **AST (Abstract Syntax Tree)**: Find functions, variables, and code structure
- **IR (Intermediate Representation)**: Analyze instructions and operations
- **CFG (Control Flow Graph)**: Examine control flow and reachability
- **Semantic Analysis**: Detect unused variables and code patterns

### 2. **Natural Language Query Interface**
Ask questions in natural language about your code:
- `find function "main"`
- `find variable "x" in "process_value"`
- `is "error_handler" reachable from "main"?`
- `find unused variable`

### 3. **🔒 Buffer Overflow Detection** ⭐ NEW
Automatically detects buffer overflow vulnerabilities:
- Identifies unsafe function calls (`strcpy`, `sprintf`, `gets`, `scanf`, etc.)
- Analyzes fixed-size buffer declarations
- Provides risk ratings (🔴 CRITICAL, 🟠 HIGH, 🟡 MEDIUM)
- Recommends secure alternatives

## Usage Examples

### Query by Natural Language

```bash
python query_engine.py
```

Then ask:
```
👉 Are there any buffer overflow risks?
👉 Check for critical buffer overflow vulnerabilities
👉 Find function "main"
👉 Is "error_handler" reachable from "main"?
```

### Programmatic Usage

```python
from modules.buffer_overflow_analyzer import BufferOverflowAnalyzer

analyzer = BufferOverflowAnalyzer()
report = analyzer.analyze()

print(f"Risks found: {report['summary']['total_risks']}")
for risk in report['risks']:
    print(f"  {risk['detail']}")
```

## File Structure

```
.
├── query_engine.py                 # Main query execution engine
├── create_all_files.py            # Generates AST/IR/CFG files
├── my_code.c                      # Example C source code
├── vulnerable_code.c              # Vulnerable code examples
├── modules/
│   ├── nlp_parser.py              # Natural language processing
│   ├── ir_parser.py               # LLVM IR extraction
│   ├── export_ast.py              # AST extraction from C code
│   ├── cfg_extractor.py           # Control flow graph generation
│   ├── mapping_engine.py          # Cross-layer analysis
│   ├── semantic_logger.py         # Semantic analysis
│   └── buffer_overflow_analyzer.py # 🔒 Buffer overflow detection
├── generated_files/
│   ├── ast_export.json            # Abstract Syntax Tree
│   ├── ir_export.json             # LLVM Intermediate Representation
│   └── cfg_export.json            # Control Flow Graph
├── BUFFER_OVERFLOW_DETECTION.md   # 🔒 Detailed buffer overflow documentation
└── test_buffer_overflow.py        # Tests for buffer overflow detection
```

## Query Types

### 1. AST Queries
```
find function "name"
find variable "name" [in "function"]
```

### 2. IR Queries  
```
find instruction in "function"
```

### 3. CFG Queries
```
find cfg for "function"
list loops in "function"
```

### 4. Reachability Queries
```
is "target" reachable from "source"?
```

### 5. 🔒 Security Queries (NEW)
```
Are there buffer overflow risks?
Check for buffer overflow vulnerabilities
What are the critical buffer overflows?
```

## Buffer Overflow Detection

### Overview
Detects unsafe C string functions that can cause buffer overflows:

| Unsafe Function | Safe Alternative | Risk Level |
|---|---|---|
| `strcpy()` | `strncpy()`, `strlcpy()` | 🔴 CRITICAL |
| `strcat()` | `strncat()`, `strlcat()` | 🟠 HIGH |
| `sprintf()` | `snprintf()` | 🟠 HIGH |
| `gets()` | `fgets()` | 🔴 CRITICAL |
| `scanf()` | `scanf()` with width limits | 🟠 HIGH |

### Example Analysis

```
Query: "Are there any buffer overflow risks?"

Result: 🔓 BUFFER OVERFLOW VULNERABILITY ANALYSIS
📊 SUMMARY:
   Total Risks Found: 4
   🔴 Critical: 2
   🟠 High: 2

🚨 UNSAFE FUNCTION CALLS DETECTED:
   🔴 strcpy in 'copy_name' - Copies string without size checking
   🟠 sprintf in 'format_string' - Formatted output without size checking

💡 RECOMMENDATIONS:
   🔴 Replace strcpy() with strncpy() or strlcpy()
   ⚠️  Implement input validation and bounds checking
   🛡️  Use modern safe string libraries
```

### For More Details
See [BUFFER_OVERFLOW_DETECTION.md](BUFFER_OVERFLOW_DETECTION.md) for comprehensive documentation.

## Testing

### Run Buffer Overflow Tests
```bash
python test_buffer_overflow.py
```

### Run Full Demo
```bash
python buffer_overflow_demo.py
```

## System Requirements

- Python 3.8+
- LLVM/Clang (for IR generation)
- spaCy (for NLP)
- llvmlite (for IR parsing)

All dependencies are in `env/` virtual environment.

## Implementation Details

### Query Processing Pipeline
1. **User Input** → Natural Language Query
2. **NLP Parsing** → Extract Intent (action, target, scope, layer)
3. **Intent Verification** → Validate against available data
4. **Query Execution** → Search AST/IR/CFG or run security analysis
5. **Result Formatting** → Present results to user

### Buffer Overflow Analysis Pipeline
1. **IR Extraction** → Parse LLVM intermediate representation
2. **Function Call Detection** → Find all `@function_name` calls
3. **Unsafe Function Matching** → Compare against known dangerous functions
4. **AST Buffer Detection** → Find array declarations and sizes
5. **Risk Classification** → Assign severity levels
6. **Report Generation** → Create formatted vulnerability report

## Supported Query Examples

```
# Basic queries
find function "main"
find variable "counter"
find variable "x" in "calculate"
find unused variable

# Advanced queries
is "error_handler" reachable from "main"?

# Security queries (NEW)
Are there any buffer overflow risks?
Check for critical buffer overflow vulnerabilities
What buffer overflows have high severity?
```

## Error Handling

The system validates:
- Function/variable names are provided in quotes
- Identifiers follow C naming conventions
- Functions and variables exist in the code
- Queries target valid analysis layers

## Future Enhancements

- [ ] Integer overflow detection
- [ ] Use-after-free detection
- [ ] SQL injection analysis
- [ ] Format string vulnerability detection
- [ ] Custom vulnerability patterns
- [ ] Integration with CI/CD pipelines

## Notes

- To use this tool with your own C code:
  1. Replace `my_code.c` with your source file
  2. Run `python create_all_files.py`
  3. Use `python query_engine.py` for interactive analysis

- For security analysis, combine with:
  - Clang Static Analyzer
  - AddressSanitizer (ASAN)
  - Valgrind memory checker
  - Professional security scanners