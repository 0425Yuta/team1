package suji

import(
	"strings"
)

func Suji(p string) (string){
	var text string

	switch  {
		case strings.HasPrefix(p, "0") :{
		  text = "0"
		}
		case strings.HasPrefix(p, "1") :{
		  text = "1"
		}
		case strings.HasPrefix(p, "2") :{
		  text = "2"
		}
		case strings.HasPrefix(p, "3") :{
		  text = "3"
		}
		case strings.HasPrefix(p, "4") :{
		  text = "4"
		}
		case strings.HasPrefix(p, "5") :{
		  text = "5"
		}
		case strings.HasPrefix(p, "6") :{
		  text = "6"
		}
		case strings.HasPrefix(p, "7") :{
		  text = "7"
		}
		case strings.HasPrefix(p, "8") :{
		  text = "8"
		}
		case strings.HasPrefix(p, "9") :{
		  text = "9"
		}
		
		default:
		  text = "err"
	}
	return text
}