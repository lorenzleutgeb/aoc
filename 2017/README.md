# Advent of Code 2017

My solutions for the year 2017. I was trying to solve most of it using Answer Set Programming with DLV.

## Solving

For example, to obtain the solution for part one of day one:

    python3 4/1/translate.py < 4/input.txt | dlv -cautious -silent query.lp 4/solve.lp --

## Testing

Occasionally you will find tests, which are to be executed as follows:

    dlv -silent 1/1/test-1.lp 1/1/solve.lp

I write tests in such a way that they are inconsistent together with the program, so no answer is good in this case.
Contrary if there are answers, then these are the cases that need to be investigated.
