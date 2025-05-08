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
    # load 'g' to x29, 'o' to x30, 'a' to x31 
    li      t4, 10           # \n  
    # li      s8, 0b011111110
    li      s8, -2
while:
    lw      a2, 0(t1)
    li      a0, 'g'          # 'g' 
    jal     a1, compose

    li      a0, 'o'          # 'o'
    ori     a2, a2, 1
    jal     a1, compose

    li      a0, 'a'          # 'a'
    and     a2, a2, s8
    jal     a1, compose

    lw      a6, 0(t1)
    andi    a6, a6, 0b11110
    li      a0, 'a'          # 'a'
    jal     a1, send_d
    li      a0, 'i'          # 'i'
    mv      a2, a6
    jal     a1, compose

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

send_n:
    sw      t4, 0x30(t0)
    call    delay
    call    delay
    jalr    zero, a1, 0
    
send_d:
    sw      a0, 0x30(t0)
    # call    delay
    # call    delay
    jalr    zero, a1, 0

# print a0 a2 \n
compose:
    sw      a0, 0x30(t0)
    nop
    nop
    sw      a2, 0x30(t0)
    nop
    nop
    sw      t4, 0x30(t0)
    call    delay
    call    delay
    jalr    zero, a1, 0

