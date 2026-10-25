.file	"test_ID.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
# .text.main
.section .text.main
.align	2
.globl	main
.type	main, @function
main:
    addi x10, x0, -16       # x1 <- -16
    lw   x10, -160(sp)      # x1 <- Mem[0x40011ffc-160d] // x1 = 25
    sw   x10, -164(sp)      # Mem[sp - 4] <- x1 // Mem[0x40011ffc-164d] =  25
    addi x11, x0, -27       # x2 <- 1
    sw   x11, -168(sp)      # Mem[sp - 8] <- x2 // Mem[0x40011ffc-168d] = -27
    lui  x12, 0x40020       # x3 <- 0x400200000 GPIO BASE ADDRESS
    addi x13, x0, 1         # x4 <- 1
    sw   x13, 4(x12)        # Mem[x12 + 4] <- x4 // GPIO[0x40020004] = 1    // GPIO_DIR_REG
    sw   x13, 8(x12)        # Mem[x12 + 8] <- x4 // GPIO[0x40020008] = 1    // GPIO_OUT_REG
    lw   x14, 0(x12)        # x5 <- Mem[x12] // x5 = 1                      // GPIO_VALUE

    #Test #6: "endianess"
    li   x15, 0x04030201    # x6 <- 0x04030201
    sw   x15, -172(sp)      # Mem[0x40011FF50] <- x6 // Mem[0x40011ffc-172d] = 0x04030201

    li   x15, 0x01
    sb   x15, -176(sp)      # Mem[0x40011FF4C] <- 0x01 // Mem[0x40011ffc-176d] = 0x01
    li   x15, 0x02
    sb   x15, -175(sp)
    li   x15, 0x03
    sb   x15, -174(sp)
    li   x15, 0x04
    sb   x15, -173(sp)

    li   x15, 0x04030201
    lw   x16, -176(sp)
    beq  x15, x16, L2
    li   x17, 0
    j    L3
L2:
    li   x17, 1
L3:
    sw   x17, -180(sp)

    call cat_registers     # call cat_registers
L1:
    j    L1               # trap CPU
    