import clang.cindex
import json

# Setup Clang
clang.cindex.Config.set_library_file('/usr/lib/llvm-18/lib/libclang.so.1')

def export_ast_to_json(c_file_path, output_path):
    index = clang.cindex.Index.create()
    tu = index.parse(c_file_path)

    def serialize_node(node):
        return {
            "name": node.spelling,
            "kind": node.kind.name,
            "type": node.type.spelling,
            "location": {
                "line": node.location.line,
                "column": node.location.column
            },
            "children": [serialize_node(c) for c in node.get_children()]
        }

    ast_data = serialize_node(tu.cursor)

    with open(output_path, "w") as f:
        json.dump(ast_data, f, indent=4)
    print("✅ AST exported to ast_export.json")

# Example Usage
# export_ast_to_json('my_code.c')