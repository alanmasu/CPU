main:
        lui     t0,0x40020
        lw      a4,0x007(t0) # a4 <- Mem[0x40020007] (GPIOA DIR reg)
        ori     a4,a4,1
        sb      a4,0x007(t0) # Mem[0x40020007] <- a4
L2:
        lw      a4,0x00B(t0) # a4 <- Mem[0x4002000B] (GPIOA DATA reg)
        andi    a4,a4,-2     # a4 <- a4 & !GPIO1    
        sb      a4,0x00B(t0)
        lw      a4,0x00B(t0) # a4 <- Mem[0x4002000B] (GPIOA DATA reg)
        ori     a4,a4,1      # a4 <- a4 | GPIO1    
        sb      a4,0x00B(t0)
        j       L2