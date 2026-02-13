import unittest
import subprocess
import os

class TestBaseline(unittest.TestCase):
    TEST_FILE = "test_data.txt"
    # Assuming running from project root
    BINARY_PATH = "benchmarks/baseline"

    def tearDown(self):
        if os.path.exists(self.TEST_FILE):
            os.remove(self.TEST_FILE)

    def create_test_file(self, content):
        with open(self.TEST_FILE, "w") as f:
            f.write(content)

    def test_simple_count(self):
        self.create_test_file("Alpha beta Alpha\nNo match here.\nAlphaAlpha")
        # Expected: 4 Alphas
        
        try:
            result = subprocess.run([self.BINARY_PATH, self.TEST_FILE], 
                                  capture_output=True, text=True)
            if result.returncode != 0:
                self.fail(f"Binary failed with return code {result.returncode}")
            
            # Allow for some formatting flexibility, e.g., "Count: 4"
            self.assertIn("4", result.stdout)
            self.assertIn("Count:", result.stdout) 
            
        except FileNotFoundError:
            self.fail(f"Binary '{self.BINARY_PATH}' not found.")

if __name__ == '__main__':
    unittest.main()
