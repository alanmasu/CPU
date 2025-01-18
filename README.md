# CPU

Costruzione di una CPU basata su RISC-V in VHDL divisa in 5 stadi:

---
## Instruction Fetch
Esce con l'istruzione a 32 bit, il program counter (pc) e il prossimo valore del program counter (npc) indirizzato a BYTE, dentro contiene una BRAM 32 x 1024 (32Kb) utilizzata come memoria istruzioni.

Configurazione BRAM:
  * Single port ram,
  * No byte accessing,
  * Pin ENA per abilitazione (collegato a 'pc_load')
  * Primitives Output Register disabilitato
---
## Instruction Decode
Decodifica l'istruzione dai 32bit alla control word (segnali di selezione degli operandi, valori dei registri, immediato) che serve allo stadio successivo per eseguire l'operazione, estende in segno l'immediato, contiene il Register File.

---
## Execute
Contiene la ALU ed il Comparatore, legge la control word ed esegue effettivamente i calcoli necessari ad eseguire l'istruzione (calcoli aritmetici [op], calcoli di indirizzi di memoria [L & S] o calcoli sul prossimo valore di PC [B & J]) inoltre il comparatore calcola l'eventuale condizione per eseguire i salti tra istruzioni

---
## Memory & Write back
Contiene la RAM ed il circuito di selezione del prossimo valore di PC.
Permette l'indirizzamento a BYTE

> **Attenzione**: l'accesso non allineato in memoria non è pienamente supportato per il momento, questo potrebbe comportare ad errori nel calcolo!

Configurazione BRAM 
  * Single port ram, 32x2048
  * Byte accessing -> wea[2:0],
  * Pin ENA per abilitazione (gestito dalla MSF)
  * Primitives Output Register disabilitato

Note:
   - Nel caso di una Jump è il comparator (dello stadio precedente) a mettere ad '1' il segnale 'cond'.
 
## Struttura della Repository

```
.
├── assembly
│   ├── bin
│   │   └── <here are placed all free Assembly Files binaries>
│   └── <here are placed all free Assembly Files>
├── C
│   ├── <Project Name>
│   │   ├── bin [GIT UNTRACKED]
│   │   │   └── <here are placed Project Binaries>
│   │   ├── src
│   │   │   └── <here are placed Project Sources>
│   │   ├── linker_script.ld
│   │   └── Makefile
│   └── <Here are placed all C/Assembly Project folders>
├── coe
│   └── <here are placed all free coe files>
├── hex
│   └── <here are placed all free hex files>
├── packages
│   └── <here are placed HDL packages>
├── scripts
│   └── <here are placed all utility scripts>
├── simulation
│   └── <here are placed all simulation files>
├── src
│   └── <here are placed all HDL sources>
├── testbench
│   └── <here are placed all testbench files>
└── README.md [This file]
```

---

# RISC-V toolchain 
## Installazione 
1) Seguire le informazioni di installazione dei prerequisiti presenti nel repository [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)
2) Eseguire lo script fornito nel repository per la compilazione del toolchain con il comando 
```bash
./configure --prefix=<Your Compilation Paht> --with-arch=rv32i --with-abi=ilp32
```
3) Eseguire il comando
```bash
make 
```
per la compilazione del toolchain

4) Aggiungere la variabile d'ambiente `PATH` al file `.bashrc` con il comando 
```bash
export PATH=$PATH:<Your Compilation Path>/bin`
```

## Utilizzo
Per compilare un file sorgente in assembly RISC-V è sufficiente eseguire il comando 
```bash
riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -ffreestanding
```

## Compilare Progetti C/Assembly della repository
Nei progetti C/assembly presenti in questa repository nella directory `./C` è presente un Makefile che permette di compilare il progetto con il comando 
```bash
make
```


# TO DO LIST
 ## Instuction fetch 
- [x] Cambiare il PC in contatore a 12 bit;
- [x] Portare fuori il contatore
- [x] Cambiare la memoria istruzioni in BRAM
- [ ] Provare a vedere come influisce il pc_enable e il registro dell'istruzione
- [x] Inserire il controller AXI per la BRAM e creare la modalità programmazione

## Instruction decode
- [x] Modificare il sign-extender
  - [x] Da testare 
- [x] Aggiungere un 'load_enable' al register file
  - [x] Testare il file register
- [x] Creare il decoder
- [ ] Aggiungere il load_enable

## Execute 
- [x] Inserire i multiplaxer

## Memoria & Write back
- [x] Da Testare
- [ ] Provare a simulare il comportamento della RAM nel caso in cui l'indirizzo arrivi in un ciclo di clock, mentre il dato arrivi al fronte successivo!
- [x] Probabilmente bisogna togliere i registri in uscita per PC, per i dati; va verificato
- [x] Indirizzamento a BYTE
- [ ] Unaligned memory access

## Macchina a stati di controllo
**Test flow**
- [x] Operazioni con immediati
- [x] Load
- [x] Store
- [x] Brench
- [x] Jump
- [x] LUI
- [x] AUIPC
- [ ] Provare a togliere 'ena' al MEM&WB nello stato di 'mem_wb' per sistemare le load riflessive tipo `lw x1, 0(x1)`
