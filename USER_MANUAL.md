# User Manual - Natural Language Compiler Query Engine

## Quick Start

```bash
cd /home/samyak/CD && source env/bin/activate
python3 create_all_files.py my_code.c
```

## Usage

```python
from query_engine import QueryEngine
from modules.nlp_parser import NLPEngine

nlp = NLPEngine()
engine = QueryEngine()
result = engine.execute(nlp.parse_query('find function "main"'))
print(result)
```

## Common Queries

- `find function "main"` - Get function details
- `list functions` - All functions in code
- `find unused variable` - Unused vars
- `is "func_a" reachable from "main"?` - Code reachability
- `list buffer overflows` - Security issues

## Output Formats

**Text:** Human-readable results with metadata  
**Visualization:** AST tree structure printed to terminal  
**JSON:** Structured data for programmatic use

## AST Visualization

Call `print_ast_visual()` to print AST structure:

```
┌─ AST Tree ─────────────────────────────┐
FunctionDecl [main]
├─ CompoundStmt
│  ├─ CallExpr [printf]
│  └─ ReturnStmt
└──────────────────────────────────────┘
```

## Error Handling

| Error | Fix |
|-------|-----|
| File not found | Run `create_all_files.py` first |
| Parse error | Check query syntax |
| Empty results | Verify function exists |

## Tips

- Use quotes: `find function "main"` not `find function main`
- Check `supported_queries.txt` for all options
- Run tests: `python3 comprehensive_test_suite.py`
