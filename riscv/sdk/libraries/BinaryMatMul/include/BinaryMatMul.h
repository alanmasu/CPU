/*!
    @file       BinaryMatMul.h
    @brief      Header file for the BinaryMatMul library.
    @details    This file contains the structures and function prototypes for the BinaryMatMul library.
                The library is designed to perform binary matrix multiplication and will be optimized
                for the specific hardware architecture.

    @author     Alan Masutti  (@alanmasu)
    @date       14/05/2025
*/

#ifndef __BINARY_MATMUL_H__
#define __BINARY_MATMUL_H__

/*
    Profiling switches, off by default, to be defined on the compiler command line (-D):
    - BTPU_SKIP_MATH: fastBinaryBlockMatrixMul() runs its loops but skips the computation;
    - BTPU_SKIP_TRANSPOSE: fastBinaryMatrixMul() skips the transposition of the fragments.
    The timings of the variants isolate the cost of each part.
*/

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

#define BINARY_FRAG_SIZE 32

#define       BTPU_CREG_BASE 0x40020030
#define   BTPU_W_MEMORY_BASE 0x40080000
#define BTPU_IO0_MEMORY_BASE 0x400A0000
#define BTPU_IO1_MEMORY_BASE 0x400C0000

#define BTPU_START_BIT_MASK          (1 << 0)
#define BTPU_BYSY_BIT_MASK           (1 << 1)
#define BTPU_OMEM_SEL_BIT_MASK       (1 << 2)
#define BTPU_BRAM_PORT_SEL_BIT_MASK  (1 << 3)
#define BTPU_ACC_CLEAR_BIT_MASK      (1 << 4)
#define BTPU_BATCHED_MUL_BIT_MASK    (1 << 5)
#define BTPU_ERROR_BIT_MASK          (1 << 6)

#define BTPU_USE_MEMORY_0_CONFIG 1 //< Seleziona IO1_MEMORY come memoria di output e IO0_MEMORY come memoria di input
#define BTPU_USE_MEMORY_1_CONFIG 0 //< Seleziona IO0_MEMORY come memoria di output e IO1_MEMORY come memoria di input

#define BTPU_BRAM_PORT_SEL_INT   0 ///< Seleziona la porta del RISC-V 
#define BTPU_BRAM_PORT_SEL_EXT   1 ///< Seleziona IO0_MEMORY come porta del RISC-V

#define BTPU_MAX_BLOCK_COUNT 1024  ///< Maximum number of blocks for matrix multiplication

typedef struct BTPUCRegField_t {
    unsigned START : 1;          ///< Bit 0: Start bit
    unsigned BUSY : 1;           ///< Bit 1: Busy bit
    unsigned OMEM_SEL : 1;       ///< Bit 2: Output memory selection (0: IO0_MEMORY, 1: IO1_MEMORY)
    unsigned BRAM_PORT_SEL : 1;  ///< Bit 3: BRAM port selection (0: INTERNAL, 1: EXTERNAL)
    unsigned ACC_CLEAR : 1;      ///< Bit 4: Accumulator clear bit
    unsigned BATCHED_MUL : 1;    ///< Bit 5: Batched multiplication bit
    unsigned ERROR : 1;          ///< Bit 6: Error bit
    unsigned reserved : 25;      ///< Bit 7-31: Reserved bits
}BTPUCRegField_t;

typedef union BTPUCReg_t{
    volatile uint32_t value;        ///< Raw value of the control register
    volatile BTPUCRegField_t reg;   ///< Bit fields of the control register
}BTPUCReg_t;

typedef struct BTPURegFile_t {
    volatile BTPUCReg_t creg;           ///< Control register
    volatile uint32_t   wMemStartAddr;  ///< Start address of the W memory
    volatile uint32_t   iMemStartAddr;  ///< Start address of the I memory
    volatile uint32_t   oMemStartAddr;  ///< Start address of the O memory
    volatile uint32_t   mSize;          ///< Size of the matrix (in blocks)
    volatile uint32_t   nSize;          ///< Number of columns of the matrix (in blocks)
    volatile uint32_t   kSize;          ///< Number of rows of the matrix (in blocks)
    volatile uint32_t   statusReg;      ///< Status register
    volatile uint32_t   signCmp;        ///< Sign comparison value for binarization
} BTPURegFile_t;

extern BTPURegFile_t* BTPU0RegFile;

typedef uint32_t  BinaryFragment_t[BINARY_FRAG_SIZE];
typedef uint32_t* BinaryMatrix_t;
typedef uint32_t* Matrix_t;

typedef uint32_t  BinaryAcc_t[BINARY_FRAG_SIZE][BINARY_FRAG_SIZE];

typedef void(*BTPUCallBackFunct_t)(void);

extern BinaryFragment_t*   BTPU0_W_MEMORY;
extern BinaryFragment_t* BTPU0_IO0_MEMORY;
extern BinaryFragment_t* BTPU0_IO1_MEMORY;

/// Legge un bit da una matrice binaria bit-packed
uint8_t getBit(const BinaryMatrix_t mat, uint32_t row, uint32_t col, uint32_t N);

/*!
    @brief Scrive un bit in una matrice binaria bit-packed
    @param mat La matrice binaria
    @param row La riga in cui scrivere il bit
    @param col La colonna in cui scrivere il bit
    @param value Il valore del bit da scrivere (0 o 1)
    @param N Il numero di colonne della matrice binaria (in bit)
*/
void setBit(BinaryMatrix_t mat, uint32_t row, uint32_t col, uint8_t value, uint32_t N);

/*!
    @brief  Traspone una matrice binaria (da row-major a col-major)
    @details Prende in ingresso una matrice binaria di dimensioni M x N (bit) e restituisce la sua trasposizione.
    @param[in]  input La matrice binaria di input
    @param[out] output La matrice binaria di output (trasposta)
    @param      M Numero di righe della matrice di input (in bit)
    @param      N Numero di colonne della matrice di input (in bit)
*/
void transposeBinaryMatrix(const BinaryMatrix_t input, BinaryMatrix_t output, const uint32_t M, const uint32_t N);

/// Traspone un frammentp binario (da row-major a col-major)
void transposeBinaryFragment(BinaryFragment_t input, BinaryFragment_t output);

/// Calcola il numero di bit settati in una parola binaria
int popcount32(uint32_t x);

/// Esegue lo XNOR bitwise su due parole a 32 bit
uint32_t xnor32(const uint32_t a, const uint32_t b);

/*!
    @brief  Moltiplica due parole binarie
    @details Prende in ingresso due parole binarie di 32 bit e restituisce il risultato della moltiplicazione
             come il numero di bit uguali tra le due parole.
    @param[in]  a La parola binaria A
    @param[in]  b La parola binaria B
    @return     Il numero di bit uguali tra le due parole
*/
uint32_t binaryMul(const uint32_t a, const uint32_t b);


/*!
    @brief  Moltiplica due frammenti di matrice binaria
    @details Prende in ingresso due frammenti di matrice binaria di dimensioni BINARY_FRAG_SIZE x BINARY_FRAG_SIZE
             e restituisce il risultato della moltiplicazione in un accumulatore.
    @param[in]  a Il frammento A
    @param[in]  b Il frammento B (trasposto)
    @param[out] acc L'accumulatore in cui memorizzare il risultato
*/
void binaryBlockMatrixMul(const BinaryFragment_t a, const BinaryFragment_t b, BinaryAcc_t acc);

/*!
    @brief  Moltiplica due frammenti di matrice binaria applicando il segno
    @details Prende in ingresso due frammenti di matrice binaria di dimensioni BINARY_FRAG_SIZE x BINARY_FRAG_SIZE
             e restituisce il risultato della moltiplicazione in un accumulatore, ne calola il segno confrontando il
             risultato con un valore di confronto specificato.
    @param[in]  a Il frammento A
    @param[in]  b Il frammento B (trasposto)
    @param[out] acc L'accumulatore in cui memorizzare il risultato
    @param[out] c Il frammento in cui memorizzare il risultato finale
    @param      signCmp Il valore di confronto per il segno
    @param      store Se true, binarizza il risultato e lo memorizza in c
*/
void fastBinaryBlockMatrixMul(const BinaryFragment_t a, const BinaryFragment_t b, BinaryAcc_t acc, BinaryFragment_t c, uint32_t signCmp, bool store);

/*!
    @brief  Carica un blocco di matrice binaria in un frammento
    @details Prende in ingresso una matrice binaria, allocata in RAM, e carica un frammento allocato in RAM
             con i dati del blocco specificato.
    @param[out] frag Il frammento in cui caricare i dati
    @param[in]  mat La matrice binaria da cui caricare i dati
    @param      blockRow L'indice di riga del blocco
    @param      blockCol L'indice di colonna del blocco
    @param      n Numero di colonne (in bit) della matrice binaria

*/
void loadFragment(BinaryFragment_t frag, const BinaryMatrix_t mat, uint32_t blockRow, uint32_t blockCol, uint32_t n);

/*!
    @brief  Memorizza un frammento in una matrice binaria
    @details Prende in ingresso un frammento di matrice binaria e lo memorizza nella matrice binaria, 
             allocata in RAM, specificata nel blocco specificato.
    @param frag Il frammento da memorizzare
    @param mat La matrice binaria in cui memorizzare i dati
    @param blockRow L'indice di riga del blocco
    @param blockCol L'indice di colonna del blocco
    @param n Numero di colonne (in bit) della matrice binaria

*/
void storeFragment(const BinaryFragment_t frag, BinaryMatrix_t mat, uint32_t blockRow, uint32_t blockCol, uint32_t n);

/*!
    @brief  Memorizza un accumulatore in una matrice
    @details Prende in ingresso un accumulatore di dimensioni BINARY_FRAG_SIZE x BINARY_FRAG_SIZE
             e lo memorizza nella matrice, allocata in RAM, specificata nel blocco specificato.
    @param acc L'accumulatore da memorizzare
    @param mat La matrice in cui memorizzare i dati
    @param blockRow L'indice di riga del blocco
    @param blockCol L'indice di colonna del blocco
    @param n Numero di colonne della matrice
*/
void storeAcc(const BinaryAcc_t acc, Matrix_t mat, uint32_t blockRow, uint32_t blockCol, uint32_t n);

/*!
    @brief  Inizializza un accumulatore a zero
    @param acc L'accumulatore da inizializzare

*/
void fillAccWithZero(BinaryAcc_t acc);

/*!
    @brief      Moltiplica due matrici binarie
    @details    Prende in ingresso due matrici binarie di dimensioni M x N e N x K
                e restituisce il risultato della moltiplicazione in una matrice di dimensioni m x k.
                La moltiplicazione viene eseguita in blocchi di dimensione BINARY_FRAG_SIZE x BINARY_FRAG_SIZE.
    @param[in]  a La matrice binaria A
    @param[in]  b La matrice binaria B
    @param[out] result La matrice risultante
    @param      m Numero di righe della matrice A
    @param      n Numero di colonne della matrice A e righe della matrice B
    @param      k Numero di colonne della matrice B
*/
void binaryMatrixMul(const BinaryMatrix_t a, const BinaryMatrix_t b, Matrix_t result, const int m, const int n, const int k);

/*!
    @brief  Moltiplica due matrici binarie applicando il segno
    @details Prende in ingresso due matrici binarie di dimensioni M x N e N x K
             e restituisce il risultato della moltiplicazione in una matrice di dimensioni m x k,
             calcolando il segno confrontando il risultato con un valore di confronto specificato.
    @param[in]  a La matrice binaria A
    @param[in]  b La matrice binaria B
    @param[out] c La matrice risultante
    @param      signCmp Il valore di confronto per il segno
    @param      m Numero di righe della matrice A (in bit)
    @param      n Numero di colonne della matrice A e righe della matrice B (in bit)
    @param      k Numero di colonne della matrice B (in bit)
*/
void fastBinaryMatrixMul(const BinaryMatrix_t a, const BinaryMatrix_t b, BinaryMatrix_t c, uint32_t signCmp, const int m, const int n, const int k);

/*!
    @brief  Converte una matrice in una matrice binaria

    @param[in]  mat La matrice da convertire
    @param[out] bMat La matrice binaria risultante
    @param      signCmp Il valore di confronto per la binarizzazione
    @param      m Numero di righe della matrice (in bit)
    @param      n Numero di colonne della matrice (in bit)
*/
void binarizeMatrix(Matrix_t mat, BinaryMatrix_t bMat, uint32_t signCmp, uint32_t m, uint32_t n);

/*!
    @brief  Stampa una matrice binaria come interi

    @param mat La matrice binaria da stampare
    @param r Numero di righe da stampare
    @param c Numero di colonne da stampare
    @param M Numero di righe della matrice (in bit)
    @param N Numero di colonne della matrice (in bit)
*/
void printIntBMatrixN(BinaryMatrix_t mat, uint32_t r, uint32_t c, const uint32_t M, const uint32_t N);

/*!
    @brief  Stampa una matrice binaria

    @param mat La matrice binaria da stampare
    @param r Numero di righe da stampare
    @param c Numero di colonne da stampare
    @param M Numero di righe della matrice (in bit)
    @param N Numero di colonne della matrice (in bit)

*/
void printBMatrixN(BinaryMatrix_t mat, uint32_t r, uint32_t c, const uint32_t M, const uint32_t N);

/*!
    @brief  Stampa un frammento binario come interi

    @param frag Il frammento da stampare
    @param rows Numero di righe da stampare
*/
void printIntFragmentN(BinaryFragment_t frag, uint32_t rows);

/*!
    @brief  Stampa una matrice

    @param mat La matrice da stampare
    @param r Numero di righe da stampare
    @param c Numero di colonne da stampare
    @param M Numero di righe della matrice
    @param N Numero di colonne della matrice
*/
void printIntMatrixN(Matrix_t mat, uint32_t r, uint32_t c, const uint32_t M, const uint32_t N);


/*!
    @brief      Carica una matrice binaria in frammenti binari contigui
    @details    Prende in ingresso una matrice binaria di dimensioni M x N (in bit) e la carica 
                 in frammenti binari contigui di dimensioni BINARY_FRAG_SIZE x BINARY_FRAG_SIZE.
                 Utile per caricare una matrice binaria in BTPU.
    @param[in]  mat La matrice binaria da caricare
    @param[in]  dest L'indirizzo di destinazione in cui caricare la matrice
    @param      M Numero di righe della matrice (in bit)
    @param      N Numero di colonne della matrice (in bit)

    @note       dest deve essere allocato come un array di frammenti binari di dimensioni M x (N/32).
*/
void loadBinaryMatrixToFragments(const BinaryMatrix_t mat, BinaryFragment_t dest[], const uint32_t M, const uint32_t N);

/*!
    @brief      Memorizza frammenti binari in una matrice binaria
    @details    Prende in ingresso un array di frammenti binari e li memorizza in una matrice binaria di dimensioni M x N (in bit).
                Utile per memorizzare i risultati della moltiplicazione in BTPU.
    @param[in]  src L'array di frammenti binari da memorizzare
    @param[out] mat La matrice binaria in cui memorizzare i dati
    @param      M Numero di righe della matrice (in bit)
    @param      N Numero di colonne della matrice (in bit)

    @note       mat deve essere allocata come un array di uint32_t di dimensioni M x (N/32).    
*/
void storeFramentsToBinaryMatrix(const BinaryFragment_t src[], BinaryMatrix_t mat, const uint32_t M, const uint32_t N);

/*!
    @brief  Inizializza i registri della BTPU per la moltiplicazione di matrici binarie settando le dimensioni
    @details Impostando i registri di controllo delle dimensioni delle matrici.
    @param inst Puntatore alla struttura dei registri della BTPU
    @param m Numero di righe della matrice A (in blocchi)
    @param n Numero di colonne della matrice A e righe della matrice B (in blocchi)
    @param k Numero di colonne della matrice B (in blocchi)
*/
void btpuSetBlocks(BTPURegFile_t* inst, const uint32_t m, const uint32_t n, const uint32_t k);

/*!
    @brief  Inizializza i registri della BTPU per la moltiplicazione di matrici binarie settando gli indirizzi dei registri
    @details Imposta gli indirizzi di memoria per le matrici W, I e O nella BTPU.
    @param inst Puntatore alla struttura dei registri della BTPU
    @param wMemStartAddr Indirizzo di partenza della memoria W (in blocchi)
    @param iMemStartAddr Indirizzo di partenza della memoria I (in blocchi)
    @param oMemStartAddr Indirizzo di partenza della memoria O (in blocchi)
*/
void btpuSetAddrs(BTPURegFile_t* inst, const uint32_t wMemStartAddr, const uint32_t iMemStartAddr, const uint32_t oMemStartAddr);

/*!
    @brief  Avvia la moltiplicazione di matrici binarie nel BTPU
    @details Avvia la moltiplicazione di matrici binarie nel BTPU, impostando i registri di controllo e avviando l'operazione.
    @return true se l'operazione è stata avviata correttamente, false altrimenti
*/
bool btpuStartBinaryMatrixMul(BTPURegFile_t* inst, const uint32_t signCmp, bool isBatched, bool clearAcc, uint8_t outputMemorySelect);

/*!
    @brief  Attende il completamento della moltiplicazione di matrici binarie nel BTPU
    @details Attende il completamento della moltiplicazione di matrici binarie nel BTPU, controllando lo stato del registro di controllo.
    @return Quando la moltiplicazione è completata, la funzione termina restituendo true se non ci sono stati errori, false altrimenti.
*/
bool btpuWaitBinaryMatrixMul(BTPURegFile_t* inst);

/*!
    @brief  Attende il completamento della moltiplicazione di matrici binarie nel BTPU con callback
    @details Durante l'attesa, la funzione esegue la funzione di callback specificata.
    @return true se l'operazione è stata completata correttamente, false altrimenti
*/
bool btpuWaitBinaryMatrixMulWithCb(BTPURegFile_t* inst, BTPUCallBackFunct_t funct);

#endif // __BINARY_MATMUL_H__
