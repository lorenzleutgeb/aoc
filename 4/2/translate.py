import sys

for i, row in enumerate(sys.stdin):
    print('row({}).'.format(i))
    for j, word in enumerate(row.split(' ')):
        print('word({},{},"{}").'.format(i, j, ''.join(sorted(word.strip()))))
