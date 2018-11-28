import sys

for i, row in enumerate(sys.stdin):
    print('row({}).'.format(i))
    for j, cell in enumerate(row.split('\t')):
        print('cell({},{},{}'.format(i, j, cell.strip()))
