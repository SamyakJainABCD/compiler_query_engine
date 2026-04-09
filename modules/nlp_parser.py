import spacy
import re

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
    
    def _validate_identifier(self, identifier):
        """
        Validate that an identifier contains only safe characters.
        C function/variable names: alphanumeric, underscores
        Max length: 255 chars (C standard)
        Returns: (is_valid, error_message)
        """
        if not identifier:
            return False, "❌ Identifier cannot be empty"
        
        if len(identifier) > 255:
            return False, f"❌ Identifier too long ({len(identifier)} > 255 characters)"
        
        # Valid C identifier pattern: starts with letter/underscore, contains alphanumeric/underscores
        if not re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*$', identifier):
            return False, f"❌ Invalid identifier '{identifier}'. Use only letters, numbers, and underscores."
        
        return True, ""
    
    def _extract_quoted_string(self, text):
        """Extract the first quoted string from text. Returns None if not found."""
        match = re.search(r'''['"](.*?)['"]''', text)
        return match.group(1) if match else None

    def parse_query(self, text):
            doc = self.nlp(text.lower())
            text_lower = text.lower()
            
            # Find all quoted string positions to exclude them from attribute extraction
            quoted_positions = []
            for match in re.finditer(r'''['"]([^'"]*?)['"]''', text):
                quoted_positions.append((match.start(), match.end()))
            
            def is_in_quotes(token_start, token_end):
                """Check if token position is within any quoted string"""
                for quote_start, quote_end in quoted_positions:
                    if token_start >= quote_start and token_end <= quote_end:
                        return True
                return False
            
            intent = {
                "action": "find", 
                "target": None,
                "name": None,
                "scope": None,
                "layer": None,
                "attributes": [],
                "query_type": "standard"  # Can be "standard", "reachability", "security"
            }

            # Check for security/vulnerability analysis queries
            security_keywords = ['buffer', 'overflow', 'vulnerability', 'security', 'risk', 'bounds', 'check', 'unsafe', 'dangerous']
            
            # Bounds check queries
            if 'bounds' in text_lower and ('check' in text_lower or 'checking' in text_lower):
                intent["query_type"] = "security"
                intent["target"] = "bounds_check"
                intent["layer"] = "SECURITY"
                
                # Extract loop name if specified
                quoted_name = self._extract_quoted_string(text)
                if quoted_name and 'loop' in text_lower:
                    is_valid, error = self._validate_identifier(quoted_name)
                    if is_valid:
                        intent["scope"] = quoted_name
                    else:
                        intent["error"] = error
                
                return intent
            
            # Unsafe function calls queries
            elif 'unsafe' in text_lower and ('function' in text_lower or 'call' in text_lower):
                intent["query_type"] = "security"
                intent["target"] = "unsafe_calls"
                intent["layer"] = "SECURITY"
                
                if 'critical' in text_lower:
                    intent["scope"] = 'critical'
                elif 'high' in text_lower:
                    intent["scope"] = 'high'
                else:
                    intent["scope"] = 'all'
                
                return intent
            
            # Comprehensive security/vulnerability queries
            elif any(keyword in text_lower for keyword in security_keywords):
                if 'buffer' in text_lower and ('overflow' in text_lower or 'risk' in text_lower):
                    intent["query_type"] = "security"
                    intent["target"] = "buffer_overflow"
                    intent["layer"] = "SECURITY"
                    
                    # Check if user specified a risk level scope
                    if 'critical' in text_lower:
                        intent["scope"] = 'critical'
                    elif 'high' in text_lower:
                        intent["scope"] = 'high'
                    else:
                        intent["scope"] = 'all'
                    
                    return intent
                
                # Generic security query
                elif 'security' in text_lower or 'vulnerability' in text_lower:
                    intent["query_type"] = "security"
                    intent["target"] = "security_vulnerabilities"
                    intent["layer"] = "SECURITY"
                    
                    if 'critical' in text_lower:
                        intent["scope"] = 'critical'
                    elif 'high' in text_lower:
                        intent["scope"] = 'high'
                    else:
                        intent["scope"] = 'all'
                    
                    return intent
            # Check for reachability questions (e.g., "is X reachable from Y")
            if "reachable" in text_lower:
                intent["query_type"] = "reachability"
                
                # Pattern: "is 'target' reachable from 'source'" or with "from"
                # Extract quoted strings for target and source
                quoted_strings = re.findall(r'''['"](.*?)['"]''', text)
                
                if len(quoted_strings) >= 2:
                    # Validate both identifiers before assigning
                    is_valid_name, error_name = self._validate_identifier(quoted_strings[0])
                    is_valid_scope, error_scope = self._validate_identifier(quoted_strings[1])
                    
                    if not is_valid_name:
                        return {"error": error_name}
                    if not is_valid_scope:
                        return {"error": error_scope}
                    
                    intent["name"] = quoted_strings[0]  # target block
                    intent["scope"] = quoted_strings[1]  # source function
                else:
                    # Try regex pattern with quoted identifiers
                    match = re.search(r'is\s+[\'"]([^\'"]+)["\']\s+reachable\s+from\s+[\'"]([^\'"]+)[\'"]', text)
                    if match:
                        # Validate extracted identifiers
                        is_valid_name, error_name = self._validate_identifier(match.group(1))
                        is_valid_scope, error_scope = self._validate_identifier(match.group(2))
                        
                        if not is_valid_name:
                            return {"error": error_name}
                        if not is_valid_scope:
                            return {"error": error_scope}
                        
                        intent["name"] = match.group(1)
                        intent["scope"] = match.group(2)
                    else:
                        return {"error": "❌ Reachability queries require quoted identifiers: is \"target\" reachable from \"source\""}
                
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

                # 3. Attribute Extraction (but skip if it's the target keyword or in quotes)
                if token.pos_ == "ADJ" and lemma not in self.targets:
                    # Check if this token is inside a quoted string
                    token_start = token.idx
                    token_end = token.idx + len(token.text)
                    if not is_in_quotes(token_start, token_end):
                        intent["attributes"].append(lemma)

            # Extract name from quoted string after target keyword
            if intent["target"] and intent["name"] is None:
                quoted_name = self._extract_quoted_string(text)
                if quoted_name:
                    is_valid, error = self._validate_identifier(quoted_name)
                    if not is_valid:
                        intent["error"] = error
                    else:
                        intent["name"] = quoted_name
                else:
                    # Check if target requires a name
                    if target_found_at is not None:
                        # Look for quoted string after the target keyword
                        remaining_text = text[len("".join([token.text for token in doc[:target_found_at+1]])):]
                        quoted_name = self._extract_quoted_string(remaining_text)
                        if quoted_name:
                            is_valid, error = self._validate_identifier(quoted_name)
                            if not is_valid:
                                intent["error"] = error
                            else:
                                intent["name"] = quoted_name

            # 4. Scope Extraction (from "in" or "from" with quoted identifier)
            if intent["scope"] is None and "error" not in intent:
                # Find all quoted strings and their positions in the text
                quoted_strings = list(re.finditer(r'''['"]([^'"]*?)['"]''', text))
                
                # Look for "in" or "from" keywords and get the quoted string after them
                for keyword in ["in", "from"]:
                    keyword_pattern = f'\\b{keyword}\\b'
                    keyword_match = re.search(keyword_pattern, text, re.IGNORECASE)
                    if keyword_match:
                        keyword_end_pos = keyword_match.end()
                        # Find quoted strings that come after this keyword
                        for quoted_match in quoted_strings:
                            if quoted_match.start() > keyword_end_pos:
                                # This quoted string comes after the keyword
                                scope_value = quoted_match.group(1)
                                is_valid, error = self._validate_identifier(scope_value)
                                if not is_valid:
                                    intent["error"] = error
                                    return intent
                                intent["scope"] = scope_value
                                break
                    if intent["scope"] is not None:
                        break

            return intent

# --- Quick Test ---
if __name__ == "__main__":
    parser = NLPEngine()
    test_query = "Show me the instructions in the \"main\" function"
    print(f"Query: {test_query}")
    print(f"Extracted Intent: {parser.parse_query(test_query)}")
    
    test_query2 = "Is \"error_handler\" reachable from \"main\"?"
    print(f"\nQuery: {test_query2}")
    print(f"Extracted Intent: {parser.parse_query(test_query2)}")