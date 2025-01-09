
main:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        lui     a5,0x40020
        lw      a5,0x007
        lbu     a4,0(a5)
        lui     a5,0x40020
        lw      a5,0x007
        ori     a4,a4,1
        andi    a4,a4,0xff
        sb      a4,0(a5)
L6:
        lui     a5,0x40020
        lw      a5,0x00B
        lbu     a4,0(a5)
        lui     a5,0x40020
        lw      a5,0x00B
        andi    a4,a4,-2
        andi    a4,a4,0xff
        sb      a4,0(a5)
        sw      zero,-20(s0)
        j       L2
L3:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
L2:
        lw      a4,-20(s0)
        li      a5,999424
        addi    a5,a5,575
        ble     a4,a5,L3
        lui     a5,0x40020
        lw      a5,0x00B
        lbu     a4,0(a5)
        lui     a5,0x40020
        lw      a5,0x00B
        ori     a4,a4,1
        andi    a4,a4,0xff
        sb      a4,0(a5)
        sw      zero,-24(s0)
        j       L4
L5:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
L4:
        lw      a4,-24(s0)
        li      a5,999424
        addi    a5,a5,575
        ble     a4,a5,L5
        j       L6