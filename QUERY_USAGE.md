# Query Engine Usage Guide

## Quote Requirement

All **function names, variable names, and identifiers** must be provided in **quotes** (single or double quotes).

### Why?
- Ensures clear distinction between keywords and identifiers
- Prevents ambiguity in parsing
- Makes queries more explicit and readable

## Query Syntax Examples

### Function Queries
```
find function "main"
find function "error_handler"
show function "process_data"
```

### Variable Queries
```
find variable "x"
find variable "counter" in "main"
find unused variable
```

### Reachability Queries
```
is "error_handler" reachable from "main"?
is "process" reachable from "initialize"?
```

### Scope Specification
```
find variable "x" in "main"
list variables in "calculate"
```

## Error Cases

### ❌ **WITHOUT Quotes** (Will Fail)
```
find function main              # ❌ No name extracted
find variable x                 # ❌ No name extracted
is error_handler reachable from main?  # ❌ Error: requires quoted identifiers
```

### ✅ **WITH Quotes** (Will Work)
```
find function "main"            # ✅ Name: "main"
find variable "x"               # ✅ Name: "x"
is "error_handler" reachable from "main"?  # ✅ Target: "error_handler", Source: "main"
```

## Examples

1. **Find a specific function:**
   ```
   find function "calculate_sum"
   ```

2. **Find a variable in a specific scope:**
   ```
   find variable "result" in "calculate_sum"
   ```

3. **Check reachability:**
   ```
   is "cleanup" reachable from "main"?
   ```

4. **Find all unused variables:**
   ```
   find unused variable
   ```

5. **Show instructions in a function:**
   ```
   show instructions in "main"
   ```
