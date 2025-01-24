.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	cat_registers
.type	cat_registers, @function
cat_registers:
    sw x1, 0(sp)
    sw x2, -4(sp)
    sw x3, -8(sp)
    sw x4, -12(sp)
    sw x5, -16(sp)
    sw x6, -20(sp)
    sw x7, -24(sp)
    sw x8, -28(sp)
    sw x9, -32(sp)
    sw x10, -36(sp)
    sw x11, -40(sp)
    sw x12, -44(sp)
    sw x13, -48(sp)
    sw x14, -52(sp)
    sw x15, -56(sp)
    sw x16, -60(sp)
    sw x17, -64(sp)
    sw x18, -68(sp)
    sw x19, -72(sp)
    sw x20, -76(sp)
    sw x21, -80(sp)
    sw x22, -84(sp)
    sw x23, -88(sp)
    sw x24, -92(sp)
    sw x25, -96(sp)
    sw x26, -100(sp)
    sw x27, -104(sp)
    sw x28, -108(sp)
    sw x29, -112(sp)
    sw x30, -116(sp)
    sw x31, -120(sp)
    ret
