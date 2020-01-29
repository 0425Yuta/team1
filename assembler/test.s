nop
imm 1
entry:
sync
imm entry

imm 0
loadm
imm 1
and

bra

imm 2
add
imm 1
stom
sync
jmp entry
