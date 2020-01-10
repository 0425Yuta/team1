#!/usr/bin/python
import struct
import sys
import re

tbl = {
        'ign': 0x00,
        'imm': 0x01,
        'stom': 0x02,
        'loadm': 0x03,
        'stol': 0x04,
        'loadl': 0x05,
        'jmp': 0x06,
        'bra': 0x07,
        'bec': 0x08,
        'call': 0x09,
        'ret': 0x0a,
        'nop': 0x18,
        'add': 0x0b,
        'sub': 0x0c,
        'mul': 0x0d,
        'div': 0x0e,
        'mod': 0x0f,
        'gret': 0x10,
        'less': 0x11,
        'eq': 0x12,
        'neq': 0x13,
        'and': 0x14,
        'or': 0x15,
        'xor': 0x16,
        'not': 0x17,
        }

def sep(i):
    return (i >> 8) & 0xff, (i & 0xff) 

def tohex(binaries):
    addr = 0
    for line in binaries:
        bins = []
        for word in line:
            head, tail = sep(word)
            bins.append(head)
            bins.append(tail)
        bytecount = len(bins)
        addr_head, addr_tail = sep(addr)
        checksum = bytecount + addr_head + addr_tail
        data = ''
        for b in bins:
            data += '{:02x}'.format(b)
            checksum += b

        checksum = (~(0xff & checksum) + 1) & 0xff
        print(':{:02x}{:04x}00{}{:02x}'.format(bytecount, addr, data, checksum))
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
