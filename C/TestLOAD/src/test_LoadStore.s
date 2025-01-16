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
    call cat_registers     # call cat_registers
L1:
    j    L1               # trap CPU
    