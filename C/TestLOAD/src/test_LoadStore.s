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
    lw   x10, -160(sp)        # x1 <- Mem[0x40011ffc-160d] // x1 = 25
    sw   x10, -164(sp)        # Mem[sp - 4] <- x1 // Mem[0x40011ffc-164d] =  25
    addi x11, x0, -27       # x2 <- 1
    sw   x11, -168(sp)        # Mem[sp - 8] <- x2 // Mem[0x40011ffc-168d] = -27
    lui  x12, 0x40020      # x3 <- 0x400200000 GPIO BASE ADDRESS
    addi x13, x0, 1         # x4 <- 1
    sw   x13, 4(x12)        # Mem[x12 + 4] <- x4 // GPIO[0x40020004] = 1    // GPIO_DIR_REG
    sw   x13, 8(x12)        # Mem[x12 + 8] <- x4 // GPIO[0x40020008] = 1    // GPIO_OUT_REG
    lw   x14, 0(x12)        # x5 <- Mem[x12] // x5 = 1                      // GPIO_VALUE
    call cat_registers     # call cat_registers
L1:
    j    L1               # trap CPU
    