#!/usr/bin/env python3
import sys

for i, ln in enumerate(sys.stdin):
    print("dot(",i,",",ln.strip(),").")
