.file	"test_ID.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	main
.type	main, @function
main:
    addi   x1, x0,-16       # x1 <- -16
    addi   x2, x1, 1        # x2 <- x1 + 1  // x2 = -15
    add    x3, x2, x1       # x3 <- x2 + x1 // x3 = -31
    lui    x3, 0x40012      # x3 <- 0x40012 // x3 = RAM_END
    sw     x1, -4(x3)       # Mem[x3 - 4] <- -16   //PENSARE SE c'è un modo per testare questa istruzione
    lw     x4, -4(x3)       # x4 <- Mem[x3 - 4] // x4 = -16
    beq    x4, x1, L1       # if x4 == x1, goto L1 // instr=0xff9ff06f
L2:
    lui    x6, 0x40001      # x6 <- 0x40001
    sw     x0, 0(x6)        # Mem[x6] <- 0 //run = 0
    jalr   x0, 0(x5)        # goto L3
L1:
    jal    x5, L2           # else, goto L2 // instr=400012b7 // x5 = PC + 4 = 0x40000028
L3:
