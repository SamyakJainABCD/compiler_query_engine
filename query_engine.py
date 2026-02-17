import json

class QueryEngine:
    def __init__(self, ast_file='ast_export.json', ir_file='ir_export.json', cfg_file='cfg_export.json'):
        with open(ast_file, 'r') as f: self.ast_data = json.load(f)
        with open(ir_file, 'r') as f: self.ir_data = json.load(f)
        with open(cfg_file, 'r') as f: self.cfg_data = json.load(f)

    def execute(self, intent):
        """
        intent format: {'action': 'find', 'target': 'function', 'layer': 'AST', 'scope': 'main'}
        """
        layer = intent.get('layer')
        target = intent.get('target')
        scope = intent.get('scope')

        print(f"\n🔍 Searching {layer} for {target}...")

        # --- AST LAYER QUERIES ---
        if layer == 'AST':
            results = self._search_ast(self.ast_data, target, scope)
            return results if results else "No matches found in AST."

        # --- IR LAYER QUERIES ---
        elif layer == 'IR':
            # Example: Find instructions in a specific function
            for func in self.ir_data['functions']:
                if func['name'] == scope or scope is None:
                    return func['blocks']
            return "Function not found in IR."

        # --- CFG LAYER QUERIES ---
        elif layer == 'CFG':
            if scope in self.cfg_data:
                return self.cfg_data[scope]
            return f"No Control Flow Graph found for function: {scope}"

    def _search_ast(self, node, target, scope, results=None):
        if results is None: results = []
        
        # Logic: If target is 'function', look for FUNCTION_DECL
        kind_map = {"function": "FUNCTION_DECL", "variable": "VAR_DECL"}
        search_kind = kind_map.get(target)

        if node.get('kind') == search_kind:
            if scope is None or scope in node.get('name'):
                results.append({"name": node['name'], "type": node['type']})

        for child in node.get('children', []):
            self._search_ast(child, target, scope, results)
        
        return results

# --- Example Usage ---
if __name__ == "__main__":
    qe = QueryEngine(ast_file='generated_files/ast_export.json', ir_file='generated_files/ir_export.json', cfg_file='generated_files/cfg_export.json')
    
    # Simulating what your NLP Engine would output:
    mock_intent = {'action': 'find', 'target': 'function', 'layer': 'AST', 'scope': 'foo'}
    
    print(qe.execute(mock_intent))