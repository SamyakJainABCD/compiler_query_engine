import json
from modules.nlp_parser import NLPEngine

class QueryEngine:
    def __init__(self, ast_file='generated_files/ast_export.json',
                 ir_file='generated_files/ir_export.json',
                 cfg_file='generated_files/cfg_export.json',
                 sem_log='generated_files/semantic_metadata.log'
    ):
        with open(ast_file, 'r') as f: self.ast_data = json.load(f)
        with open(ir_file, 'r') as f: self.ir_data = json.load(f)
        with open(cfg_file, 'r') as f: self.cfg_data = json.load(f)

        try:
            with open(sem_log, 'r') as f: self.sem_data = json.load(f)
        except:
            self.sem_data = []

    def execute(self, intent):
        # Check for parsing errors
        if "error" in intent:
            return intent["error"]
        
        query_type = intent.get('query_type', 'standard')
        layer = intent.get('layer')
        target = intent.get('target')
        scope = intent.get('scope')
        name = intent.get('name')
        attributes = intent.get('attributes', [])
        action = intent.get('action')

        # Handle reachability queries
        if query_type == 'reachability':
            if not name or not scope:
                return "❌ Reachability queries require quoted identifiers: is \"target\" reachable from \"source\""
            target_block = name  # e.g., "error_handler"
            source_func = scope  # e.g., "main"
            return self._check_reachability(target_block, source_func)

        print(f"\n🔍 Searching {layer} for {target}...")

        if "unused" in attributes:
            return self.resolve_semantic_query(intent)
        if layer == 'AST':
            # If searching for a specific variable/function and one was given
            if name:
                results = self._search_ast(self.ast_data, target, scope, name, attributes)
            # If no name provided but target requires it (function/variable)
            elif target in ['variable', 'function']:
                return f"❌ Please provide a quoted {target} name. Example: find {target} \"name\""
            # Generic search without specific name
            else:
                results = self._search_ast(self.ast_data, target, scope, name, attributes)
            
            # If the user asked to "count", return the length instead of the list
            # if action == "count":
            #     return f"I found {len(results)} {target}(s) matching your criteria."
            
            return results if results else f"No {target}s found."

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
                return self._format_cfg_output(self.cfg_data[scope], scope)
            return f"No Control Flow Graph found for function: {scope}"

    def _check_reachability(self, target_block, source_func):
        """
        Check if a target block/function is reachable from a source function.
        Uses inter-procedural analysis through the call graph.
        Args:
            target_block: The block/function name we're checking reachability for (e.g., "error_handler")
            source_func: The function name to start from (e.g., "main")
        Returns:
            A message indicating reachability and the path if reachable
        """
        # Extract call graph from CFG
        call_graph = self.cfg_data.get("_call_graph", {})
        
        if not source_func:
            return f"❌ Please specify a source function (e.g., 'from main')"
        
        if source_func not in self.cfg_data:
            return f"❌ Function '{source_func}' not found in the CFG."
        
        # Check if target is a function in the call graph
        is_function = target_block in call_graph or target_block in self.cfg_data
        
        if not is_function and target_block not in self.cfg_data:
            return f"❌ Target '{target_block}' not found in the CFG."
        
        # Perform BFS to find if target_block is reachable from source_func
        from collections import deque
        
        queue = deque([(source_func, [source_func])])
        visited = {source_func}
        
        while queue:
            current_func, path = queue.popleft()
            
            # Check if we reached the target
            if current_func == target_block:
                path_str = " → ".join(path)
                return f"✅ YES, '{target_block}' is reachable from '{source_func}'\n   Call Chain: {path_str}"
            
            # Get the functions called by current_func
            if current_func in call_graph:
                for called_func in call_graph[current_func]:
                    # Only check functions that are in our CFG (skip external functions)
                    if called_func in call_graph or called_func in self.cfg_data:
                        if called_func not in visited:
                            visited.add(called_func)
                            queue.append((called_func, path + [called_func]))
        
        return f"❌ NO, '{target_block}' is NOT reachable from '{source_func}'"

    def _search_ast(self, node, target, scope, name=None, attributes=None, results=None, current_scope="Global"):
        if results is None: results = []
        if attributes is None: attributes = []
        
        kind_map = {"function": "FUNCTION_DECL", "variable": ["VAR_DECL", "PARM_DECL"]}
        search_kind = kind_map.get(target)

        # If we find the target (variable or function)
        # Handle both single kind (function) and multiple kinds (variable = VAR_DECL + PARM_DECL)
        is_target_kind = False
        if isinstance(search_kind, list):
            is_target_kind = node.get('kind') in search_kind
        else:
            is_target_kind = node.get('kind') == search_kind
        
        if is_target_kind:
            type_match = any(attr in node.get('type', '').lower() for attr in attributes)
            # Check if we're in the right scope (function)
            scope_match = (scope is None or scope.lower() == "all" or current_scope.lower() == scope.lower())
            # Check if the name matches (if specified)
            name_match = (name is None or node.get('name', '').lower() == name.lower())

            if (type_match or not attributes) and scope_match and name_match:
                # ADDED: Include the current_scope in the result
                results.append({
                    "name": node['name'], 
                    "type": node['type'],
                    "found_in": current_scope  # This tells you which function it's in
                })

        # Update the 'current_scope' if we are entering a function (for children traversal)
        next_scope = current_scope
        if node.get('kind') == "FUNCTION_DECL":
            next_scope = node.get('name', 'Unknown')

        # Recursive call: Pass the updated scope down to children
        for child in node.get('children', []):
            self._search_ast(child, target, scope, name, attributes, results, next_scope)
        
        return results
    
    def resolve_semantic_query(self, intent):
        attributes = intent.get('attributes', [])
        target = intent.get('target')

        if "unused" in attributes and target == "variable":
            unused_vars = self._detect_unused_variables()
            
            if not unused_vars:
                return "✅ All variables are used."
            
            # Format results by function
            result = "🚫 Unused variables detected:\n"
            for func_name, vars_list in unused_vars.items():
                result += f"  • {func_name}: {', '.join(vars_list)}\n"
            return result.rstrip()

    def _detect_unused_variables(self):
        """
        Analyze IR to find truly unused variables by checking load/store patterns.
        Returns: {function_name: [unused_var_names]}
        """
        unused_by_function = {}
        
        for func in self.ir_data.get('functions', []):
            func_name = func['name']
            
            # Get function node from AST to identify parameters
            func_node = self._find_function_in_ast(func_name)
            params = self._extract_params_in_function(func_node) if func_node else []
            
            # Build a map: IR address (%5, %6, etc.) -> original variable name
            addr_to_varname = self._build_var_mapping(func_name)
            
            # Analyze load/store patterns
            var_usage = self._analyze_var_usage(func)
            
            unused = []
            for ir_addr, usage_info in var_usage.items():
                # Variable is unused if it has stores but NO loads
                if usage_info['stores'] > 0 and usage_info['loads'] == 0:
                    # Map back to original variable name
                    var_name = addr_to_varname.get(ir_addr)
                    # Only add if we successfully mapped it (not an unmapped IR address)
                    # And exclude parameters (they're intentional, even if unused)
                    if var_name and not var_name.startswith('%') and var_name not in params:
                        unused.append(var_name)
            
            if unused:
                unused_by_function[func_name] = unused
        
        return unused_by_function
    
    def _build_var_mapping(self, func_name):
        """
        Map IR addresses (%5, %6, ...) to original C variable names by correlating
        AST declaration order with allocation order in IR.
        Returns: {"%5": "r", "%6": "s", ...}
        """
        mapping = {}
        
        # Find the matching function in AST
        func_node = self._find_function_in_ast(func_name)
        if not func_node:
            return mapping
        
        # Extract all variables (parameters first, then locals) in declaration order
        params = self._extract_params_in_function(func_node)
        locals_vars = self._extract_vars_in_function(func_node)
        all_vars = params + locals_vars
        
        # Find the first allocation address in this function's IR
        first_alloc_addr = None
        for block in self.ir_data.get('functions', []):
            if block['name'] == func_name:
                for b in block.get('blocks', []):
                    for instr in b.get('instructions', []):
                        if 'alloca' in instr and '=' in instr:
                            parts = instr.split('=')
                            if len(parts) >= 2:
                                addr = parts[0].strip()
                                try:
                                    num = int(addr.lstrip('%'))
                                    if first_alloc_addr is None:
                                        first_alloc_addr = num
                                except:
                                    pass
        
        # Build mapping: offset each variable by the first allocation number
        if first_alloc_addr is not None:
            for i, var_name in enumerate(all_vars):
                addr = f"%{first_alloc_addr + i}"
                mapping[addr] = var_name
        
        return mapping
    
    def _find_function_in_ast(self, func_name):
        """Find a function node in AST by name."""
        def search(node):
            if node.get('kind') == 'FUNCTION_DECL' and node.get('name') == func_name:
                return node
            for child in node.get('children', []):
                result = search(child)
                if result:
                    return result
            return None
        
        return search(self.ast_data)
    
    
    def _extract_params_in_function(self, func_node, params=None):
        """Extract all parameter declarations from a function."""
        if params is None:
            params = []
        # Parameters are usually in the function's parameter list
        for child in func_node.get('children', []):
            if child.get('kind') == 'PARM_DECL':
                params.append(child.get('name'))
        return params
    
    def _extract_vars_in_function(self, func_node, vars_list=None):
        """Extract all variable declarations within a single function."""
        if vars_list is None:
            vars_list = []
        if func_node.get('kind') == 'VAR_DECL':
            vars_list.append(func_node.get('name'))
        for child in func_node.get('children', []):
            self._extract_vars_in_function(child, vars_list)
        return vars_list
    
    def _analyze_var_usage(self, func):
        """
        Analyze load/store patterns for each variable in a function.
        Returns: {%5: {'loads': int, 'stores': int}, ...}
        """
        var_usage = {}
        
        # Pass through all blocks and instructions
        for block in func.get('blocks', []):
            for instr in block.get('instructions', []):
                # Pattern: "store <type> <value>, ptr %X, ..."
                if 'store' in instr and 'ptr %' in instr:
                    # Extract address - find "ptr %" then get the number
                    idx = instr.find('ptr %')
                    if idx != -1:
                        rest = instr[idx + 5:]  # Skip "ptr %"
                        # Extract just the number
                        addr_num = ''
                        for char in rest:
                            if char.isdigit():
                                addr_num += char
                            else:
                                break
                        if addr_num:
                            addr = '%' + addr_num
                            if addr not in var_usage:
                                var_usage[addr] = {'loads': 0, 'stores': 0}
                            var_usage[addr]['stores'] += 1
                
                # Pattern: "%X = load <type>, ptr %Y"
                elif 'load' in instr and 'ptr %' in instr:
                    idx = instr.find('ptr %')
                    if idx != -1:
                        rest = instr[idx + 5:]  # Skip "ptr %"
                        # Extract just the number
                        addr_num = ''
                        for char in rest:
                            if char.isdigit():
                                addr_num += char
                            else:
                                break
                        if addr_num:
                            addr = '%' + addr_num
                            if addr not in var_usage:
                                var_usage[addr] = {'loads': 0, 'stores': 0}
                            var_usage[addr]['loads'] += 1
        
        return var_usage

def interactive_session():
    nlp = NLPEngine()

    print("\n💬 Compiler Query Interface Active. (Type 'exit' to quit)")
    print("📝 Note: Function and variable names must be provided in quotes.")
    print("   Examples:")
    print('   - find function "main"')
    print('   - find variable "x" in "main"')
    print('   - is "error_handler" reachable from "main"?')
    
    while True:
        user_input = input("\n👉 Ask about your code: ")
        if user_input.lower() in ['exit', 'quit']: break
        
        # Step 1: Extract Intent
        intent = nlp.parse_query(user_input)
        
        # Step 2: Execute Query
        if intent.get("target"):
            result = qe.execute(intent)
            print(f"🤖 Result: {result}")
        else:
            print("🤖 Sorry, I couldn't identify if you want to see a function, variable, or IR.")


# --- Example Usage ---
if __name__ == "__main__":
    qe = QueryEngine(ast_file='generated_files/ast_export.json', ir_file='generated_files/ir_export.json', cfg_file='generated_files/cfg_export.json')
    interactive_session()

def test():
    test_cases = [
        {
            "description": "Scenario 1: Global AST Search (Find all functions)",
            "intent": {'action': 'find', 'target': 'function', 'layer': 'AST', 'scope': None}
        },
        {
            "description": "Scenario 2: Scoped AST Search (Find specific variable)",
            "intent": {'action': 'find', 'target': 'variable', 'layer': 'AST', 'scope': 'result'}
        },
        {
            "description": "Scenario 3: IR Logic Check (Show instructions for 'add')",
            "intent": {'action': 'show', 'target': 'instruction', 'layer': 'IR', 'scope': 'add'}
        },
        {
            "description": "Scenario 4: CFG Connectivity (Show graph structure for 'main')",
            "intent": {'action': 'graph', 'target': 'cfg', 'layer': 'CFG', 'scope': 'main'}
        },
        {
            "description": "Scenario 5: Error Handling (Search non-existent function)",
            "intent": {'action': 'find', 'target': 'function', 'layer': 'AST', 'scope': 'non_existent_func'}
        }
    ]

    for case in test_cases:
        print(f"\n{'='*60}")
        print(f"RUNNING TEST: {case['description']}")
        print(f"{'='*60}")
        result = qe.execute(case['intent'])
        
        # Pretty print the results
        if isinstance(result, (list, dict)):
            print(json.dumps(result, indent=2))
        else:
            print(result)

'''
Find all unused variables
find function 'process_value'
Find variable 'val' in 'process_value'
Find variable 'x'
Is the 'error_handler' block reachable from 'main'? (CFG)
Show instructions for 'add'
'''
 