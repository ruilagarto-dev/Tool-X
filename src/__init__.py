import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from src.del import main as del_main

# Use del_main() em vez de del.main()s
