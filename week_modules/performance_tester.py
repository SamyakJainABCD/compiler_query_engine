import time
import json
from typing import Dict, List, Tuple, Any
from dataclasses import dataclass
import statistics
from modules.nlp_parser import NLPEngine
from query_engine import QueryEngine

@dataclass
class TestResult:
    """Data class for storing test results"""
    test_name: str
    passed: bool
    execution_time: float
    accuracy: float = None
    details: str = ""

class NLAccuracyTester:
    """
    Measures Natural Language understanding accuracy.
    Tests intent parsing, entity extraction, and semantic understanding.
    """
    
    def __init__(self):
        self.nlp = NLPEngine()
        self.results: List[TestResult] = []
        
        # Test dataset: (query, expected_intent_type, expected_target)
        self.test_cases = [
            # Standard queries
            ("find function \"main\"", "standard", "function"),
            ("show function \"process_input\"", "standard", "function"),
            ("list functions", "standard", "function"),
            ("find variable \"x\" in \"main\"", "standard", "variable"),
            ("find unused variable", "standard", "variable"),
            ("show all unused variables", "standard", "variable"),
            
            # Reachability queries
            ("is \"error_handler\" reachable from \"main\"?", "reachability", "block"),
            ("check if \"cleanup\" reachable from \"initialize\"?", "reachability", "block"),
            ("is \"fatal\" reachable from \"start\"?", "reachability", "block"),
            
            # Security queries
            ("list all bounds checks", "security", "bounds_check"),
            ("show bounds checks in loop \"main_loop\"", "security", "bounds_check"),
            ("list all unsafe function calls", "security", "unsafe_calls"),
            ("show critical unsafe function calls", "security", "unsafe_calls"),
            ("analyze buffer overflow vulnerabilities", "security", "buffer_overflow"),
            ("show security vulnerabilities", "security", "security_vulnerabilities"),
            ("list missing bounds checks", "security", "bounds_check"),
            ("count unsafe function calls", "security", "unsafe_calls"),
        ]
    
    def run_accuracy_tests(self) -> Dict[str, Any]:
        """Run all accuracy tests and return results"""
        print("\n🧪 Running NL Understanding Accuracy Tests...")
        print("=" * 70)
        
        correct_count = 0
        total_count = len(self.test_cases)
        
        results_data = {
            'total_tests': total_count,
            'passed': 0,
            'failed': 0,
            'accuracy': 0.0,
            'details': []
        }
        
        for query, expected_type, expected_target in self.test_cases:
            start_time = time.time()
            
            try:
                intent = self.nlp.parse_query(query)
                execution_time = time.time() - start_time
                
                # Check if parsing was successful
                if "error" in intent:
                    test_result = TestResult(
                        test_name=query[:50],
                        passed=False,
                        execution_time=execution_time,
                        accuracy=0.0,
                        details=f"Parse error: {intent['error']}"
                    )
                    results_data['failed'] += 1
                else:
                    # Check intent type and target
                    type_match = intent.get('query_type') == expected_type
                    target_match = intent.get('target') == expected_target
                    
                    passed = type_match and target_match
                    
                    if passed:
                        correct_count += 1
                        results_data['passed'] += 1
                        accuracy = 100.0
                    else:
                        results_data['failed'] += 1
                        accuracy = 0.0
                    
                    test_result = TestResult(
                        test_name=query[:50],
                        passed=passed,
                        execution_time=execution_time,
                        accuracy=accuracy,
                        details=f"Expected: {expected_type}/{expected_target}, Got: {intent.get('query_type')}/{intent.get('target')}"
                    )
                
                self.results.append(test_result)
                
                # Print result
                status = "✓" if test_result.passed else "✗"
                print(f"{status} {query[:60]}")
                if test_result.execution_time:
                    print(f"  Time: {test_result.execution_time*1000:.2f}ms")
                
            except Exception as e:
                execution_time = time.time() - start_time
                test_result = TestResult(
                    test_name=query[:50],
                    passed=False,
                    execution_time=execution_time,
                    accuracy=0.0,
                    details=f"Exception: {str(e)}"
                )
                self.results.append(test_result)
                results_data['failed'] += 1
                print(f"✗ {query[:60]} - Exception: {str(e)}")
        
        results_data['accuracy'] = (correct_count / total_count * 100) if total_count > 0 else 0.0
        
        print("\n" + "=" * 70)
        print(f"Total Accuracy: {results_data['accuracy']:.1f}% ({correct_count}/{total_count})")
        
        return results_data
    
    def get_detailed_results(self) -> List[Dict[str, Any]]:
        """Return detailed test results"""
        return [
            {
                'test_name': r.test_name,
                'passed': r.passed,
                'execution_time': r.execution_time,
                'accuracy': r.accuracy,
                'details': r.details
            }
            for r in self.results
        ]


class LatencyTester:
    """
    Tests query response latency on various IR sizes.
    Measures performance scaling with code complexity.
    """
    
    def __init__(self):
        self.nlp = NLPEngine()
        self.engine = QueryEngine()
        self.results: Dict[str, List[float]] = {}
    
    def test_parsing_latency(self, num_iterations: int = 100) -> Dict[str, Any]:
        """Test NLP parsing latency"""
        print("\n⏱️  Testing Query Parsing Latency...")
        print("=" * 70)
        
        test_queries = [
            "find function \"main\"",
            "list all bounds checks",
            "show critical unsafe function calls",
            "is \"error\" reachable from \"main\"?",
        ]
        
        results = {
            'parsing_latencies': {},
            'averages': {},
            'percentiles': {}
        }
        
        for query in test_queries:
            times = []
            
            for _ in range(num_iterations):
                start = time.time()
                self.nlp.parse_query(query)
                elapsed = (time.time() - start) * 1000  # Convert to ms
                times.append(elapsed)
            
            avg_time = statistics.mean(times)
            min_time = min(times)
            max_time = max(times)
            p95_time = self._percentile(times, 95)
            p99_time = self._percentile(times, 99)
            
            results['parsing_latencies'][query[:40]] = {
                'min': min_time,
                'avg': avg_time,
                'max': max_time,
                'p95': p95_time,
                'p99': p99_time
            }
            
            print(f"\nQuery: {query[:40]}")
            print(f"  Min: {min_time:.3f}ms | Avg: {avg_time:.3f}ms | Max: {max_time:.3f}ms")
            print(f"  P95: {p95_time:.3f}ms | P99: {p99_time:.3f}ms")
        
        return results
    
    def test_query_execution_latency(self, num_iterations: int = 100) -> Dict[str, Any]:
        """Test full query execution latency"""
        print("\n⏱️  Testing Query Execution Latency...")
        print("=" * 70)
        
        test_queries = [
            "find function \"main\"",
            "list all bounds checks",
            "show critical unsafe function calls",
        ]
        
        results = {
            'execution_latencies': {},
            'breakdown': {}
        }
        
        for query in test_queries:
            parse_times = []
            exec_times = []
            total_times = []
            
            for _ in range(num_iterations):
                # Time parsing
                parse_start = time.time()
                intent = self.nlp.parse_query(query)
                parse_elapsed = (time.time() - parse_start) * 1000
                parse_times.append(parse_elapsed)
                
                # Time execution
                exec_start = time.time()
                result = self.engine.execute(intent)
                exec_elapsed = (time.time() - exec_start) * 1000
                exec_times.append(exec_elapsed)
                
                total_times.append(parse_elapsed + exec_elapsed)
            
            results['execution_latencies'][query[:40]] = {
                'parse_avg': statistics.mean(parse_times),
                'exec_avg': statistics.mean(exec_times),
                'total_avg': statistics.mean(total_times),
                'total_p95': self._percentile(total_times, 95),
                'total_p99': self._percentile(total_times, 99)
            }
            
            print(f"\nQuery: {query[:40]}")
            print(f"  Parse: {statistics.mean(parse_times):.3f}ms (avg)")
            print(f"  Exec:  {statistics.mean(exec_times):.3f}ms (avg)")
            print(f"  Total: {statistics.mean(total_times):.3f}ms (avg)")
            print(f"  P95:   {self._percentile(total_times, 95):.3f}ms | P99: {self._percentile(total_times, 99):.3f}ms")
        
        return results
    
    def _percentile(self, data: List[float], percentile: int) -> float:
        """Calculate percentile of data"""
        if not data:
            return 0.0
        sorted_data = sorted(data)
        index = int((percentile / 100.0) * len(sorted_data))
        return sorted_data[min(index, len(sorted_data) - 1)]
    
    def test_scalability(self) -> Dict[str, Any]:
        """Test how performance scales with data size"""
        print("\n📈 Testing Scalability...")
        print("=" * 70)
        
        results = {
            'parsing_scales': {},
            'execution_scales': {}
        }
        
        # Simulate different query complexities
        query_complexities = [
            ("simple", "find function \"main\"", 50),
            ("medium", "list all bounds checks", 50),
            ("complex", "show security vulnerabilities", 50),
        ]
        
        for complexity_name, query, iterations in query_complexities:
            parse_times = []
            
            for _ in range(iterations):
                start = time.time()
                self.nlp.parse_query(query)
                elapsed = (time.time() - start) * 1000
                parse_times.append(elapsed)
            
            avg_time = statistics.mean(parse_times)
            
            results['parsing_scales'][complexity_name] = {
                'query': query[:40],
                'avg_time_ms': avg_time,
                'std_dev': statistics.stdev(parse_times) if len(parse_times) > 1 else 0
            }
            
            print(f"\n{complexity_name.upper()}: {query[:40]}")
            print(f"  Average: {avg_time:.3f}ms")
            print(f"  Std Dev: {statistics.stdev(parse_times) if len(parse_times) > 1 else 0:.3f}ms")
        
        return results


class PerformanceReportGenerator:
    """Generates comprehensive performance evaluation reports"""
    
    def __init__(self):
        self.accuracy_results = None
        self.latency_results = None
        self.execution_results = None
        self.scalability_results = None
    
    def generate_report(self) -> Dict[str, Any]:
        """Generate complete performance report"""
        
        # Run all tests
        print("\n" + "="*70)
        print("RUNNING WEEK 11: ACCURACY & PERFORMANCE TESTING")
        print("="*70)
        
        accuracy_tester = NLAccuracyTester()
        self.accuracy_results = accuracy_tester.run_accuracy_tests()
        
        latency_tester = LatencyTester()
        self.latency_results = latency_tester.test_parsing_latency()
        self.execution_results = latency_tester.test_query_execution_latency()
        self.scalability_results = latency_tester.test_scalability()
        
        # Aggregate results
        report = {
            'timestamp': time.strftime('%Y-%m-%d %H:%M:%S'),
            'accuracy': self.accuracy_results,
            'latency': self.latency_results,
            'execution': self.execution_results,
            'scalability': self.scalability_results,
            'summary': self._generate_summary()
        }
        
        return report
    
    def _generate_summary(self) -> Dict[str, Any]:
        """Generate summary statistics"""
        
        summary = {
            'overall_accuracy': self.accuracy_results['accuracy'],
            'total_tests': self.accuracy_results['total_tests'],
            'passed_tests': self.accuracy_results['passed'],
            'failed_tests': self.accuracy_results['failed'],
            'status': 'PASS' if self.accuracy_results['accuracy'] >= 90 else 'NEEDS_IMPROVEMENT',
            'recommendations': []
        }
        
        if self.accuracy_results['accuracy'] < 90:
            summary['recommendations'].append("Improve NLP intent detection for edge cases")
        
        # Add recommendations based on latency
        avg_latency = statistics.mean([
            result['total_avg'] for result in self.execution_results['execution_latencies'].values()
        ])
        
        if avg_latency > 100:  # More than 100ms
            summary['recommendations'].append("Optimize query execution pipeline")
        
        return summary
    
    def save_json_report(self, filename: str = 'output/performance_report.json'):
        """Save report as JSON"""
        report = self.generate_report()
        
        try:
            with open(filename, 'w') as f:
                json.dump(report, f, indent=2)
            print(f"\n✅ JSON report saved to {filename}")
            return report
        except Exception as e:
            print(f"❌ Error saving JSON report: {e}")
            return None


def run_all_tests() -> Dict[str, Any]:
    """Run all accuracy and performance tests"""
    generator = PerformanceReportGenerator()
    return generator.save_json_report()


if __name__ == "__main__":
    run_all_tests()
