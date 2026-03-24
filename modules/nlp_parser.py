import spacy

class NLPEngine:
    def __init__(self):
        # Load the small English model
        try:
            self.nlp = spacy.load("en_core_web_sm")
        except:
            print("Installing spaCy model...")
            import os
            os.system("python3 -m spacy download en_core_web_sm")
            self.nlp = spacy.load("en_core_web_sm")

        # Define our taxonomy Keywords
        self.actions = ["show", "find", "list", "check", "count", "analyze"]
        self.targets = ["function", "variable", "loop", "instruction", "cfg", "logic", "block"]
        self.layers = {
            "function": "AST",
            "variable": "AST",
            "loop": "CFG",
            "instruction": "IR",
            "cfg": "CFG",
            "logic": "IR",
            "block": "CFG"
        }

    def parse_query(self, text):
            doc = self.nlp(text.lower())
            text_lower = text.lower()
            
            intent = {
                "action": "find", 
                "target": None,
                "name": None,
                "scope": None,
                "layer": None,
                "attributes": [],
                "query_type": "standard"  # Can be "standard", "reachability"
            }

            # Check for reachability questions (e.g., "is X reachable from Y")
            if "reachable" in text_lower:
                intent["query_type"] = "reachability"
                # Extract target and source using regex
                import re
                
                # Pattern: "is ... reachable from ..."
                match = re.search(r'is\s+(.*?)\s+reachable\s+from\s+(\w+)', text_lower)
                if match:
                    target_part = match.group(1).strip()
                    source_part = match.group(2).strip()
                    
                    # Remove "the" and "block"/"function" keywords to get just the name
                    target_part = target_part.replace(" block", "").replace(" function", "").replace("the ", "").strip()
                    
                    intent["name"] = target_part
                    intent["scope"] = source_part
                else:
                    # Try alternative pattern: "is ... reachable in ..."
                    match = re.search(r'is\s+(.*?)\s+reachable\s+in\s+(\w+)', text_lower)
                    if match:
                        target_part = match.group(1).strip()
                        source_part = match.group(2).strip()
                        target_part = target_part.replace(" block", "").replace(" function", "").replace("the ", "").strip()
                        intent["name"] = target_part
                        intent["scope"] = source_part
                
                intent["target"] = "block"
                intent["layer"] = "CFG"
                return intent

            target_found_at = None
            
            for i, token in enumerate(doc):
                # Use .lemma_ to catch "functions" -> "function"
                lemma = token.lemma_

                # 1. Action Extraction
                if lemma in self.actions:
                    intent["action"] = lemma
                
                # 2. Target Extraction (only set if not already set - first match wins)
                if intent["target"] is None and lemma in self.targets:
                    intent["target"] = lemma
                    intent["layer"] = self.layers.get(lemma)
                    target_found_at = i

                # 3. Attribute Extraction (but skip if it's the target keyword)
                if token.pos_ == "ADJ" and lemma not in self.targets:
                    intent["attributes"].append(lemma)

            # Extract specific name after target (e.g., "variable x" -> name="x")
            if target_found_at is not None and intent["name"] is None:
                j = target_found_at + 1
                while j < len(doc):
                    check_token = doc[j]
                    # Stop if we hit "in" or "from"
                    if check_token.text in ["in", "from"]:
                        break
                    # Skip articles
                    if check_token.text in ["the", "a", "an"]:
                        j += 1
                        continue
                    # This should be the specific name
                    if check_token.lemma_ not in self.actions and check_token.lemma_ not in self.targets:
                        intent["name"] = check_token.text
                        break
                    j += 1

            # 4. Scope Extraction (Improved)
            # Look for patterns like "in function [name]" or "in [name]"
            for i, token in enumerate(doc):
                if token.text in ["in", "from"]:
                    # Start from next token
                    j = i + 1
                    while j < len(doc):
                        check_token = doc[j]
                        # Skip known target keywords (function, variable, loop, etc.)
                        if check_token.lemma_ in self.targets:
                            j += 1
                            continue
                        # Skip common articles
                        if check_token.text in ["the", "a", "an"]:
                            j += 1
                            continue
                        # Found the scope
                        if check_token.lemma_ not in self.actions:
                            intent["scope"] = check_token.text
                            break
                        j += 1
                    if intent["scope"] is not None:
                        break
            
            # If no scope found with "in" pattern, look for any PROPN/NOUN not in targets/actions
            # BUT skip this if we already extracted a specific name (to avoid name being treated as scope)
            if intent["scope"] is None and intent["name"] is None:
                for token in doc:
                    if token.pos_ in ["PROPN", "NOUN"] and token.lemma_ not in self.targets and token.lemma_ not in self.actions:
                        intent["scope"] = token.text
                        break

            return intent

# --- Quick Test ---
if __name__ == "__main__":
    parser = NLPEngine()
    test_query = "Show me the instructions in the main function"
    print(f"Query: {test_query}")
    print(f"Extracted Intent: {parser.parse_query(test_query)}")
    
    test_query2 = "Is the error_handler block reachable from main?"
    print(f"\nQuery: {test_query2}")
    print(f"Extracted Intent: {parser.parse_query(test_query2)}")