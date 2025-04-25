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
    addi   x1, x0,-16       # x1 <- -16
    addi   x20, x1, 1        # x20 <- x1 + 1  // x20 = -15
    add    x3, x20, x1      # x3 <- x20 + x1 // x3 = -31
    lui    x3, 0x40010      # x3 <- 0x40010000 // x3 = RAM_START
    sw     x1, 0(x3)        # Mem[x3] <- -16 // Mem[0x40010000] = -16   //PENSARE SE c'è un modo per testare questa istruzione
    lw     x4, 0(x3)        # x4 <- Mem[x3] // x4 = -16
    nop    #mv     x4, x1           # LOADS do not wowk for now; to continue whit testing, we need to set x4 = x1
    beq    x4, x1, L1       # if x4 == x1, goto L1 // instr=0xff9ff06f
L2:
    lui    x6, 0x40004      # x6 <- 0x40004
    li     x14, 2           # x14 <- 2
    sw     x14, 0(x6)       # Mem[x6] <- 2 //res = 1 && run = 0 
    jalr   x0, 0(x5)        # goto L3 (aka ret x5)
L1:
    jal    x5, L2           # else, goto L2 // instr=400042b7 // x5 = PC + 4 = 0x40000028
L3:
    auipc  x7, 4            # x7 <- PC + 4 // x7 = 0x40004030
    sw     x7, -8(x8)       # Mem[x8] <- x7 // Mem[0x40011ff8] = 0x40004030
    addi   x8, x8, -8       # x8 <- x8 - 4 // x8 = 0x40011ff4
    lui    x9, 0x40020      # x9 <- 0x40020 // x9 = 0x40020000 (GPIO START) GPIO_VALUE
    addi   x10, x0, 1       # x10 <- 1 // x10 = 1
    sw     x10, 4(x9)       # Mem[x9 + 4] <- x10 // GPIO[0x40020004] = 1    // GPIO_DIR_REG
    sw     x10, 8(x9)       # Mem[x9 + 8] <- x10 // GPIO[0x40020008] = 1    // GPIO_OUT_REG
    lw     x11, 0(x9)       # x11 <- Mem[x9] // x11 = 1                     // GPIO_VALUE
    lui    x12, 0x40000     # x12 <- 0x40000 // x12 = 0x40000000
    sw     x12, 0(x12)      # Mem[x12] <- x12 // Mem[0x40000000] = 0x40000000        // AXI WRITE
    lw     x13, 0(x12)      # x13 <- Mem[x12] // x13 = 0x40000000                    // AXI READ
    call   cat_registers    # call cat_registers
L4:
    j      L4               # trap CPU
