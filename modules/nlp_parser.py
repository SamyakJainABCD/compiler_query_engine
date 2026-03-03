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
        self.targets = ["function", "variable", "loop", "instruction", "cfg", "logic"]
        self.layers = {
            "function": "AST",
            "variable": "AST",
            "loop": "CFG",
            "instruction": "IR",
            "cfg": "CFG",
            "logic": "IR"
        }

    def parse_query(self, text):
            doc = self.nlp(text.lower())
            
            intent = {
                "action": "find", 
                "target": None,
                "scope": None,
                "layer": None,
                "attributes": []
            }

            for token in doc:
                # Use .lemma_ to catch "functions" -> "function"
                lemma = token.lemma_

                # 1. Action Extraction
                if lemma in self.actions:
                    intent["action"] = lemma
                
                # 2. Target Extraction
                if lemma in self.targets:
                    intent["target"] = lemma
                    intent["layer"] = self.layers.get(lemma)

                # 3. Attribute Extraction
                if token.pos_ == "ADJ":
                    intent["attributes"].append(lemma)

            # 4. Scope Extraction (Improved)
            # Look for the 'name' of a function or variable
            for token in doc:
                if token.pos_ in ["PROPN", "NOUN"] and token.lemma_ not in self.targets and token.lemma_ not in self.actions:
                    intent["scope"] = token.text

            return intent

# --- Quick Test ---
if __name__ == "__main__":
    parser = NLPEngine()
    test_query = "Show me the instructions in the main function"
    print(f"Query: {test_query}")
    print(f"Extracted Intent: {parser.parse_query(test_query)}")