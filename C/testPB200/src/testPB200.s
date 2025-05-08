.file	"testPB200.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.align	2
.globl	main
.type	main, @function

# Stack location
#   RAM[0] -> Temperature readed value


# Testing I2C Module
main:
    li      s1, 0x40020010  # I2C Base Address
    li      s2, 0x4B        # I2C Slave Address
    li      s3, 0x40001000  # Control Status Register BASE Address
    li      s4, 0x40010000  # RAM BASE Address

    # Configuring display
    li      t4, 1           # CREG_OLED_CTRL[0:0] = 1
    sw      t4, 24(s3)      # Display in = CREG_OLED_DATA
    sw      s4, 28(s3)      # Display out = RAM BASE Address

    # Setting GPIOs
    call    setGPIO         # Configuring all LEDs as output

    # Set the LED2
    li      t4, 1           # Led Value
    slli    t4, t4, 26      # LED2 is the 26th bit
    sw      t4, 16(s3)      # CREG_IO[23:23] <= LED2

    # call    wait            # Wait for 1250000 cycles
    # call    wait            # Wait for 1250000 cycles
    # call    wait            # Wait for 1250000 cycles


    # Set Resolution (step 1) 
    sb      s2, 4(s1)       # Write Address
    li      t2, 0x03        # Data to write
    sb      t2, 12(s1)      # Write Data
    li      t2, 0x01        # Data Length
    sb      t2, 16(s1)      # Write Data Length
    sb      t2, 0(s1)       # Write 0x001 to I2C Control Register to start the transaction
    call    wait_busy       # Wait until I2C is not busy    TEST #1

    call    wait            # Wait for 1250000 cycles

    # Set Resolution (step 2)
    sb      s2, 4(s1)       # Write Address
    li      t2, 0x80        # Data to write
    sb      t2, 12(s1)      # Write Data
    li      t2, 0x01        # Data Length
    sb      t2, 16(s1)      # Write Data Length 
    sb      t2, 0(s1)       # Write 0x001 to I2C Control Register to start the WRITE transaction
    call    wait_busy       # Wait until I2C is not busy    TEST #1

    call    wait            # Wait for 1250000 cycles

loop:
    # Write internal register address
    sb      s2, 4(s1)       # Write Address
    li      t2, 0x00        # Select Register 0
    sb      t2, 12(s1)      # Write Data
    li      t2, 0x01        # Data Length
    sb      t2, 16(s1)      # Write Data Length
    sb      t2, 0(s1)       # Write 0x001 to I2C Control Register to start the transaction
    call    wait_busy       # Wait until I2C is not busy

    # Read Data
    sb      s2, 4(s1)       # Write Address
    li      t2, 2           # Data Length
    sb      t2, 16(s1)      # Write Data Length
    li      t2, 0b11        # I2C Control Register 0b01 -> Read and Start
    sb      t2, 0(s1)       # Write Control Register
    call    wait_busy       # Wait until I2C is not busy

    # Get Data from the driver
    call    readI2C         # Read I2C Readed Data
    sw      a0, 0(s4)       # Write Data to RAM BASE Address
    sw      a0, 28(s3)      # CREG_OLED_DATA <= Temperature Readed

    call    wait            # Wait for 1250000 cycles

    j       loop            # Loop
    

wait_busy:
    li      a0, 0          # GPIO0 selected
    call    toggleGPIO
    lb      a0, 0(s1)      # Read Control Register
    li      a1, 0b100      # I2C busy BIT
    andi    a0, a1, 0b100  # Mask I2C busy BIT
    bnez    a0, wait_busy  # Wait until I2C is not busy
    call    toggleGPIO
    ret
    
wait:
    addi    sp, sp, -4
    sw      zero,-4(sp)
    j       L3
L4:
    lw      a5,-4(sp)
    addi    a5,a5,1
    sw      a5,-4(sp)
L3:
    lw      a4,-4(s0)
    li      a5,1250000
    ble     a4,a5,L4
    addi    sp, sp, 4
    ret

readI2C:
    lw      a1, 8(s1)      # Read I2C Readed Data
    mv      a0, a1         
    zext.b  a0, a0         # Zero Extend a0
    slli    a0, a0, 8      # Shift a0 << 8

    srli    a1, a1, 8      # Shift a1 >> 8 
    zext.b  a1, a1         # Zero Extend a1
    or      a0, a0, a1     # OR a0 with a1

    ret

setGPIO:
    addi    s1, s1, -0x10  # GPIO Base Address
    li      t0, 0b1111     # GPIOA DIR reg
    sw      t0, 4(s1)      # GPIOA DIR reg = 0b1111

    addi    s1, s1, 0x10   # GPIO Base Address
    ret

toggleGPIO:
    addi   s1, s1, -0x10  # GPIO Base Address

    lb     a4, 0(s1)      # GPIOA DATA reg
    xor    a4, a4, a0     # Toggle GPIO XX
    sb     a4, 8(s1)      # GPIOA DATA reg = a4

    addi   s1, s1, 0x10   # GPIO Base Address
    ret

