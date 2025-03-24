.file	"echoI2C.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	main
.type	main, @function

# Testing I2C Module
main:
    li      s1, 0x40020010  # I2C Base Address
    li      s2, 0x40010010  # I2C Virtual Base Register
loop:
    # Load VIRTUAL I2C CSREG
    lw      a0, 0(s2)       # Read V I2C CSREG
    andi    a0, a0, 0b11    # Clear all bits except 0 and 1 (I2C_start and I2C_RWn)
    
    lw      a1, 0(s1)       # Read I2C CSREG
    or      a1, a1, a0      # Copy I2C_start and I2C_RWn to I2C CSREG
    sw      a1, 0(s1)       # Write I2C CSREG
    sw      a1, 0(s2)       # Write V I2C CSREG

    # Copy from I2C Interface to VIRTUAL I2C Interface (RDATA, LEN, LEN_O)
    lw      a0, 8(s1)       # Read I2C RDATA
    sw      a0, 8(s2)       # Write V I2C RDATA

    lw      a0, 16(s1)      # Read I2C LEN
    sw      a0, 16(s2)      # Write V I2C LEN

    lw      a0, 20(s1)      # Read I2C LEN_O
    sw      a0, 20(s2)      # Write V I2C LEN_O

    # Copy from VIRTUAL I2C Interface to I2C Interface (ADDR, WDATA)
    lw      a0, 4(s2)       # Read V I2C ADDR
    sw      a0, 4(s1)       # Write I2C ADDR

    lw      a0, 12(s2)      # Read V I2C WDATA
    sw      a0, 12(s1)      # Write I2C WDATA
    
    j       loop
