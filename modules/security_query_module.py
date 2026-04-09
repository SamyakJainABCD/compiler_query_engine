from typing import Dict, Any
from modules.buffer_overflow_analyzer import BufferOverflowAnalyzer

class SecurityQueryModule:
    """
    Handles security-specific queries targeting vulnerabilities and checks.
    Supports queries like:
    - "Show security checks"
    - "List unsafe function calls"
    - "Analyze security vulnerabilities"
    """
    
    def __init__(self):
        self.buffer_analyzer = BufferOverflowAnalyzer()
    
    def process_query(self, query_intent: Dict[str, Any]) -> Dict[str, Any]:
        """
        Process a security-focused query
        Args:
            query_intent: Intent dictionary from NLP parser
        Returns:
            Query results
        """
        target = query_intent.get('target', '')
        action = query_intent.get('action', 'show')
        scope = query_intent.get('scope', None)
        
        
        if 'buffer' in target.lower() or 'overflow' in target.lower():
            return self._handle_buffer_overflow_query(action, scope)
        
        elif 'unsafe' in target.lower() or 'dangerous' in target.lower():
            return self._handle_unsafe_calls_query(action, scope)
        
        elif 'security' in target.lower() or 'vulnerability' in target.lower():
            return self._handle_comprehensive_security_query(action, scope)
        
        else:
            return {
                'error': f"Unknown security target: {target}",
                'supported_queries': [
                    'buffer overflow',
                    'unsafe function calls',
                    'security vulnerabilities'
                ]
            }

    
    def _handle_buffer_overflow_query(self, action: str, scope: str = None) -> Dict[str, Any]:
        """Handle buffer overflow vulnerability queries"""
        analyzer = BufferOverflowAnalyzer()
        report = analyzer.analyze()
        
        # Filter by scope if specified
        if scope in ['critical', 'high', 'medium']:
            report['risks'] = [r for r in report['risks'] if r['risk_level'] == scope.upper()] + \
                            ([r for r in report['risks'] if r['risk_level'] == 'CRITICAL'] if scope == 'high' else [])
        
        if action in ['count', 'list']:
            return {
                'query_type': 'buffer_overflow',
                'action': action,
                'summary': report['summary'],
                'items': report['risks'] if action == 'list' else len(report['risks']),
                'critical_count': report['summary']['critical_risks'],
                'high_count': report['summary']['high_risks'],
                'medium_count': report['summary']['medium_risks']
            }
        
        else:  # show/analyze
            return {
                'query_type': 'buffer_overflow_detailed',
                'summary': report['summary'],
                'risks': report['risks'],
                'unsafe_calls': report['unsafe_calls'],
                'buffers': report['buffers'],
                'recommendations': report['recommendations']
            }
    
    def _handle_unsafe_calls_query(self, action: str, scope: str = None) -> Dict[str, Any]:
        """Handle unsafe function calls queries"""
        analyzer = BufferOverflowAnalyzer()
        report = analyzer.analyze()
        
        unsafe_calls = report.get('unsafe_calls', [])
        
        # Filter by risk level if specified
        if scope in ['critical', 'high']:
            unsafe_calls = [c for c in unsafe_calls if c['risk_level'] == scope.upper()]
        
        if action in ['count', 'list']:
            return {
                'query_type': 'unsafe_calls',
                'action': action,
                'items': unsafe_calls if action == 'list' else len(unsafe_calls),
                'total_unsafe_calls': len(report['unsafe_calls']),
                'critical_calls': len([c for c in report['unsafe_calls'] if c['risk_level'] == 'CRITICAL']),
                'high_calls': len([c for c in report['unsafe_calls'] if c['risk_level'] == 'HIGH']),
                'unsafe_functions': list(set(c['unsafe_call'] for c in report['unsafe_calls']))
            }
        
        else:  # show/analyze
            return {
                'query_type': 'unsafe_calls_detailed',
                'unsafe_calls': unsafe_calls,
                'summary': {
                    'total': len(unsafe_calls),
                    'critical': len([c for c in unsafe_calls if c['risk_level'] == 'CRITICAL']),
                    'high': len([c for c in unsafe_calls if c['risk_level'] == 'HIGH'])
                },
                'functions_with_unsafe_calls': list(set(c['function'] for c in unsafe_calls)),
                'recommendations': report['recommendations']
            }
    
    
def execute_security_query(query_intent: Dict[str, Any]) -> Dict[str, Any]:
    """
    Execute a security query
    Args:
        query_intent: Intent dictionary from NLP parser
    Returns:
        Query result
    """
    module = SecurityQueryModule()
    return module.process_query(query_intent)
