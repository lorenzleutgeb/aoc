package main

import (
	"fmt"
	"os"
)

const N = 11
const K = 325489

var square = [3]int{-1, 0, 1}
var spiral = make([]int, N*N)

func off(n int) int {
	return (N / 2) + n
}

func get(i, j int) int {
	return spiral[off(i)*N+off(j)]
}

func set(i, j, x int) {
	spiral[off(i)*N+off(j)] = x

	if x > K {
		fmt.Println(x)
		os.Exit(0)
	}
}

func sum(i, j int) {
	s := 0
	for _, x := range square {
		for _, y := range square {
			s = s + get(i+x, j+y)
		}
	}

	set(i, j, s)
}

func main() {
	set(0, 0, 1)

	x, y := 1, 0
	for {
		// fmt.Println("up")
		for get(x-1, y) != 0 {
			sum(x, y)
			y++
		}

		// fmt.Println("left")
		for get(x, y-1) != 0 {
			sum(x, y)
			x--
		}

		// fmt.Println("down")
		for get(x+1, y) != 0 {
			sum(x, y)
			y--
		}

		// fmt.Println("right")
		for get(x, y+1) != 0 {
			sum(x, y)
			x++
		}
	}
}
