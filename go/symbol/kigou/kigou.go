package kigou

import(
	"strings"
)

func Kigou(p string) (string){
	var text string

	switch  {
		case strings.HasPrefix(p, "+") :{
		  text = " add "
		}
		case strings.HasPrefix(p, "-") :{
		  text = " sub "
		}
		case strings.HasPrefix(p, "*") :{
		  text = " mul "
		}
		case strings.HasPrefix(p, "/") :{
		  text = " div "
		}
		case strings.HasPrefix(p, "%") :{
		  text = " % "
		}
		case strings.HasPrefix(p, "^") :{
		  text = " ^ "
		}
		case strings.HasPrefix(p, "!") :{
		  text = " ! "
		}
		case strings.HasPrefix(p, "||") :{
		  text = " || "
		}
		case strings.HasPrefix(p, "|") :{
		  text = " | "
		}
		case strings.HasPrefix(p, "&&") :{
		  text = " && "
		}
		case strings.HasPrefix(p, "&") :{
		  text = " & "
		}
		case strings.HasPrefix(p, "==") :{
		  text = " == "
		}
		case strings.HasPrefix(p, "(") :{
		  text = " ( "
		}
		case strings.HasPrefix(p, ")") :{
		  text = " ) "
		}
		default:
		  text = p[:1]
	}
	return text
}


/*func main(){
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	p := scanner.Text()
	Ope(p)
}*/