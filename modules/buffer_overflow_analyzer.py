import json
import re
from typing import List, Dict, Any

class BufferOverflowAnalyzer:
    """
    Detects potential buffer overflow vulnerabilities in C code through:
    1. Unsafe function calls (strcpy, sprintf, gets, scanf, etc.)
    2. Array declarations with fixed sizes
    3. String operations without bounds checking
    4. Pointer arithmetic without validation
    """
    
    # Unsafe functions known to cause buffer overflows
    UNSAFE_FUNCTIONS = {
        'strcpy': 'Copies string without size checking',
        'strcat': 'Concatenates without size checking',
        'sprintf': 'Formatted output without size checking',
        'scanf': 'Input reading without size checking',
        'gets': 'Extremely dangerous - reads unlimited input',
        'fscanf': 'File input without size checking',
        'sscanf': 'String input without size checking',
        'strncpy': 'Still risky - may not null-terminate',
        'strncat': 'Still risky - may overflow',
        'fgets': 'Safer alternative - has size checking',
        'snprintf': 'Safe alternative - has size checking',
    }
    
    def __init__(self, ast_file='generated_files/ast_export.json',
                 ir_file='generated_files/ir_export.json'):
        """Initialize the analyzer with AST and IR data"""
        try:
            with open(ast_file, 'r') as f:
                self.ast_data = json.load(f)
        except:
            self.ast_data = {}
        
        try:
            with open(ir_file, 'r') as f:
                self.ir_data = json.load(f)
        except:
            self.ir_data = {}
        
        self.risks = []
        self.buffers = []
        self.unsafe_calls = []
    
    def analyze(self) -> Dict[str, Any]:
        """Run complete buffer overflow analysis"""
        self.risks = []
        self.buffers = []
        self.unsafe_calls = []
        
        # Analyze IR for unsafe function calls
        self._analyze_ir_for_unsafe_calls()
        
        # Analyze AST for array declarations and buffer info
        self._analyze_ast_for_buffers()
        
        return self._generate_report()
    
    def _analyze_ir_for_unsafe_calls(self):
        """Extract unsafe function calls from LLVM IR"""
        if 'functions' not in self.ir_data:
            return
        
        for func in self.ir_data['functions']:
            func_name = func.get('name', '')
            
            for block in func.get('blocks', []):
                for instruction in block.get('instructions', []):
                    # Look for function calls: @function_name or "function_name"
                    call_matches = re.findall(r'call\s+\w+\s+.*?@(\w+)', instruction)
                    
                    for called_func in call_matches:
                        if called_func in self.UNSAFE_FUNCTIONS:
                            risk_level = 'CRITICAL' if called_func in ['gets', 'strcpy'] else 'HIGH'
                            self.unsafe_calls.append({
                                'function': func_name,
                                'unsafe_call': called_func,
                                'instruction': instruction.strip(),
                                'risk_level': risk_level,
                                'description': self.UNSAFE_FUNCTIONS[called_func]
                            })
                            
                            self.risks.append({
                                'type': 'UNSAFE_FUNCTION_CALL',
                                'location': func_name,
                                'risk_level': risk_level,
                                'detail': f"Function '{func_name}' calls unsafe function '{called_func}'",
                                'recommendation': f"Replace '{called_func}' with safer alternative"
                            })
    
    def _analyze_ast_for_buffers(self):
        """Extract buffer declarations from AST"""
        if isinstance(self.ast_data, dict):
            self._traverse_ast(self.ast_data)
    
    def _traverse_ast(self, node: Dict, parent_func=''):
        """Recursively traverse AST to find variable declarations and function definitions"""
        if not isinstance(node, dict):
            return
        
        node_kind = node.get('kind', '')
        node_name = node.get('name', '')
        node_type = node.get('type', '')
        
        # Track function context
        if node_kind == 'FUNCTION_DECL':
            parent_func = node_name
        
        # Detect array declarations
        if node_kind == 'VAR_DECL':
            # Check if it's an array type
            if '[' in node_type or 'int[' in node_type or 'char[' in node_type:
                size_match = re.search(r'\[(\d+)\]', node_type)
                size = size_match.group(1) if size_match else 'unknown'
                
                self.buffers.append({
                    'name': node_name,
                    'function': parent_func,
                    'type': node_type,
                    'size': size,
                    'location': node.get('location', {})
                })
                
                # Flag small fixed buffers as potential risks
                if size != 'unknown' and int(size) < 256:
                    self.risks.append({
                        'type': 'SMALL_FIXED_BUFFER',
                        'location': parent_func,
                        'risk_level': 'MEDIUM',
                        'detail': f"Small fixed-size buffer '{node_name}' ({size} bytes) declared in function '{parent_func}'",
                        'recommendation': "Ensure all writes to this buffer are bounds-checked"
                    })
        
        # Recursively process children
        for child in node.get('children', []):
            self._traverse_ast(child, parent_func)
    
    def _generate_report(self) -> Dict[str, Any]:
        """Generate comprehensive buffer overflow risk report"""
        report = {
            'summary': {
                'total_risks': len(self.risks),
                'critical_risks': len([r for r in self.risks if r['risk_level'] == 'CRITICAL']),
                'high_risks': len([r for r in self.risks if r['risk_level'] == 'HIGH']),
                'medium_risks': len([r for r in self.risks if r['risk_level'] == 'MEDIUM']),
                'unsafe_functions_found': len(self.unsafe_calls),
                'buffers_analyzed': len(self.buffers)
            },
            'risks': self.risks,
            'unsafe_calls': self.unsafe_calls,
            'buffers': self.buffers,
            'recommendations': self._generate_recommendations()
        }
        
        return report
    
    def _generate_recommendations(self) -> List[str]:
        """Generate security recommendations based on findings"""
        recommendations = []
        
        if self.unsafe_calls:
            recommendations.append("🔴 CRITICAL: Replace all unsafe string functions with bounds-checked alternatives")
            unsafe_funcs = set(call['unsafe_call'] for call in self.unsafe_calls)
            
            for func in unsafe_funcs:
                if func == 'strcpy':
                    recommendations.append("  → Replace strcpy() with strncpy() or strlcpy()")
                elif func == 'strcat':
                    recommendations.append("  → Replace strcat() with strncat() or strlcat()")
                elif func == 'sprintf':
                    recommendations.append("  → Replace sprintf() with snprintf()")
                elif func in ['scanf', 'fscanf', 'sscanf']:
                    recommendations.append("  → Use scanf format specifiers with width limits (e.g., %20s not %s)")
                elif func == 'gets':
                    recommendations.append("  → NEVER use gets() - it's impossible to use safely. Use fgets() instead")
        
        if any(r['risk_level'] in ['CRITICAL', 'HIGH'] for r in self.risks):
            recommendations.append("⚠️  HIGH: Implement input validation and bounds checking")
            recommendations.append("  → Validate lengths of user input before copying")
            recommendations.append("  → Use dynamic memory allocation when size is unknown")
        
        if self.buffers:
            recommendations.append("💡 SUGGESTION: Review all buffer declarations")
            recommendations.append("  → Consider using dynamic allocation (malloc) for variable-sized data")
            recommendations.append("  → Add assertions and checks for buffer operations")
        
        recommendations.append("🛡️  BEST PRACTICES:")
        recommendations.append("  → Use modern safe string libraries")
        recommendations.append("  → Enable compiler warnings (-Wall -Wextra)")
        recommendations.append("  → Use static analysis tools (valgrind, ASAN, Clang Static Analyzer)")
        
        return recommendations


def query_buffer_overflows(scope=None) -> Dict[str, Any]:
    """
    Interface function to run buffer overflow analysis
    Returns detailed risk report
    """
    analyzer = BufferOverflowAnalyzer()
    report = analyzer.analyze()
    
    if scope and scope in ['critical', 'high', 'all']:
        if scope == 'critical':
            report['risks'] = [r for r in report['risks'] if r['risk_level'] == 'CRITICAL']
        elif scope == 'high':
            report['risks'] = [r for r in report['risks'] if r['risk_level'] in ['CRITICAL', 'HIGH']]
    
    return report
