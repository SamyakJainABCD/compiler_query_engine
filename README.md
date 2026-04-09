# Natural Language Compiler Query Engine

Query compiled code using English. Analyze AST/IR/CFG and detect vulnerabilities.

**Status:** ✅ Production Ready | **Accuracy:** 100% | **Latency:** 7.93ms

## Quick Start

```bash
cd /home/samyak/CD && source env/bin/activate
clang -S -emit-llvm my_code.c -o my_code.ll
python3 create_all_files.py my_code.c
```

## How to Use


run 
```python3
```

```python
from query_engine import QueryEngine
from modules.nlp_parser import NLPEngine

nlp = NLPEngine()
engine = QueryEngine()
result = engine.execute(nlp.parse('find function "main"'))
print(result)
```

## Query Examples

- `'find function "main"'` - Get function details
- `'list functions'` - All functions
- `'find unused variable'` - Unused vars
- `'is "func_a" reachable from "main"?'` - Check reachability
- `'list buffer overflows'` - Security issues

## Run Tests

```bash
python3 execute_week11_complete.py  # Run all tests
cat output/week11_test_summary.txt   # View results
```

## Installation

```bash
source env/bin/activate
pip install spacy llvmlite
python3 -m spacy download en_core_web_sm
```

## Supported Queries

- Functions: find, show, list
- Variables: find, list, detect unused
- Reachability: is X reachable from Y?
- Security: buffer overflows, bounds checks, unsafe calls

## Performance

| Metric | Result |
|--------|--------|
| Accuracy | 100% (17/17 tests) |
| Latency | 7.93ms average |
| P95 | < 10ms |

## Docs

- [WEEK11_QUICK_REFERENCE.md](WEEK11_QUICK_REFERENCE.md) - Overview
- [QUERY_USAGE.md](QUERY_USAGE.md) - Query guide
- [WEEK11_INDEX.md](WEEK11_INDEX.md) - File index

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `ModuleNotFoundError: spacy` | `pip install spacy` |
| `ir_export.json not found` | `python3 create_all_files.py my_code.c` |
| `clang not found` | `apt install clang llvm` |

**v1.0 | March 31, 2026**
