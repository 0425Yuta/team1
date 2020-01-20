# 仕様書
本システムの要求仕様を下記に示す

 * `計算機アーキテクチャ`の章にて示す命令を解釈し、実行可能なこと
 * メモリの一部領域をマッピングし、VGAポートからの出力及びスイッチによる入力が可能であること
 * `コンパイラ`の章にて示すプログラミング言語をアセンブラにコンパイル可能なコンパイラを付属させること
 * `アセンブラ`の章にて示すアセンブリ言語を機械語にコンパイル可能なアセンブラを付属させること

# 設計仕様

## 計算機アーキテクチャ
### メモリ領域
|種別    |名称    |詳細                          |
|:------:|:------:|:-----------------------------|
|スタック| STACK  | 演算に使用する領域           |
|主記憶  | RAM    | 主記憶(ランダムアクセス専用) | 
|        | PROG   | メモリ(PC)で読む             | 
|入出力  | INPUT  | プッシュスイッチにマッピング |
|        | OUTPUT | 画面にマッピング(VGAで出力)  |

### レジスタ
|名称|説明                                                                |
|:--:|:-------------------------------------------------------------------|
| SP | (Stack Pointer) STACKの現在位置                                    |
| FP | (Function Pointer) 関数の呼び出し元の位置の保存場所を指すレジスタ  |
| PC | (Program Counter) PROGの現在位置                                   |
| FPSUB  | FPの一時格納 |
| JMPSUB | FPの一時格納 |
| RET    | 返り値の一時格納 |

STACK, CALLSはそれぞれスタックの現在位置を示すレジスタを持つ。
INPUTは1ビット単位でマッピング、OUTPUTは8bitで一色つまり24bitで一画素を示す。

### 命令
16bit長の命令、若しくは16bit長命令+16bitのオペランド

|種別      | 命令名 | opcode | 引数 | 説明                                                                                    |
|:--------:|:------:|:------:|:----:|:----------------------------------------------------------------------------------------|
|メモリ操作| ign    | 0x0001 |      | スタックをただpopする                                                                   |
|          | imm    | 0x0002 | あり | 次の命令領域の16bitを即値としてpushする                                                 |
|          | stom   | 0x0003 |      | スタックの値を2つpopし、上の値のアドレスに、下の値を書き込む                            |
|          | loadm  | 0x0004 |      | スタックの値を1つpopし、そのアドレスのメモリの内容をpushする                            |
|          | stol   | 0x0005 | あり | スタックの値を2つpopし、上の値のアドレスに、下の値を書き込む                            |
|          | loadl  | 0x0006 | あり | スタックの値を1つpopし、そのアドレスのメモリの内容をpushする                            |
|制御      | jmp    | 0x1000 |      | スタックから値を1つpopし、PCをその値に設定する                                          |
|          | bra    | 0x1001 |      | スタックから値を2つpopし、上の値が非零ならばPCに下の値をセットする                      |
|          | nop    | 0x0000 |      | 何もしない                      |
|          | bec    | 0x1003 |      | スタックから値を1つpopし、JMPSUBにセット。FPSUBに現在のSPをセット。現在のPC、FPをpush   |
|          | call   | 0x1004 |      | FPSUBをFPにセットし、JMPSUBの先にジャンプ                                               |
|          | ret    | 0x1005 |      | RETにスタックのtopを格納、FPをSPにセットしてローカル変数を破棄、FP+1の値にjmpして復帰、FP+2に保存されている元のFPを復元。RETをpush|
|演算      | add    | 0x2000 |      | スタックから値を2つpopし、加算結果をpushする                                            |
|          | sub    | 0x2001 |      | スタックから値を2つpopし、減算結果をpushする                                            |
|          | mul    | 0x2002 |      | スタックから値を2つpopし、乗算結果をpushする                                            |
|          | div    | 0x2003 |      | スタックから値を2つpopし、除算結果をpushする                                            |
|          | mod    | 0x2004 |      | スタックから値を2つpopし、除算の余りをpushする                                          |
|          | gret   | 0x2005 |      | スタックから値を2つpopし、上の値が大きければ1、小さければ0をpushする                    |
|          | less   | 0x2006 |      | スタックから値を2つpopし、上の値が大きければ0、小さければ1をpushする                    |
|          | eq     | 0x2007 |      | スタックから値を2つpopし、等しければ1、そうでなければ0をpushする                        |
|          | neq    | 0x2008 |      | スタックから値を2つpopし、等しければ0、そうでなければ1をpushする                        |
|          | and    | 0x2009 |      | スタックから値を2つpopし、その値のANDをpushする                                         |
|          | or     | 0x200a |      | スタックから値を2つpopし、その値のORをpushする                                          |
|          | xor    | 0x200b |      | スタックから値を2つpopし、その値のXORをpushする                                         |
|          | not    | 0x200c |      | スタックから値を1つpopし、その値のビットを全て反転させpushする                          |

## 関数呼び出し規約
 * becを呼び出す
 * becが現在のスタックの先頭アドレスをJMPSUBにセット、FPSUBに現在のSPをセット
 * becが現在のPC、FPをプッシュ(管理領域)
 * load*、imm、その他の命令を使い引数をスタックに積む
 * callで*SUBを反映してジャンプ
 * ローカル変数の数だけダミーの値をpush
 * 〜処理〜
 * retを呼び出す
 * retがスタックのトップの値をRETに退避
 * retがFPをSPにセットしてスタックを巻き戻す
 * retがFP+1の値(再開位置)をPCにセットして復帰
 * retがFP+2の値(元のFP)をFPにセットしてFPを巻き戻し
 * retがRETをスタックにpush

```
|呼び出し元関数の領域|PC|FP|引数1|引数2|引数3|ローカル変数1|ローカル変数2|自由に使えるスタック領域
```
引数とローカル変数の区別はない。引数、ローカル変数の順にユニークな番号を振り、それをstol、loadl系のoperandに用いる

# コンパイラ

## 言語仕様
```peg
        num <- '-'? '0x' ('a'..'f' | 'A'..'F' | '0'..'9')+
     symbol <- ('a'..'Z' | '_') ('a'..'Z' | '_' | '0'..'9')*
   operator <- '+' | '-' | '*' | '/' | '%' | '^' | '!' | '|' | '||' | '&' | '&&' | '=='

       expr <- num | symbol | (expr operator expr)


      while <- 'while' '(' expr ')' '{' stmt* '}'
         if <- 'if' '(' expr ')' '{' stmt* '}' 'else' '{' stmt* '}'
     return <- 'return' expr ';'
declaration <- 'var' symbol ('[' num ']')? = expr ';'
     assign <- symbol '=' expr ';'
  loop-ctrl <- ('break' | 'continue') ';'

    comment <- '//' .* \br
       stmt <- while | if | return | declaration | assign | loop-ctrl | comment

   function <- 'func' symbol '(' symbol (',' symbol)* ')' '{' stmt* '}'

    program <- function+
```

# エミュレータ
アセンブラの出力したバイナリファイルをコマンドラインから渡し、GUIにてVGAへの出力をエミュレートする。
入力はキーボードにて行う。

# アセンブラ
## 出力
バイナリファイル

## アセンブリ言語仕様
```
 opcode <- <opecodes>
operand <- '-'? '0x'? ('a'..'f' | 'A'..'F' | '0'..'9')+
comment <- ';' .* \br
 symbol <- ('a'..'Z' | '_') ('a'..'Z' | '_' | '0'..'9')*
  label <- symbol ':' \br
   stmt <- (opecode operand? | label) (\br | comment) | comment
```
### ラベル
関数名をアドレス直打ちでやるのは流石に面倒なのでラベルを宣言し、アドレス直打ちの代わりにラベル名で使用できるようにする。
### 例
```c
func add3(a, b, c) {
	return a + b + c;
}

func foo() {
	var a = 1 + 2;
	var b = 3 * 4;
	var c = 7 - 5;
	return add3(c / (a+b), 1, 2);
}
```

```asm
add3:
loadl 0
loadl 1
add
loadl 2
add
ret

foo:
imm 0; ローカル変数確保 (a)
imm 0; ローカル変数確保 (b)
imm 0; ローカル変数確保 (c)
imm 0; ローカル変数(一時用)確保 (a+b)
imm 0; ローカル変数(一時用)確保 (c / (a+b))
imm 1
imm 2
add
stol 0
imm 3
imm 4
mul
stol 1
imm 7
imm 5
sub
stol 2
loadl 0
loadl 1
add
stol 3
loadl 2
loadl 3
div
stol 4
bec
loadl 4
imm 1
imm 2
call
ret
```
