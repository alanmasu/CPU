li sp, 0x7ff
li x1, 65
li x2, 66
lui x3, 0x7234
addi x3, x3, 0x5678
addi sp, sp, -4
sb x1, 0(sp)
sb x2, 1(sp)
sh x3, 2(sp)