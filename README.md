# Advent of Code

Advent of Code is a recreational programming puzzle. It is held yearly from the
first to the twentyfifth of December, with a new puzzle consisting of two parts
released every day.

## My Solutions

This repository contains my solutions. The problem statements can be found on
the Advent of Code website.

### 2020

Haskell, again.

### 2019

I used Haskell.

    cd $YEAR/$DAY/$LEVEL
    stack solve.hs < ../input.txt

### 2018

Mostly Python, again with some Answer Set Programming like in 2017.

### 2017

I used a mix of Python (look for `solve.py`), Answer Set Programming ([DLV][dlv])
fed by Python scripts (look for `solve.lp` and `translate.py`) as well as plain
math and Go (both for Day 3).

#### How to run solutions implemented in Answer Set Programming

##### Solving

For example, to obtain the solution for part one of day four:

    python3 4/1/translate.py < 4/input.txt | dlv -cautious -silent ../query.lp 4/solve.lp --

##### Testing

Occasionally you will find tests, which are to be executed as follows:

    dlv -silent 1/1/test-1.lp 1/1/solve.lp

I write tests in such a way that they are inconsistent together with the program, so no answer is good in this case.
Contrary if there are answers, then these are the cases that need to be investigated.

[dlv]: http://www.dlvsystem.com/dlv/

## Others Solutions

My Leaderboard:
 - https://github.com/mkmc/AdventOfCode
 - https://github.com/PeterZainzinger/aoc_2020
 - https://github.com/riginding/advent-of-code-2019

Developers in Vienna Leaderboard:
 - https://github.com/ad0bert/Advent-of-Code-2020
 - https://github.com/cernychristopher/advent2020
 - https://github.com/kixi/aoc2020
 - https://github.com/Patrik64/adventofcode
