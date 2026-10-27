# example_GPIO_BlinkAsm: blinks the LEDs LD4-LD7 of the ZedBoard, wired to
# GPIO[3:0] of the core (pins 0-3 of port A), in assembly, without libraries
# and without a stack. The assembly version of the old riscv/apps/GPIO, which
# wrote the registers of port D (byte 3, GPIO[31:24], not wired to any pin)
# and waited only 10 iterations between two toggles, too fast to see.
#
# Registers of the GPIO, one byte per port (see GPIO.h of the SDK):
#   0x40020000  input value of port A (GPIO[7:0])
#   0x40020004  direction of port A: 1 = output
#   0x40020008  output value of port A
#
# Registers:
#   t0  base address of the GPIO
#   t1  mask of the LEDs, pins 0-3
#   t2  value of the output register
#   t3  delay counter
#   t4  iterations of the delay loop

.option nopic
.attribute arch, "rv32i2p1"
.section .text.main
.align  2
.globl  main
.type   main, @function

main:
    li      t0, 0x40020000          # base address of the GPIO
    li      t1, 0x0F                # LD4-LD7: pins 0-3 of port A
    li      t4, 1250000             # iterations of the delay loop

    # Pins 0-3 of port A as outputs, the others unchanged
    lbu     t2, 4(t0)
    or      t2, t2, t1
    sb      t2, 4(t0)

blink:
    # Toggle the LEDs: output value XOR mask
    lbu     t2, 8(t0)
    xor     t2, t2, t1
    sb      t2, 8(t0)

    # Busy wait: count t3 from 0 up to t4
    li      t3, 0
delay:
    addi    t3, t3, 1
    blt     t3, t4, delay

    j       blink
