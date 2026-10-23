.file	"test_Memory.s"
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

    li      t0, 0x10B2ACF8   #Valore da scrivere in memoria
    li      fp, 0x40010000   #Base della RAM
    
    ############## STORE ################

    # Test 1: SW (Store Word)
    sw      t0, 0(fp)        #Salva t0 all'indirizzo di temp
    addi    fp, fp, 4        

    # Test 2: SW (Store Word) (nella locazione successiva) disallineato di 1 byte 
    sw      t0, 1(fp)        #Salva t1 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 3: SW (Store Word) (nella locazione successiva) disallineato di 2 byte
    sw      t0, 2(fp)        #Salva t2 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 4: SW (Store Word) (nella locazione successiva) disallineato di 3 byte
    sw      t0, 3(fp)        #Salva t3 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 5: SH (Store Halfword)
    sh      t0, 0(fp)        #Salva t0 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 6: SH (Store Halfword) (nella locazione successiva) disallineato di 1 byte
    sh      t0, 1(fp)        #Salva t1 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 7: SH (Store Halfword) (nella locazione successiva) disallineato di 2 byte
    sh      t0, 2(fp)        #Salva t2 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 8: SH (Store Halfword) (nella locazione successiva) disallineato di 3 byte
    sh      t0, 3(fp)        #Salva t3 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 9: SB (Store Byte)
    sb      t0, 0(fp)        #Salva t0 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 10: SB (Store Byte) (nella locazione successiva) disallineato di 1 byte
    sb      t0, 1(fp)        #Salva t1 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 11: SB (Store Byte) (nella locazione successiva) disallineato di 2 byte
    sb      t0, 2(fp)        #Salva t2 all'indirizzo di temp
    addi    fp, fp, 4

    # Test 12: SB (Store Byte) (nella locazione successiva) disallineato di 3 byte
    sb      t0, 3(fp)        #Salva t3 all'indirizzo di temp
    addi    fp, fp, 4

    ############## LOAD ################
    li      sp, 0x40010000   #Base della RAM

    # Test 13: LW (Load Word)
    lw      t0, 0(sp)        #Carica il valore di temp in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 14: LW (Load Word) (nella locazione successiva) disallineato di 1 byte
    lw      t0, 1(sp)        #Carica il valore di temp in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 15: LW (Load Word) (nella locazione successiva) disallineato di 2 byte
    lw      t0, 2(sp)        #Carica il valore di temp in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 16: LW (Load Word) (nella locazione successiva) disallineato di 3 byte
    lw      t0, 3(sp)        #Carica il valore di temp in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 17: LH (Load Halfword)
    lh      t0, 0(sp)        #Carica il valore halfword in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4   
    addi    sp, sp, 4

    # Test 18: LH (Load Halfword) (nella locazione successiva) disallineato di 1 byte
    lh      t0, 1(sp)        #Carica il valore halfword in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 19: LH (Load Halfword) (nella locazione successiva) disallineato di 2 byte
    lh      t0, 2(sp)        #Carica il valore halfword in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 20: LH (Load Halfword) (nella locazione successiva) disallineato di 3 byte
    lh      t0, 3(sp)        #Carica il valore halfword in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    addi    sp, sp, -16      #Ripristina lo stack pointer alla locazione dove ci sono le load halfword

    # Test 21: LHU (Load Halfword Unsigned)
    lhu     t0, 0(sp)        #Carica il valore halfword unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 22: LHU (Load Halfword Unsigned) (nella locazione successiva) disallineato di 1 byte
    lhu     t0, 1(sp)        #Carica il valore halfword unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 23: LHU (Load Halfword Unsigned) (nella locazione successiva) disallineato di 2 byte
    lhu     t0, 2(sp)        #Carica il valore halfword unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 24: LHU (Load Halfword Unsigned) (nella locazione successiva) disallineato di 3 byte
    lhu     t0, 3(sp)        #Carica il valore halfword unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 23: LB (Load Byte)
    lb      t0, 0(sp)        #Carica il valore byte in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 24: LB (Load Byte) (nella locazione successiva) disallineato di 1 byte
    lb      t0, 1(sp)        #Carica il valore byte in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 25: LB (Load Byte) (nella locazione successiva) disallineato di 2 byte
    lb      t0, 2(sp)        #Carica il valore byte in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 26: LB (Load Byte) (nella locazione successiva) disallineato di 3 byte
    lb      t0, 3(sp)        #Carica il valore byte in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    addi    sp, sp, -16      #Ripristina lo stack pointer alla locazione dove ci sono le load byte

    # Test 27: LBU (Load Byte Unsigned)
    lbu     t0, 0(sp)        #Carica il valore byte unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 28: LBU (Load Byte Unsigned) (nella locazione successiva) disallineato di 1 byte
    lbu     t0, 1(sp)        #Carica il valore byte unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 29: LBU (Load Byte Unsigned) (nella locazione successiva) disallineato di 2 byte
    lbu     t0, 2(sp)        #Carica il valore byte unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    # Test 30: LBU (Load Byte Unsigned) (nella locazione successiva) disallineato di 3 byte
    lbu     t0, 3(sp)        #Carica il valore byte unsigned in t0
    sw      t0, 0(fp)        #Salva il risultato in memoria
    addi    fp, fp, 4
    addi    sp, sp, 4

    j       .                #Fine del programma    
