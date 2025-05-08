.file	"testUART_GPIO.s"
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
    lui     t0, 0x40020
    addi    t0, t0, 0x10    # I2C Base Address
    li      t1, 0x56        # I2C Slave Address
    li      t2, 0x76        # Data to be written/readed
    li      t3, 0x01        # Number of bytes to be written/readed
    li      t4, 0b01        # I2C Control Register 0b11 -> Write and Start
    li      s1, 0x40010194  # Address of the pointer to I2CReg Address (Leggi dalla ram l'indirizzo)

test:
    # Write Data
    sb      t1, 4(t0)       # Write Address
    sb      t2, 12(t0)      # Write Data
    sb      t3, 16(t0)      # Write Data Length
    sb      t4, 0(t0)       # Write Control Register
    call    wait_busy       # Wait until I2C is not busy    TEST #1
                            #  (in the wait_busy function)  TEST #2 -> Check if busy bit is asserted
                            #  (in the wait_busy function)  TEST #3 -> Check resoult of the andi operation on the I2C CSReg
                            #                               TEST #4 -> Check if the slave interface recived the data correctly
read:
    # Read Data
    li      t4, 0b11        # I2C Control Register 0b01 -> Read and Start
    sb      t4, 0(t0)       # Write Control Register        TEST #5
    call    wait_busy       # Wait until I2C is not busy
                            #  (in the wait_busy function)  TEST #6 -> Check if busy bit is asserted
                            #  (in the wait_busy function)  TEST #7 -> Check resoult of the andi operation on the I2C CSReg
load:
    # Load Data
    lw      t4, 8(t0)       # Read Data
    sw      t4, 0x00(sp)    # Store Data                    TEST #8
    lb      t4, 20(t0)      # Read Data Length (Puo dare problemi il fatto che sia signed)
    beq     t4, t3, test_l  # Check if length is correct    TEST #9
    li      t4, 0x00        # Data Length is not correct
test_l:
    sw     t4, -4(sp)       # Store Data Length             

setup_write2:
    # Setup a write of 2 bytes
    slli    t2, t2, 8       # Shift Data for 8 bits
    ori     t2, t2, 0xC4    # Add Data
    li      t3, 0x02        # Number of bytes to be written/readed
    li      t4, 0b01        # I2C Control Register 0b01 -> Write and Start
                            #                               TEST #10 -> Check all the values are correct

write2:
    # Write Data
    sb      t1, 4(t0)       # Write Address
    sh      t2, 12(t0)      # Write Data
    sb      t3, 16(t0)      # Write Data Length
    sb      t4, 0(t0)       # START Write Transaction       TEST #11 -> Check if the write transaction is started
    call    wait_busy       # Wait until I2C is not busy    

read2:
    # Read Data
    li      t4, 0b11        # I2C Control Register 0b01 -> Read and Start
    sb      t4, 0(t0)       # Write Control Register        TEST #12 -> Check if the read transaction is started
    call    wait_busy       # Wait until I2C is not busy

load2:
    # Load Data
    lw      t4, 8(t0)       # Read Data                     TEST #13 -> Check if the data is readed correctly
    sw      t4, -8(sp)      # Store Data                    
    lb      t4, 20(t0)      # Read Data Length              TEST #14 -> Check if the length is correct   
    beq     t4, t3, test_l2 # Check if Data Length is correct
    li      t4, 0x00        # Data Length is not correct
test_l2:
    sw     t4, -12(sp)      # Store Data Length             TEST #6

    j       .               # End of the test

wait_busy:
    lui     t5, 0x40010
    lw      t5, 0x0194(t5)  # Load I2CReg Address
    lbu     t5, 0(t5)       # Read Control Register
    zext.b  t5, t5          # Zero Extend to 32 bits
    andi    t5, t5, 0b100   # Mask I2C busy BIT
    bnez    t5, wait_busy   # Wait until I2C is not busy
    ret
