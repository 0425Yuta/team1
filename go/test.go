package main
import(
	"strings"
	"fmt"
)
func main(){
  var s string
   s = "Alfa Bravo Charlie Delta Echo Foxtrot Golf"
  fmt.Println(strings.Index(s, "a"))
}