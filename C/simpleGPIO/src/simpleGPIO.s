.file	"test_GPIO.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	main
.type	main, @function
main:
    lui     t0,0x40020
    addi    a4, zero, 1  # a4 <- 1
    sb      a4,0x007(t0) # Mem[0x40020007] <- a4 (GPIOA DIR reg)  ## Set GPIO0 as output
    sb      a4,0x00B(t0) # a4 <- Mem[0x4002000B] (GPIOA DATA reg) ## Set GPIO0 HIGH
    