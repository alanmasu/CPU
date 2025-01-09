main:   
    lui     s0,0x40012
    addi    s0,s0,-1 # s0 <- 0x40011FFF (s0 = RAM END Address)
    lui     t0,0x40020
    lw      a4,0x007(t0) # a4 <- Mem[0x40020007] (GPIOA DIR reg)
    ori     a4,a4,1
    sb      a4,0x007(t0) # Mem[0x40020007] <- a4
L2:
    #Turn off the LED
    lw      a4,0x00B(t0) # a4 <- Mem[0x4002000B] (GPIOA DATA reg)
    andi    a4,a4,-2     # a4 <- a4 & !GPIO1    
    sb      a4,0x00B(t0)
#for (int i = 0; i < 10; i++)
    sw      zero,-20(s0)
    j       L3
L4:
    lw      a5,-20(s0)
    addi    a5,a5,1
    sw      a5,-20(s0)
L3:
    lw      a4,-20(s0)
    li      a5,9
    ble     a4,a5,L4

#Turn on the LED
    lw      a4,0x00B(t0) # a4 <- Mem[0x4002000B] (GPIOA DATA reg)
    ori     a4,a4,1      # a4 <- a4 | GPIO1    
    sb      a4,0x00B(t0)

#for (int i = 0; i < 10; i++)
    sw      zero,-20(s0)
    j       L5
L6:
    lw      a5,-20(s0)
    addi    a5,a5,1
    sw      a5,-20(s0)
L5:
    lw      a4,-20(s0)
    li      a5,9
    ble     a4,a5,L6

    j       L2 # while(1)