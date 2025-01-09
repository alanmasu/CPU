main:
        lui     a5,0x40020
        lw      a4,0x007(a5)
        lbu     a5,0(a4)
        ori     a5,a5,1
        sb      a5,0(a4)
        lui     a3,0x40020
L4:
        lw      a4,0x00B(a3)
        lbu     a5,0(a4)
        andi    a5,a5,-2
        sb      a5,0(a4)
        li      a5,999424
        addi    a5,a5,576
L2:
        addi    a5,a5,-1
        bne     a5,zero,L2
        lw      a4,0x00B(a3)
        lbu     a5,0(a4)
        ori     a5,a5,1
        sb      a5,0(a4)
        li      a5,999424
        addi    a5,a5,576
L3:
        addi    a5,a5,-1
        bne     a5,zero,L3
        j       L4