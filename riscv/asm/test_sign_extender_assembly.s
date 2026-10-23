_boot:
    /* Test I type */
    addi x0, x1, 10         /* +10*/
    addi x0, x1, -30        /* -30*/
    
    /* Test U type*/
    lui x0, 1               /* +4096*/
    lui x0, 524288          /* -2^31*/
    auipc x2, 1             /* +4096*/
    auipc x2, 524288        /* -2^31*/
    
    /* Test B Type*/
    beq x1, x2, _boot     	/* =-6 * 4 = -24*/
   	beq x1, x2, _L1			/* = 3 * 4 =  12*/
    
    /* Test S Type*/
    sw x2, -3(x4)           /* -3*/
    sw x4, 2(x3)            /* +2*/
_L1:
    /* Test J Type*/
    jal x1, _boot
    jal x2, _L2
_L2:
    