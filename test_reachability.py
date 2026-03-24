#!/usr/bin/env python3
"""
Test script for Control Flow Reachability Analysis
"""

import json
import sys
from modules.nlp_parser import NLPEngine
from query_engine import QueryEngine

def main():
    print("=" * 70)
    print("🔍 Control Flow Reachability Analyzer")
    print("=" * 70)
    
    # Initialize engines
    try:
        nlp_engine = NLPEngine()
        query_engine = QueryEngine(
            ast_file='generated_files/ast_export.json',
            ir_file='generated_files/ir_export.json',
            cfg_file='generated_files/cfg_export.json'
        )
    except FileNotFoundError as e:
        print(f"❌ Error: {e}")
        print("   Make sure to run 'python create_all_files.py' first to generate analysis files.")
        sys.exit(1)
    
    # Test queries
    test_queries = [
        "Is the error_handler block reachable from main?",
        "Can we reach error_handler from process_value?",
        "Is error_handler reachable in main?",
    ]
    
    print("\n📝 Test Queries:")
    print("-" * 70)
    
    for query in test_queries:
        print(f"\n❓ Query: {query}")
        
        # Parse intent using NLP
        intent = nlp_engine.parse_query(query)
        print(f"   Intent: {intent}")
        
        # Execute query
        result = query_engine.execute(intent)
        print(f"   {result}")
    
    print("\n" + "=" * 70)
    print("💬 Interactive Mode (Type 'exit' to quit)")
    print("=" * 70)
    
    while True:
        query = input("\n❓ Ask about code reachability: ").strip()
        if query.lower() in ['exit', 'quit']:
            print("👋 Goodbye!")
            break
        
        if not query:
            continue
        
        intent = nlp_engine.parse_query(query)
        
        if intent.get('target'):
            result = query_engine.execute(intent)
            print(f"✅ {result}")
        else:
            print("❌ Sorry, I couldn't understand your query.")

if __name__ == "__main__":
    main()
