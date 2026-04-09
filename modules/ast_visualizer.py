"""
Simple AST Visualization - Print AST to terminal with highlights
"""

import json
import re
from typing import Dict, Any, Optional


def find_node_path(node: Dict, highlight_name: str, path=None) -> Optional[list]:
    """Find path to node with matching name"""
    if path is None:
        path = []
    
    node_name = node.get('name', '')
    if node_name == highlight_name:
        return path + [node]
    
    if 'children' in node:
        for child in node['children']:
            result = find_node_path(child, highlight_name, path + [node])
            if result:
                return result
    
    return None


def visualize_ast(ast_data: Dict, highlight_name: Optional[str] = None) -> str:
    """Print AST showing only direct parent, the node, and direct children"""
    output = []
    output.append("┌─ AST Tree ─────────────────────────────┐")
    
    if highlight_name:
        # Find the node in the tree
        path = find_node_path(ast_data, highlight_name)
        
        if path and len(path) > 0:
            highlighted_node = path[-1]
            parent_node = path[-2] if len(path) > 1 else None
            
            # Show parent if exists
            if parent_node:
                parent_type = parent_node.get('kind', parent_node.get('type', '?'))
                parent_name = parent_node.get('name', '')
                if parent_name:
                    parent_type += f" [{parent_name}]"
                output.append(f"  {parent_type}")
            
            # Show the highlighted node
            node_type = highlighted_node.get('kind', highlighted_node.get('type', '?'))
            node_name = highlighted_node.get('name', '')
            node_label = f"{node_type}"
            if node_name:
                node_label += f" [{node_name}]"
            output.append(f"  >>> {node_label}")
            
            # Show direct children
            if 'children' in highlighted_node:
                children = highlighted_node['children']
                for i, child in enumerate(children):
                    child_type = child.get('kind', child.get('type', '?'))
                    child_name = child.get('name', '')
                    if child_name:
                        child_type += f" [{child_name}]"
                    
                    is_last = i == len(children) - 1
                    marker = "└─ " if is_last else "├─ "
                    output.append(f"      {marker}{child_type}")
        else:
            output.append("  (Node not found in AST)")
    else:
        output.append("  (No search term provided)")
    
    output.append("└──────────────────────────────────────┘")
    return "\n".join(output)


def print_ast_visual(query_result: Dict) -> None:
    """Print query result with AST visualization"""
    print("\n" + "="*50)
    query = query_result.get('query', 'N/A')
    print(f"Query: {query}")
    print("="*50)
    
    if 'results' in query_result:
        print("\nResults:")
        results = query_result['results']
        if isinstance(results, list):
            for item in results:
                if isinstance(item, dict):
                    print(f"  • {item.get('name', '?')} ({item.get('type', '?')})")
                else:
                    print(f"  • {item}")
        else:
            print(f"  • {results}")
    
    if 'ast' in query_result:
        # Extract highlight name from query if available
        highlight = None
        if 'find function' in query or 'find variable' in query:
            match = re.search(r'"([^"]+)"', query)
            if match:
                highlight = match.group(1)
        
        print("\n" + visualize_ast(query_result['ast'], highlight_name=highlight))
    
    print("="*50 + "\n")
