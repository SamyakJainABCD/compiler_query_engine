#!/usr/bin/env python3
"""
Week 12: Robustness & Edge Case Handling
Test system with ambiguous queries and malformed compiler inputs.
Generates: Bug-fix documentation and adversarial query test report.
"""

import json
import time
import sys
import re
from typing import Dict, List, Any, Tuple
from modules.nlp_parser import NLPEngine
from query_engine import QueryEngine

class AdversarialTestSuite:
    """
    Comprehensive adversarial test suite for robustness testing.
    Tests:
    - Ambiguous queries (unclear intent)
    - Malformed inputs (invalid syntax)
    - Edge cases (empty strings, special chars, extreme values)
    - Boundary conditions
    - Error recovery
    """
    
    def __init__(self):
        self.nlp = NLPEngine()
        self.engine = QueryEngine()
        self.test_results = {
            'ambiguous_queries': [],
            'malformed_inputs': [],
            'edge_cases': [],
            'boundary_conditions': [],
            'error_recovery': [],
            'summary': {}
        }
        self.bugs_found = []
    
    def run_complete_suite(self) -> Dict[str, Any]:
        """Run complete adversarial test suite"""
        print("\n" + "="*100)
        print("WEEK 12: ADVERSARIAL TEST SUITE - ROBUSTNESS & EDGE CASE HANDLING")
        print("="*100)
        
        results = {
            'ambiguous_queries': self.test_ambiguous_queries(),
            'malformed_inputs': self.test_malformed_inputs(),
            'edge_cases': self.test_edge_cases(),
            'boundary_conditions': self.test_boundary_conditions(),
            'error_recovery': self.test_error_recovery(),
            'summary': {}
        }
        
        results['summary'] = self._compute_summary(results)
        results['bugs_found'] = self.bugs_found
        return results
    
    def test_ambiguous_queries(self) -> Dict[str, Any]:
        """Test queries with ambiguous intent"""
        print("\n🔀 AMBIGUOUS QUERIES TEST")
        print("-" * 100)
        
        ambiguous_queries = [
            # Ambiguous action (could mean find or list or show)
            ("function", "unclear action", "Missing action verb"),
            ("main", "unclear target", "Missing query type"),
            ("find", "incomplete query", "Missing target object"),
            
            # Ambiguous scope
            ("find variable in main", "unclear scope", "'main' could be function or module"),
            ("check x reachable from y", "unclear relationship", "Missing question mark for reachability"),
            
            # Ambiguous context (no quotes provided)
            ("find function main", "missing quotes", "Should be 'main' not main"),
            ("list unused variable buffer", "ambiguous target", "Could be variable 'buffer' or buffer-related query"),
            
            # Contradictory intent
            ("find all specific function", "contradictory", "Specific vs all are contradictory"),
            ("show unused used variable", "contradictory", "Unused vs used are contradictory"),
            ("list empty non-empty arrays", "contradictory", "Empty vs non-empty contradiction"),
            
            # Vague queries
            ("what is this code?", "too vague", "No specific target"),
            ("find stuff", "too vague", "Not a recognized target"),
            ("tell me something about the code", "too vague", "No actionable intent"),
            
            # Missing key context
            ("reachable?", "incomplete reachability", "Missing source and target"),
            ("is reachable from", "incomplete parameters", "Missing both function names"),
        ]
        
        results = []
        for query, category, details in ambiguous_queries:
            test_start = time.time()
            try:
                intent = self.nlp.parse_query(query)
                latency = (time.time() - test_start) * 1000
                
                # Check if error was properly detected
                has_error = "error" in intent or intent.get('target') is None
                
                result = {
                    'query': query,
                    'category': category,
                    'details': details,
                    'parsed_intent': intent,
                    'has_error': has_error,
                    'latency_ms': latency,
                    'status': '✅ PASS' if has_error else '⚠️ PARTIAL'
                }
                
                results.append(result)
                
                # Log bugs
                if not has_error:
                    self.bugs_found.append({
                        'type': 'Ambiguous Query Not Caught',
                        'query': query,
                        'issue': f"Query '{query}' should have been rejected but parsed as: {intent}",
                        'severity': 'MEDIUM'
                    })
                
                print(f"  {'✅' if has_error else '⚠️'} {query:40} → {category:20} [{latency:.2f}ms]")
                
            except Exception as e:
                result = {
                    'query': query,
                    'category': category,
                    'details': details,
                    'error': str(e),
                    'status': '❌ EXCEPTION',
                    'latency_ms': (time.time() - test_start) * 1000
                }
                results.append(result)
                
                self.bugs_found.append({
                    'type': 'Unhandled Exception',
                    'query': query,
                    'error': str(e),
                    'severity': 'HIGH'
                })
                
                print(f"  ❌ {query:40} → EXCEPTION: {str(e)[:40]}")
        
        return {
            'test_name': 'Ambiguous Queries',
            'total': len(results),
            'passed': sum(1 for r in results if r['status'].startswith('✅')),
            'details': results
        }
    
    def test_malformed_inputs(self) -> Dict[str, Any]:
        """Test malformed and invalid inputs"""
        print("\n🚫 MALFORMED INPUTS TEST")
        print("-" * 100)
        
        malformed_queries = [
            # Invalid characters
            ("find function \"main; drop table;\"", "SQL injection attempt", "Dangerous characters"),
            ("find function \"main\\x00\"", "null byte injection", "Null terminator"),
            ("find variable \"x\\\\n\\\\r\\\\t\"", "escape sequence injection", "Control characters"),
            
            # Invalid identifiers
            ("find function \"123invalid\"", "starts with number", "Valid C identifier rule broken"),
            ("find function \"my-function\"", "hyphen in identifier", "Invalid C identifier character"),
            ("find function \"my function\"", "space in identifier", "Spaces not allowed in C identifiers"),
            ("find function \"function(x)\"", "parentheses in identifier", "Special characters in identifier"),
            ("find function \"@invalid\"", "special char at start", "@/$%& not valid identifier"),
            
            # Excessive length
            ("find function \"" + "a" * 500 + "\"", "identifier too long", "Exceeds 255 char limit"),
            
            # Empty/null values
            ("find function \"\"", "empty identifier", "Empty quoted string"),
            ("find variable ''", "empty single quotes", "Empty string with single quotes"),
            ("list functions in", "incomplete parameters", "Missing function name after 'in'"),
            
            # Malformed quotes
            ("find function 'main\"", "mismatched quotes", "Single quote opened, double closed"),
            ("find function \"main'", "mismatched quotes", "Double quote opened, single closed"),
            ("find function \"main", "unclosed quote", "Missing closing quote"),
            ("find function main\"", "quote at wrong position", "Closing quote without opening"),
            
            # Compiler malformations (file inputs)
            ("", "empty input", "Empty query string"),
            ("   ", "whitespace only", "Only spaces/tabs"),
            ("\\n\\n\\n", "newlines only", "Control characters only"),
            ("find function \"\\x00main\"", "embedded null bytes", "Null byte in middle"),
        ]
        
        results = []
        for query, category, details in malformed_queries:
            test_start = time.time()
            try:
                intent = self.nlp.parse_query(query)
                latency = (time.time() - test_start) * 1000
                
                # Check if error was properly detected
                has_error = "error" in intent or len(query.strip()) == 0
                
                result = {
                    'query': query[:50] + '...' if len(query) > 50 else query,
                    'category': category,
                    'details': details,
                    'parsed_intent': intent,
                    'has_error': has_error,
                    'latency_ms': latency,
                    'status': '✅ PASS' if has_error else '⚠️ PARTIAL'
                }
                
                results.append(result)
                
                if not has_error and len(query.strip()) > 0:
                    self.bugs_found.append({
                        'type': 'Malformed Input Not Caught',
                        'query': query[:80],
                        'issue': f"Malformed query should have been rejected: {category}",
                        'severity': 'HIGH'
                    })
                
                print(f"  {'✅' if has_error else '⚠️'} {category:30} [{latency:.2f}ms]")
                
            except Exception as e:
                result = {
                    'query': query[:50],
                    'category': category,
                    'details': details,
                    'error': str(e),
                    'status': '❌ EXCEPTION',
                    'latency_ms': (time.time() - test_start) * 1000
                }
                results.append(result)
                
                self.bugs_found.append({
                    'type': 'Unhandled Exception in Malformed Input',
                    'category': category,
                    'error': str(e),
                    'severity': 'CRITICAL'
                })
                
                print(f"  ❌ {category:30} → EXCEPTION")
        
        return {
            'test_name': 'Malformed Inputs',
            'total': len(results),
            'passed': sum(1 for r in results if r['status'].startswith('✅')),
            'details': results
        }
    
    def test_edge_cases(self) -> Dict[str, Any]:
        """Test edge cases and boundary behaviors"""
        print("\n⚡ EDGE CASES TEST")
        print("-" * 100)
        
        edge_cases = [
            # Case sensitivity
            ("FIND FUNCTION \"main\"", "all caps", "Should be case-insensitive"),
            ("FiNd FuNcTiOn \"main\"", "mixed case", "Random capitalization"),
            ("find function \"MAIN\"", "target all caps", "Function name in caps"),
            
            # Whitespace handling
            ("  find  function  \"main\"  ", "excessive whitespace", "Multiple spaces throughout"),
            ("find\t\tfunction\t\"main\"", "tabs instead of spaces", "Tab characters"),
            ("find function \"main \"", "trailing space in identifier", "Space before closing quote"),
            ("find function \" main\"", "leading space in identifier", "Space after opening quote"),
            
            # Unicode and special chars
            ("find function \"mαin\"", "greek alpha", "Non-ASCII character"),
            ("find function \"main™\"", "trademark symbol", "Unicode symbol"),
            ("find function \"main🔒\"", "emoji in identifier", "Emoji character"),
            
            # Duplicate parameters
            ("find function \"main\" in \"main\"", "duplicate target", "Same function appears twice"),
            ("is \"x\" reachable from \"x\"?", "same source/target", "Reachability to itself"),
            
            # Very short identifiers
            ("find function \"x\"", "single char function", "Minimal valid identifier"),
            ("find variable \"_\"", "underscore only", "Single underscore"),
            
            # Mixed query types
            ("find function \"main\" and list variables", "compound query", "Multiple query types"),
            ("is \"main\" reachable and show bounds checks", "mixed query types", "Incompatible query combinations"),
        ]
        
        results = []
        for query, category, details in edge_cases:
            test_start = time.time()
            try:
                intent = self.nlp.parse_query(query)
                latency = (time.time() - test_start) * 1000
                
                # Edge case should be handled gracefully  
                is_handled = "error" not in intent or intent.get('target') is not None
                
                result = {
                    'query': query[:60] + '...' if len(query) > 60 else query,
                    'category': category,
                    'details': details,
                    'parsed_intent': intent,
                    'is_handled': is_handled,
                    'latency_ms': latency,
                    'status': '✅ PASS' if is_handled else '⚠️ FAIL'
                }
                
                results.append(result)
                print(f"  {'✅' if is_handled else '⚠️'} {category:30} [{latency:.2f}ms]")
                
            except Exception as e:
                result = {
                    'query': query[:60],
                    'category': category,
                    'error': str(e),
                    'status': '❌ EXCEPTION',
                    'latency_ms': (time.time() - test_start) * 1000
                }
                results.append(result)
                
                self.bugs_found.append({
                    'type': 'Unhandled Exception in Edge Case',
                    'category': category,
                    'error': str(e),
                    'severity': 'MEDIUM'
                })
                
                print(f"  ❌ {category:30} → EXCEPTION")
        
        return {
            'test_name': 'Edge Cases',
            'total': len(results),
            'passed': sum(1 for r in results if r['status'].startswith('✅')),
            'details': results
        }
    
    def test_boundary_conditions(self) -> Dict[str, Any]:
        """Test boundary conditions and limits"""
        print("\n📏 BOUNDARY CONDITIONS TEST")
        print("-" * 100)
        
        boundary_tests = [
            # Maximum identifier length (C standard is 255)
            ("find function \"" + "a" * 255 + "\"", "max length identifier", "255 chars (C limit)"),
            ("find function \"" + "a" * 256 + "\"", "exceeds max length", "256 chars (over limit)"),
            ("find function \"" + "a" * 1000 + "\"", "extremely long", "1000 chars"),
            
            # Deeply nested quotes
            ("find function \"a'b'c'\"", "nested single quotes", "Mixed quote types"),
            
            # Numeric boundaries
            ("find loop 0", "zero loop ID", "Numeric instead of string"),
            ("find loop -1", "negative loop ID", "Negative identifier"),
            ("find loop 999999", "large numeric", "Very large number"),
            
            # Multiple identifiers
            ("find variable \"x\" and \"y\"", "multiple variables", "AND operator"),
            ("find functions \"main\" \"helper\"", "multiple parameters", "Space-separated"),
            
            # Extreme attribute combinations
            ("find all unused exported hidden variables", "too many attributes", "Contradictory attributes"),
            ("find critical high medium low variables", "severity cascade", "Multiple levels"),
        ]
        
        results = []
        for query, category, details in boundary_tests:
            test_start = time.time()
            try:
                intent = self.nlp.parse_query(query)
                latency = (time.time() - test_start) * 1000
                
                # Should handle gracefully
                handled_ok = latency < 100  # Should respond quickly
                
                result = {
                    'query': query[:60] + '...' if len(query) > 60 else query,
                    'category': category,
                    'details': details,
                    'parsed_intent': intent,
                    'latency_ms': latency,
                    'status': '✅ PASS' if handled_ok else '⚠️ SLOW'
                }
                
                results.append(result)
                print(f"  {'✅' if handled_ok else '⚠️'} {category:30} [{latency:.2f}ms]")
                
            except Exception as e:
                result = {
                    'query': query[:60],
                    'category': category,
                    'error': str(e),
                    'status': '❌ TIMEOUT/EXCEPTION',
                    'latency_ms': (time.time() - test_start) * 1000
                }
                results.append(result)
                
                if "exceeds" in category.lower() or "long" in category.lower():
                    self.bugs_found.append({
                        'type': 'Boundary Condition Not Handled',
                        'category': category,
                        'error': str(e),
                        'severity': 'MEDIUM'
                    })
                
                print(f"  ❌ {category:30} → EXCEPTION")
        
        return {
            'test_name': 'Boundary Conditions',
            'total': len(results),
            'passed': sum(1 for r in results if r['status'].startswith('✅')),
            'details': results
        }
    
    def test_error_recovery(self) -> Dict[str, Any]:
        """Test system error recovery and resilience"""
        print("\n🔄 ERROR RECOVERY TEST")
        print("-" * 100)
        
        recovery_tests = [
            # Multiple errors in sequence
            ("find function \"main\"", "valid", "Should succeed"),
            ("find invalid", "error", "Should recover from error"),
            ("find function \"helper\"", "valid after error", "Should work after previous error"),
            
            # Partial recovery
            ("find function \"main\" in \"nonexistent\"", "partial match", "Should handle missing scope"),
            
            # Self-correction hints
            ("find fucntion \"main\"", "typo in action", "Common misspelling"),
            ("find funtion \"main\"", "typo in action", "Missing character"),
            ("find functoin \"main\"", "typo in action", "Swapped characters"),
            
            # Context preservation
            ("is \"handler\" reachable from \"main\"?", "query 1", "Store context"),
            ("is \"cleanup\" reachable from \"handler\"?", "query 2", "Different context"),
            ("find function \"main\"", "query 3", "Back to simple"),
        ]
        
        results = []
        for query, category, details in recovery_tests:
            test_start = time.time()
            try:
                intent = self.nlp.parse_query(query)
                latency = (time.time() - test_start) * 1000
                
                # Check recovery capability
                recovered_ok = True
                if category == "error":
                    recovered_ok = "error" in intent
                elif category == "valid" or category.startswith("valid"):
                    recovered_ok = "error" not in intent
                
                result = {
                    'query': query,
                    'category': category,
                    'details': details,
                    'recovered': recovered_ok,
                    'latency_ms': latency,
                    'status': '✅ PASS' if recovered_ok else '⚠️ FAIL'
                }
                
                results.append(result)
                print(f"  {'✅' if recovered_ok else '⚠️'} {category:25} [{latency:.2f}ms]")
                
            except Exception as e:
                result = {
                    'query': query,
                    'category': category,
                    'error': str(e),
                    'status': '❌ EXCEPTION',
                    'latency_ms': (time.time() - test_start) * 1000
                }
                results.append(result)
                
                self.bugs_found.append({
                    'type': 'Error Recovery Failed',
                    'query': query,
                    'error': str(e),
                    'severity': 'MEDIUM'
                })
                
                print(f"  ❌ {category:25} → EXCEPTION")
        
        return {
            'test_name': 'Error Recovery',
            'total': len(results),
            'passed': sum(1 for r in results if r['status'].startswith('✅')),
            'details': results
        }
    
    def _compute_summary(self, results: Dict[str, Any]) -> Dict[str, Any]:
        """Compute overall test summary"""
        total_tests = 0
        total_passed = 0
        
        for test_group in ['ambiguous_queries', 'malformed_inputs', 'edge_cases', 
                           'boundary_conditions', 'error_recovery']:
            if test_group in results:
                total_tests += results[test_group]['total']
                total_passed += results[test_group]['passed']
        
        success_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
        
        return {
            'total_tests': total_tests,
            'passed': total_passed,
            'failed': total_tests - total_passed,
            'success_rate': success_rate,
            'bugs_found': len(self.bugs_found),
            'critical_bugs': sum(1 for b in self.bugs_found if b.get('severity') == 'CRITICAL'),
            'high_severity': sum(1 for b in self.bugs_found if b.get('severity') == 'HIGH'),
            'medium_severity': sum(1 for b in self.bugs_found if b.get('severity') == 'MEDIUM'),
            'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
        }
    
    def generate_report(self, results: Dict[str, Any]) -> str:
        """Generate human-readable test report"""
        report = []
        report.append("=" * 100)
        report.append("WEEK 12: ADVERSARIAL TEST REPORT - ROBUSTNESS & EDGE CASE HANDLING")
        report.append("=" * 100)
        
        summary = results['summary']
        report.append(f"\n📊 TEST SUMMARY")
        report.append(f"  Total Tests:        {summary['total_tests']}")
        report.append(f"  Passed:             {summary['passed']} ✅")
        report.append(f"  Failed:             {summary['failed']} ❌")
        report.append(f"  Success Rate:       {summary['success_rate']:.1f}%")
        report.append(f"  Bugs Found:         {summary['bugs_found']}")
        report.append(f"  Timestamp:          {summary['timestamp']}")
        
        report.append(f"\n🐛 BUG SEVERITY BREAKDOWN")
        report.append(f"  Critical:           {summary['critical_bugs']}")
        report.append(f"  High:               {summary['high_severity']}")
        report.append(f"  Medium:             {summary['medium_severity']}")
        
        if self.bugs_found:
            report.append(f"\n🔴 BUGS FOUND ({len(self.bugs_found)} total)")
            report.append("-" * 100)
            for i, bug in enumerate(self.bugs_found, 1):
                report.append(f"\n  BUG #{i}: {bug.get('type', 'Unknown')}")
                report.append(f"    Severity: {bug.get('severity', 'UNKNOWN')}")
                if 'query' in bug:
                    report.append(f"    Query: {bug['query'][:80]}")
                if 'issue' in bug:
                    report.append(f"    Issue: {bug['issue']}")
                if 'error' in bug:
                    report.append(f"    Error: {bug['error'][:100]}")
        
        report.append(f"\n📋 DETAILED RESULTS BY CATEGORY")
        report.append("-" * 100)
        
        for category in ['ambiguous_queries', 'malformed_inputs', 'edge_cases', 
                         'boundary_conditions', 'error_recovery']:
            if category in results:
                test_group = results[category]
                report.append(f"\n{test_group['test_name'].upper()} ({test_group['passed']}/{test_group['total']} passed)")
        
        return "\n".join(report)


def main():
    """Run adversarial test suite"""
    suite = AdversarialTestSuite()
    results = suite.run_complete_suite()
    
    # Print report
    report = suite.generate_report(results)
    print("\n" + report)
    
    # Save detailed results
    with open('output/week12_adversarial_test_results.json', 'w') as f:
        json.dump(results, f, indent=2)
    
    # Save bug report
    with open('output/week12_bug_report.json', 'w') as f:
        json.dump(suite.bugs_found, f, indent=2)
    
    # Save text report
    with open('output/week12_adversarial_test_report.txt', 'w') as f:
        f.write(report)
    
    print("\n✅ Test results saved to output/")
    print(f"   - week12_adversarial_test_results.json")
    print(f"   - week12_bug_report.json")
    print(f"   - week12_adversarial_test_report.txt")
    
    return results


if __name__ == '__main__':
    main()
