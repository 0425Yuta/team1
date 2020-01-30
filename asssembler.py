with open('textfile.txt', 'r') as src:
     #print(src.read())
    st = ' '
    s0 = 0
    s1 = 0
    s2 = 0
    s3 = 0
    s4 = 0
    s5 = 0
    s6 = 0
    s7 = 0
    s8 = 0
    s9 = 0
    s10 = 0
    s = 0
    ss  = 0
    sss  = 0
    ssss  = 0
    val = 0
    innum = 0
    address = -1
    num = 0

    #opcode_table辞書の作成
    opcode_table = {'ign':1, 'imm':2, 'stom':3, 'loadm':4, 'stol':5, 'loadl':6, 'cp':7,
        'jmp':4096, 'bra':4097, 'nop':0, 'bec':4099, 'call':4100, 'ret':4101,
        'add':8192, 'sub':8193, 'mul':8194, 'div':8195, 'mod':8196, 'gret':8197, 'less':8198,
        'ep':8199, 'neq':8200, 'and':8201, 'or':8202, 'xor':8203, 'not':8204}

    def meirei_hikisuu(val,innum): #引数あり命令の中身
        s0 = format(4, '02x') #引数なしのノーマル命令の時最初は'02'で固定
        print(s0)

        s1 = format(address, '04x')#adressを16進数に直して4桁表示
        print(s1)

        s2 = address>>2         #ここを直す　上位２桁表示　
        s3 = format(s2, '02x')
        print(s3)

        s4 = address&0xff       #下位２桁表示　
        s5 = format(s4, '02x')
        print(s5)

        s6 = format(val, '04x')#valを16進数に直して4桁表示
        print(s6)

        s7 = val>>8         #ここを直す　上位２桁表示　
        s8 = format(s7, '02x')
        print(s8)

        s9 = val&0xff       #下位２桁表示　
        s10 = format(s9, '02x')
        print(s10)

        hikihiki = format(innum, '04x')
        print('innum=',hikihiki)

        s = innum>>8        #ここを直す　上位２桁表示　
        ss = format(s, '02x')
        print(ss)

        sss = innum&0xff       #hikihiki下位２桁表示
        ssss = format(sss, '02x')
        print(ssss)


        x = int(s0,16) + int(s3,16) + int(s5,16) + int(s8,16) + int(s10,16) + int(ss,16) + int(ssss,16)
        print(x)

        x1 = (~x+1)&0xff
        b = format(x1, '02x')
        print(b)

        ji =':' + s0 + s1 + '00' + s6 + hikihiki + b
        file.write(ji+'\n')

    def meirei(val,num): #普通の命令の中身
        s0 = format(2, '02x') #引数なしのノーマル命令の時最初は'02'で固定
        print(s0)

        s1 = format(address, '04x')#adressを16進数に直して4桁表示
        print(s1)

        s2 = address>>8         #ここを直す　上位２桁表示　失敗
        s3 = format(s2, '02x')
        print(s3)

        s4 = address&0xff       #下位２桁表示　成功
        s5 = format(s4, '02x')
        print(s5)

        s6 = format(val, '04x')#aを16進数に直して4桁表示
        print(s6)

        s7 = val>>8         #ここを直す　上位２桁表示　失敗
        s8 = format(s7, '02x')
        print(s8)

        s9 = val&0xff       #下位２桁表示　成功
        s10 = format(s9, '02x')
        print(s10)

        x = int(s0,16) + int(s3,16) + int(s5,16) + int(s8,16) + int(s10,16)
        print(x)

        x1 = (~x+1)&0xff
        b = format(x1, '02x')
        print(b)

        ji =':' + s0 + s1 + '00' + s6 + b
        file.write(ji+'\n')

    file = open('a.hex', 'w')

    splited = []
    
    memo = {}
    addr = 0
    
    for line in src:    
        code, _, _ = line.partition(';')
        tokens = code.split()
        tokens = list(filter(lambda s: s != '', tokens))
        if len(tokens) <= 0:
            continue
        elif tokens[0].endswith(':'):
            # ラベル
            memo[tokens[0][:-1]] = addr
            print('detect label')
        else:
            addr += len(tokens)
            splited.append(tokens)
    
    print(memo)

    
    print(splited)


    for spt in splited:
        address = address + 1
        print("検索=",opcode_table[spt[0]])
        val = opcode_table[spt[0]]

        if len(spt[1:])==0:
            meirei(val,num)
        else:
            for operand in spt[1:]:
                if operand.isdecimal():
                    num = int(operand)
                    print(num)
                    innum = num
                    meirei_hikisuu(val,innum)
                    address = address + 1
                
                else:
                    print("検索=",memo[operand])
                    num = memo[operand]
                    innum = num
                    meirei_hikisuu(val,innum)
                    address = address + 1