package main

import (
	"bufio"
	f "fmt"
	"os"
	"strconv"
	"strings"
)

var p string

func kakko(p string) string {
	for i := 0; i > -1; i++ {
		var Ai string
		//A := make([]string, 0, 10)
		if strings.Contains(p, "(") {
			sta := strings.Index(p, "(")
			end := strings.Index(p, ")")
			//	A = append(A, p[sta:end])
			Ai = "A" + strconv.Itoa(i)
			strings.Replace(p, p[sta:end+1], Ai, 1)
			f.Println("if")
		} else {
			f.Println("else")
			i = -2
		}
	}
	return p
}

func kakeru(p string) string {
	for {
		var Bi string
		//var B []string
		if strings.Contains(p, "*") {
			i := 0
			ast := strings.Index(p, "*")
			//	B[i] = p[ast-1 : ast+2]
			Bi = "B" + strconv.Itoa(i)
			strings.Replace(p, p[ast-1:ast+2], Bi, 1)
			i++
		} else {
			break
		}
	}
	return p
}
func waru(p string) string {
	for {
		var Ci string
		//var C []string
		if strings.Contains(p, "/") {
			i := 0
			par := strings.Index(p, "/")
			//	C[i] = p[par-1 : par+2]
			Ci = "C" + strconv.Itoa(i)
			strings.Replace(p, p[par-1:par+2], Ci, 1)
			i++
		} else {
			break
		}
	}
	return p
}

func tasu(p string) string {
	for {
		var Di string
		//var D []string
		if strings.Contains(p, "+") {
			i := 0
			pls := strings.Index(p, "+")
			//	D[i] = p[pls-1 : pls+2]
			Di = "D" + strconv.Itoa(i)
			strings.Replace(p, p[pls-1:pls+2], Di, 1)
			i++
		} else {
			break
		}
	}
	return p
}
func hiku(p string) string {
	for {
		var Ei string
		//var E []string
		if strings.Contains(p, "-") {
			i := 0
			mns := strings.Index(p, "-")
			//	E[i] = p[mns-1 : mns+2]
			Ei = "E" + strconv.Itoa(i)
			strings.Replace(p, p[mns-1:mns+2], Ei, 1)
			i++
		} else {
			break
		}
	}
	return p
}

func enzan(p string) string {
	p = kakko(p)
	f.Println(p)
	p = kakeru(p)
	f.Println(p)
	p = waru(p)
	f.Println(p)
	p = tasu(p)
	f.Println(p)
	p = hiku(p)
	f.Println(p)
	return p
}
func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	p := scanner.Text()
	p = enzan(p)
	f.Println(p)
}
