/*Semplice for*/
    li x2, 0
    li x3, 10
    li ra, 0
    li x5, 0
loop:
    bge x2, x3, exit
    addi x2, x2, 1
    j loop
exit:
    auipc x5, 0x7ffff
    ret