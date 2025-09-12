import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

try:
    from del import main as del_main
except ImportError:
    del_main = None
    print("Warning: del script not available")

try:
    from open import main as open_main
except ImportError:
    open_main = None
    print("Warning: open script not available")

try:
    from size import main as size_main
except ImportError:
    size_main = None
    print("Warning: size script not available")

try:
    from tree import main as tree_main
except ImportError:
    tree_main = None
    print("Warning: tree script not available")


def get_del_main(): return del_main
def get_open_main(): return open_main
def get_size_main():return size_main
def get_tree_main():return tree_main

def get_available_functions():
    available = {}
    if del_main:
        available['del'] = del_main
    if open_main:
        available['open'] = open_main
    if size_main:
        available['size'] = size_main
    if tree_main:
        available['tree'] = tree_main
    return available
    