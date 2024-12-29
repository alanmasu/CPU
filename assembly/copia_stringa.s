    .file   "main.c"
    .option nopic
    .attribute arch, "rv32i2p1"
    .attribute unaligned_access, 0
    .attribute stack_align, 16
    .text
    .align  2
    .globl  main
    .type   main, @function
main:
    addi    sp, zero, 2047
    addi    sp,sp,-48
    sw      ra,44(sp)
    sw      s0,40(sp)
    addi    s0,sp,48
    li      a5,1868656640
    addi    a5,a5,-1693
    sw      a5,-28(s0)
    sw      zero,-24(s0)
    sh      zero,-20(s0)
    sw      zero,-40(s0)
    sw      zero,-36(s0)
    sh      zero,-32(s0)
    addi    a4,s0,-40
    addi    a5,s0,-28
    mv      a1,a4
    mv      a0,a5
    call    copia_stringa
    li      a5,0
    mv      a0,a5
    lw      ra,44(sp)
    lw      s0,40(sp)
    addi    sp,sp,48
    jr      ra
    .size   main, .-main
    .align  2
    .globl  copia_stringa
    .type   copia_stringa, @function
copia_stringa:
    addi    sp,sp,-48
    sw      s0,44(sp)
    addi    s0,sp,48
    sw      a0,-36(s0)
    sw      a1,-40(s0)
    sw      zero,-20(s0)
    j       .L4
.L5:
    lw      a4,-36(s0)
    lw      a5,-20(s0)
    add     a4,a4,a5
    lw      a3,-40(s0)
    lw      a5,-20(s0)
    add     a5,a3,a5
    lbu     a4,0(a4)
    sb      a4,0(a5)
.L4:
    lw      a4,-36(s0)
    lw      a5,-20(s0)
    add     a5,a4,a5
    lbu     a5,0(a5)
    bne     a5,zero,.L5
    nop
    nop
    lw      s0,44(sp)
    addi    sp,sp,48
    jr      ra
