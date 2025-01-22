.file	"test_JumpBranch.s"
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
    # Inizializza i registri di base
    li      t0, 0x40010000          # Puntatore all'area risultati
    li      t1, 1                   # Valore di successo da salvare in memoria

    # Test 1: JAL (Jump and Link)
    jal     ra, test_jal            # Salta a test_jal, salva il PC+4 in t2
    sw      t1, 0(t0)               # Scrive 1 in memoria (test passato)
    sw      ra, 0(sp)               # Salva il registro di ritorno (PC+4)

    # Test 2: JALR (Jump and Link Register)
    la      t3, test_jalr           # Carica l'indirizzo di test_jalr
    jalr    ra, 0(t3)               # Salta a test_jalr, salva il PC+4 in t4
    sw      t1, 4(t0)               # Scrive 1 in memoria (test passato)
    sw      ra, -4(sp)              # Salva il registro di ritorno (PC+4)

    # Test 3: BEQ (Branch if Equal)
    li      t2, 5
    li      t3, 5
    beq     t2, t3, branch_eq       # Salta se t2 == t3
    j       branch_done1            # Salta al termine del test
branch_eq:
    sw      t1, 8(t0)               # Scrive 1 in memoria (test passato)
branch_done1:

    # Test 4: BNE (Branch if Not Equal)
    li      t2, 5
    li      t3, 10
    bne     t2, t3, branch_ne       # Salta se t2 != t3
    j       branch_done2            # Salta al termine del test
branch_ne:
    sw      t1, 12(t0)              # Scrive 1 in memoria (test passato)
branch_done2:

    # Test 5: BLT (Branch if Less Than)
    li      t2, 5
    li      t3, 10
    blt     t2, t3, branch_lt       # Salta se t2 < t3
    j       branch_done3            # Salta al termine del test
branch_lt:
    sw      t1, 16(t0)              # Scrive 1 in memoria (test passato)
branch_done3:

    # Test 6: BGE (Branch if Greater or Equal)
    li      t2, 10
    li      t3, 5
    bge     t2, t3, branch_ge       # Salta se t2 >= t3
    j       branch_done4            # Salta al termine del test
branch_ge:
    sw      t1, 20(t0)              # Scrive 1 in memoria (test passato)
branch_done4:

    # Test 7: BLTU (Branch if Less Than Unsigned)
    li      t2, 0
    li      t3, -1                  # -1 è maggiore di 0 in unsigned
    bltu    t2, t3, branch_ltu      # Salta se t2 < t3 (unsigned)
    j       branch_done5            # Salta al termine del test
branch_ltu:
    sw      t1, 24(t0)              # Scrive 1 in memoria (test passato)
branch_done5:

    # Test 8: BGEU (Branch if Greater or Equal Unsigned)
    li      t2, -1                  # -1 è maggiore di 0 in unsigned
    li      t3, 0
    bgeu    t2, t3, branch_geu      # Salta se t2 >= t3 (unsigned)
    j       branch_done6            # Salta al termine del test
branch_geu:
    sw      t1, 28(t0)              # Scrive 1 in memoria (test passato)
branch_done6:

    # Fine del programma
    j       .                       # Codice di uscita


test_jal:
    ret                     # Ritorna

test_jalr:
    ret                     # Ritorna
