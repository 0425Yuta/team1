package main

import(
	f"fmt"
	"os"
	"bufio"
	"strings"
	//suji"symbol/suji"
	kigou"symbol/kigou"
	moji"symbol/moji"
	su2"symbol/su2"
)
var i int

func siwa(p string) (string){
	var text string
	var k int
	tp := p[:1]
	switch tp {
		case "0","1","2","3","4","5","6","7","8","9" :{
		//  text = suji.Suji(p)
		  k = su2.Su2(p)
		  i = i + k - 1
		  text = "loadl "+ p[:k] +"\n"
		}
		case "+","-","*","/","%","^","!","||","|","&&","==","&","(",")" :{
		 text = kigou.Kigou(p) +"\n"
		}
		case "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z" :{
		 text = moji.Moji(p)
		}
		
		default:
		  text = p[:1]
	}
	return text
}

func Ope(p string){
	var text, t, pi string
	a :=len(p)
	for i=0; i<a; i++{
		pi = p[i:]
		text = siwa(pi)
		t = t + text
	}
	f.Println(t)
}

func main(){
	for{

	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	p := scanner.Text()
	Ope(p)
		if strings.HasPrefix(p, ";"){
		break}
	}
}