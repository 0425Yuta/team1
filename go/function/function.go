package function

import(
	f"fmt"
	"os"
	"bufio"
)

func Fank(){
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan(){
		text := scanner.Text()
		
		if text == "}" {break}
	}
	f.Println("kaka")
}