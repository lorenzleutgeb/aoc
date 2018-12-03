import sys

for ln in sys.stdin:
    ln = ln[1:-1].replace(' @ ', ',').replace(': ', ',').replace('x', ',')
    print('claim(%s).'.format(ln))
