import json
import os

class MappingEngine:
    def __init__(self, output_dir='output'):
        self.output_dir = output_dir
        
    def load_data(self, filename):
        path = os.path.join(self.output_dir, filename)
        if os.path.exists(path):
            with open(path, 'r') as f: return json.load(f)
        return None

    def resolve_unused_variables(self, scope=None):
        """
        Logic: CROSS-LAYER MAPPING
        1. Get all variables from AST.
        2. Get all 'load' and 'store' instructions from IR.
        3. If a variable name exists in AST but its pointer is never used in IR, it's unused.
        """
        ast = self.load_data('ast_export.json')
        ir = self.load_data('ir_export.json')
        
        # 1. Extract declared vars from AST
        declared_vars = self._extract_vars(ast, scope) # List of names
        
        # 2. Extract used pointers from IR
        # In LLVM IR, variables usually look like %name or @name
        ir_text = json.dumps(ir)
        unused = []
        
        for var in declared_vars:
            # Simple check: Is the variable name mentioned in the IR instructions?
            # (In a real compiler, we'd check pointer aliases, but this works for Week 8)
            if f"%{var}" not in ir_text and f"@{var}" not in ir_text:
                unused.append(var)
        
        return unused

    def _extract_vars(self, node, scope, found=None):
        if found is None: found = []
        if node.get('kind') == 'VAR_DECL':
            found.append(node.get('name'))
        for child in node.get('children', []):
            self._extract_vars(child, scope, found)
        return found

    def translate_and_execute(self, intent):
        """The core translation logic for Week 8"""
        action = intent.get('action')
        target = intent.get('target')
        attributes = intent.get('attributes', [])
        
        # Log the translation (Week 8 Deliverable)
        log_entry = f"TRANSLATE: {action} {target} WITH ATTRS {attributes}"
        print(f"📝 {log_entry}")

        # Mapping Logic
        if "unused" in attributes and target == "variable":
            return self.resolve_unused_variables(intent.get('scope'))
            
        if target == "cfg":
            cfg = self.load_data('cfg_export.json')
            return cfg.get(intent.get('scope'), "CFG not found")

        return "Mapping for this specific intent is not yet implemented."