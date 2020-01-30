package su2

/*import(
	f"fmt"
	"os"
	"bufio"
	//"strings"
)*/

func Su2(p string) (int){
	p = p + " "
	count := 0
	tp := p[:1]
	a:= len(p)

	for i:=1;i>0&&i<a;i++ {
	switch tp {
		case "0","1","2","3","4","5","6","7","8","9" :{
		 count++
		  tp = p[i:i+1]
		}
		default:
		  i=-1
	} 
	}
	return count
}

/*func main(){
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	p := scanner.Text()
	c := Su2(p)
	f.Println(c)
}*/