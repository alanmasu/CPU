// ANDI on a value read from the GPIO: the testbench checks the result in a6
// (x16) when the CPU reaches the final loop. Written from the program that
// was hardcoded in test_CPU_wh_AXI.sv as and_array.
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.section .text.main
.align	2
.globl	main
.type	main, @function
main:
    lui     x6, 0x40020     // x6 <- 0x40020000, GPIO base address
    lw      x16, 0(x6)      // x16 <- GPIO value
    andi    x16, x16, 0x3e  // x16 <- x16 & 0x3e
L1:
    j       L1              // trap CPU
