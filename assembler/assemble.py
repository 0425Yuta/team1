#!/usr/bin/python
import struct
import sys
import re

tbl = {
        'ign'  : 0x0001,
        'imm'  : 0x0002,
        'stom' : 0x0003,
        'loadm': 0x0004,
        'stol' : 0x0005,
        'loadl': 0x0006,
        'cp'   : 0x0007,
        'jmp'  : 0x1000,
        'bra'  : 0x1001,
        'bec'  : 0x1003,
        'call' : 0x1004,
        'ret'  : 0x1005,
        'nop'  : 0x0000,
        'add'  : 0x2000,
        'sub'  : 0x2001,
        'mul'  : 0x2002,
        'div'  : 0x2003,
        'mod'  : 0x2004,
        'gret' : 0x2005,
        'less' : 0x2006,
        'eq'   : 0x2007,
        'neq'  : 0x2008,
        'and'  : 0x2009,
        'or'   : 0x200a,
        'xor'  : 0x200b,
        'not'  : 0x200c,
        }

def sep(i):
    return (i >> 8) & 0xff, (i & 0xff) 

def tohex(binaries):
    addr = 0
    for line in binaries:
        data = ''
        checksum = 0
        for word in line:
            head, tail = sep(word)
            data += '{:02x}{:02x}'.format(head, tail)
            checksum += head + tail

        bytecount = len(line) * 2
        addr_head, addr_tail = sep(addr)
        checksum += bytecount + addr_head + addr_tail
        checksum = (~checksum+1) & 0xff
        print(':{:02x}{:04x}00{}{:02x}'.format(bytecount, addr, data, checksum))
        addr += len(line)
    print(':00000001ff')
        
# return array of word
def assemble(lines):
    labels = {}
    pos = 0x00
    results = []
    binaries = []

    label_matcher = re.compile(r'\D\w*:')
    number_matcher = re.compile(r'\d\w*')

    for line in lines:
        cut_comment = line.split(';')[0]
        tokens = list(filter(lambda x: len(x) > 0, cut_comment.split(' ')))
        if len(tokens) < 1:
            continue
        if label_matcher.match(tokens[0]) and len(tokens) == 1:
            labels[tokens[0][:-1]] = pos
        elif tokens[0] in tbl:
            results.append((tbl[tokens[0]], tokens[1:]))
            pos += len(tokens)
        else:
            return None
    
    binaries = []
    for (opcode, operands) in results:
        line = []
        line.append(opcode)
        for operand in operands:
            if operand in labels:
                line.append(labels[operand])
            else:
                line.append(int(operand))
        binaries.append(line)
    
    tohex(binaries)
        

if __name__ == '__main__':
    with open(sys.argv[1], 'r') as f:
        result = assemble(f.read().split('\n'))
