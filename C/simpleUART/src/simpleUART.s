.file	"test_GPIO.s"
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
    lui     t0,0xE0001
    li      t1, 99   #c
    li      t2, 105  #i
    li      t3, 97   #a
    li      t4, 111  #o
    li      t5, 10   #newline
    li      t6, 13   #carriage return
    sw      t1, 0x30(t0) #c
    call    delay
    sw      t2, 0x34(t0) #i
    call    delay
    sw      t3, 0x38(t0) #a
    call    delay
    sw      t4, 0x3C(t0) #o
    call    delay
    sw      t5, 0x40(t0) #newline
    call    delay
    sw      t6, 0x44(t0) #carriage return
    call    delay
    lui     t0, 0x40004  #CREG_BASE
    li      t1, 2
    sw      t1, 0(t0) #trap the CPU
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
    li      a5,120
    ble     a4,a5,L4
    ret
    