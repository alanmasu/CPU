.file	"test_ALU.s"
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
    # Base address per i risultati
    li t0, 0x40010000

    # Test LUI
    lui t1, 0x12345       # Carica 0x12345000 in t1
    sw t1, 0(t0)          # Salva il risultato in memoria

    # Test AUIPC
    auipc t1, 0x1         # Carica PC corrente + 0x1000 in t1
    sw t1, 4(t0)          # Salva il risultato in memoria

    # Test ADDI
    li t1, 5              # Carica il valore 5 in t1
    addi t1, t1, 10       # Aggiunge 10 a t1
    sw t1, 8(t0)          # Salva il risultato in memoria

    # Test SLTI
    li t1, 5
    slti t1, t1, 10       # Imposta t1 a 1 se 5 < 10
    sw t1, 12(t0)         # Salva il risultato in memoria

    # Test SLTIU
    li t1, -1
    sltiu t1, t1, 10      # Imposta t1 a 0 (valore unsigned -1 non < 10)
    sw t1, 16(t0)         # Salva il risultato in memoria

    # Test XORI
    li t1, 0b1010         # Carica 0b1010 in t1
    xori t1, t1, 0b1100   # XOR con 0b1100
    sw t1, 20(t0)         # Salva il risultato in memoria

    # Test ORI
    li t1, 0b1010
    ori t1, t1, 0b0101    # OR con 0b0101
    sw t1, 24(t0)         # Salva il risultato in memoria

    # Test ANDI
    li t1, 0b1010
    andi t1, t1, 0b1100   # AND con 0b1100
    sw t1, 28(t0)         # Salva il risultato in memoria

    # Test SLLI
    li t1, 1
    slli t1, t1, 3        # Shift a sinistra di 3
    sw t1, 32(t0)         # Salva il risultato in memoria

    # Test SRLI
    li t1, 0b1000
    srli t1, t1, 3        # Shift a destra logico di 3
    sw t1, 36(t0)         # Salva il risultato in memoria

    # Test SRAI
    li t1, -8             # Carica un valore negativo
    srai t1, t1, 2        # Shift a destra aritmetico di 2
    sw t1, 40(t0)         # Salva il risultato in memoria

    # Test ADD
    li t1, 5
    li t2, 10
    add t1, t1, t2        # Somma t1 e t2
    sw t1, 44(t0)         # Salva il risultato in memoria

    # Test SUB
    li t1, 15
    li t2, 10
    sub t1, t1, t2        # Sottrai t2 da t1
    sw t1, 48(t0)         # Salva il risultato in memoria

    # Test SLL
    li t1, 1
    li t2, 3
    sll t1, t1, t2        # Shift a sinistra di 3
    sw t1, 52(t0)         # Salva il risultato in memoria

    # Test SLT
    li t1, 5
    li t2, 10
    slt t1, t1, t2        # Imposta t1 a 1 se t1 < t2
    sw t1, 56(t0)         # Salva il risultato in memoria

    # Test SLTU
    li t1, -1
    li t2, 10
    sltu t1, t1, t2       # Imposta t1 a 0 (valore unsigned -1 non < 10)
    sw t1, 60(t0)         # Salva il risultato in memoria

    # Test XOR
    li t1, 0b1010
    li t2, 0b1100
    xor t1, t1, t2        # XOR tra t1 e t2
    sw t1, 64(t0)         # Salva il risultato in memoria

    # Test OR
    li t1, 0b1010
    li t2, 0b0101
    or t1, t1, t2         # OR tra t1 e t2
    sw t1, 68(t0)         # Salva il risultato in memoria

    # Test AND
    li t1, 0b1010
    li t2, 0b1100
    and t1, t1, t2        # AND tra t1 e t2
    sw t1, 72(t0)         # Salva il risultato in memoria

    # Test SRL
    li t1, 0b1000
    li t2, 3
    srl t1, t1, t2        # Shift a destra logico di 3
    sw t1, 76(t0)         # Salva il risultato in memoria

    # Test SRA
    li t1, -8             # Carica un valore negativo
    li t2, 2
    sra t1, t1, t2        # Shift a destra aritmetico di 2
    sw t1, 80(t0)         # Salva il risultato in memoria

    # Fine del programma
    j .
