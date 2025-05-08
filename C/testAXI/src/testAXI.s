.file	"test_AXI.s"
.option nopic
.attribute arch, "rv32i2p1"
.attribute unaligned_access, 0
.attribute stack_align, 16
# .text.main
.section .text.main
.align	2
.globl	main
.type	main, @function

main:
    nop
    li a0, 0x40000020
    sw a0, 0(a0)
    lw a1, 0(a0)
    sw a1, 0(sp)
    li t1, 0xE000102C
    sw t1, 0(t1)
    li s1, 0
    lw t4, 0(t1)
    andi t4, t4, 2
    j       .                #Fine del programma    

    
    
    # ############## AXI ################
    # li      t0, 0x10B2ACF8   #Valore da scrivere in memoria
    # li      t1, 0x40000000   #Indirizzo AXI
    # li      fp, 0x40010078   #Dove avevo lasiato la memoria finiti i test di load [30 * 4 + 0x40010000]

    # # Test 31: SW (Store Word) via AXI
    # sw      t0, 0(t1)        #Salva t0 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 32: SW (Store Word) via AXI (nella locazione successiva) disallineato di 1 byte
    # sw      t0, 1(t1)        #Salva t1 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 33: SW (Store Word) via AXI (nella locazione successiva) disallineato di 2 byte
    # sw      t0, 2(t1)        #Salva t2 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 34: SW (Store Word) via AXI (nella locazione successiva) disallineato di 3 byte
    # sw      t0, 3(t1)        #Salva t3 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 35: SH (Store Halfword) via AXI
    # sh      t0, 0(t1)        #Salva t0 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 36: SH (Store Halfword) via AXI (nella locazione successiva) disallineato di 1 byte
    # sh      t0, 1(t1)        #Salva t1 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 37: SH (Store Halfword) via AXI (nella locazione successiva) disallineato di 2 byte
    # sh      t0, 2(t1)        #Salva t2 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 38: SH (Store Halfword) via AXI (nella locazione successiva) disallineato di 3 byte
    # sh      t0, 3(t1)        #Salva t3 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 39: SB (Store Byte) via AXI
    # sb      t0, 0(t1)        #Salva t0 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 40: SB (Store Byte) via AXI (nella locazione successiva) disallineato di 1 byte
    # sb      t0, 1(t1)        #Salva t1 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 41: SB (Store Byte) via AXI (nella locazione successiva) disallineato di 2 byte
    # sb      t0, 2(t1)        #Salva t2 all'indirizzo AXI
    # addi    fp, fp, 4

    # # Test 42: SB (Store Byte) via AXI (nella locazione successiva) disallineato di 3 byte
    # sb      t0, 3(t1)        #Salva t3 all'indirizzo AXI
    # addi    fp, fp, 4

    # ############## LOAD ################
    # li      t1, 0x40000000   #Indirizzo AXI

    # # Test 43: LW (Load Word) via AXI
    # lw      t0, 0(t1)        #Carica il valore di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 44: LW (Load Word) via AXI (nella locazione successiva) disallineato di 1 byte
    # lw      t0, 1(t1)        #Carica il valore di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 45: LW (Load Word) via AXI (nella locazione successiva) disallineato di 2 byte
    # lw      t0, 2(t1)        #Carica il valore di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 46: LW (Load Word) via AXI (nella locazione successiva) disallineato di 3 byte
    # lw      t0, 3(t1)        #Carica il valore di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 47: LH (Load Halfword) via AXI
    # lh      t0, 0(t1)        #Carica il valore halfword di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 48: LH (Load Halfword) via AXI (nella locazione successiva) disallineato di 1 byte
    # lh      t0, 1(t1)        #Carica il valore halfword di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 49: LH (Load Halfword) via AXI (nella locazione successiva) disallineato di 2 byte
    # lh      t0, 2(t1)        #Carica il valore halfword di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 50: LH (Load Halfword) via AXI (nella locazione successiva) disallineato di 3 byte
    # lh      t0, 3(t1)        #Carica il valore halfword di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # addi    t1, t1, -16      #Ripristina lo stack pointer alla locazione dove ci sono le load halfword

    # # Test 51: LHU (Load Halfword Unsigned) via AXI
    # lhu     t0, 0(t1)        #Carica il valore halfword unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 52: LHU (Load Halfword Unsigned) via AXI (nella locazione successiva) disallineato di 1 byte
    # lhu     t0, 1(t1)        #Carica il valore halfword unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 53: LHU (Load Halfword Unsigned) via AXI (nella locazione successiva) disallineato di 2 byte
    # lhu     t0, 2(t1)        #Carica il valore halfword unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 54: LHU (Load Halfword Unsigned) via AXI (nella locazione successiva) disallineato di 3 byte
    # lhu     t0, 3(t1)        #Carica il valore halfword unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 55: LB (Load Byte) via AXI
    # lb      t0, 0(t1)        #Carica il valore byte di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 56: LB (Load Byte) via AXI (nella locazione successiva) disallineato di 1 byte
    # lb      t0, 1(t1)        #Carica il valore byte di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 57: LB (Load Byte) via AXI (nella locazione successiva) disallineato di 2 byte
    # lb      t0, 2(t1)        #Carica il valore byte di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 58: LB (Load Byte) via AXI (nella locazione successiva) disallineato di 3 byte
    # lb      t0, 3(t1)        #Carica il valore byte di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # addi    t1, t1, -16      #Ripristina lo stack pointer alla locazione dove ci sono le load byte

    # # Test 59: LBU (Load Byte Unsigned) via AXI
    # lbu     t0, 0(t1)        #Carica il valore byte unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 60: LBU (Load Byte Unsigned) via AXI (nella locazione successiva) disallineato di 1 byte
    # lbu     t0, 1(t1)        #Carica il valore byte unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 61: LBU (Load Byte Unsigned) via AXI (nella locazione successiva) disallineato di 2 byte
    # lbu     t0, 2(t1)        #Carica il valore byte unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4

    # # Test 62: LBU (Load Byte Unsigned) via AXI (nella locazione successiva) disallineato di 3 byte
    # lbu     t0, 3(t1)        #Carica il valore byte unsigned di AXI in t0
    # sw      t0, 0(fp)        #Salva il risultato in memoria
    # addi    t1, t1, 4
    # addi    fp, fp, 4
