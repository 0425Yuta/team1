package moji

import(
	"strings"
)

func Moji(p string) (string){
	var text string

	switch  {
		case strings.HasPrefix(p, "a") :{
		  text = "a"
		}
		case strings.HasPrefix(p, "b") :{
		  text = "b"
		}
		case strings.HasPrefix(p, "c") :{
		  text = "c"
		}
		case strings.HasPrefix(p, "d") :{
		  text = "d"
		}
		case strings.HasPrefix(p, "e") :{
		  text = "e"
		}
		case strings.HasPrefix(p, "f") :{
		  text = "f"
		}
		case strings.HasPrefix(p, "g") :{
		  text = "g"
		}
		case strings.HasPrefix(p, "h") :{
		  text = "h"
		}
		case strings.HasPrefix(p, "i") :{
		  text = "i"
		}
		case strings.HasPrefix(p, "j") :{
		  text = "j"
		}
		case strings.HasPrefix(p, "k") :{
		  text = "k"
		}
		case strings.HasPrefix(p, "l") :{
		  text = "l"
		}
                case strings.HasPrefix(p, "m") :{
		  text = "m"
		}
		case strings.HasPrefix(p, "n") :{
		  text = "n"
		}
		case strings.HasPrefix(p, "o") :{
		  text = "o"
		}
		case strings.HasPrefix(p, "p") :{
		  text = "p"
		}
		case strings.HasPrefix(p, "q") :{
		  text = "q"
		}
		case strings.HasPrefix(p, "r") :{
		  text = "r"
		}
		case strings.HasPrefix(p, "s") :{
		  text = "s"
		}
		case strings.HasPrefix(p, "t") :{
		  text = "t"
		}
		case strings.HasPrefix(p, "u") :{
		  text = "u"
		}
		case strings.HasPrefix(p, "v") :{
		  text = "v"
		}
		case strings.HasPrefix(p, "w") :{
		  text = "w"
		}
		case strings.HasPrefix(p, "x") :{
		  text = "x"
		}
		case strings.HasPrefix(p, "y") :{
		  text = "y"
		}
		case strings.HasPrefix(p, "z") :{
		  text = "z"
		}

		default:
		  text = "err"
	}
	text = text + "$"
	return text
}