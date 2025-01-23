.file	"testUART_GPIO.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	main
.type	main, @function
# 0xE0001000
main:
    lui     t0, 0xE0001
    lui     t1, 0x40020
    #li      t4, 13        # \n       
while:
    lw      t2, 0(t1)
    sw      t2, 0x30(t0)
    #li      t4, 13        # \n       
    call    delay
    call    delay
    j       while

L1:
    j       L1
delay:
    sw      zero,-4(fp)
    j       L3
L4:
    lw      a5,-4(fp)
    addi    a5,a5,1
    sw      a5,-4(fp)
L3:
    lw      a4,-4(fp)
    li      a5,1250000
    ble     a4,a5,L4
    ret
    