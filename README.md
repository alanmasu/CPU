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

Configurazione BRAM 
  * Single port ram, 32x2048
  * Byte accessing -> wea[2:0],
  * Pin ENA per abilitazione (gestito dalla MSF)
  * Primitives Output Register disabilitato

Note:
   - Nel caso di una Jump è il comparator (dello stadio precedente) a mettere ad '1' il segnale 'cond'.
 

---

# TO DO LIST
 ## Instuction fetch 
- [x] Cambiare il PC in contatore a 12 bit;
- [x] Portare fuori il contatore
- [x] Cambiare la memoria istruzioni in BRAM
- [ ] Provare a vedere come influisci il pc_enable e il registro dell'istruzione
- [ ] Inserire il controller AXI per la BRAM e creare la modalità programmazione

## Instruction decode
- [x] Modificare il sign-extender
  - [x] Da testare 
- [ ] Aggiungere un 'load_enable' al register file
  - [ ] Testare il file register
- [x] Creare il decoder
- [ ] Aggiungere il load_enable

## Execute 
- [x] Inserire i multiplaxer

## Memoria & Write back
- [x] Da Testare
- [ ] Provare a simulare il comportamento della RAM nel caso in cui l'indirizzo arrivi in un ciclo di clock, mentre il dato arrivi al fronte successivo!
- [x] Probabilmente bisogna togliere i registri in uscita per PC, per i dati; va verificato
- [ ] Indirizzamento a BYTE

## Macchina a stati di controllo
**Test flow**
- [x] Operazioni con immediati
- [x] Load
- [x] Store
- [x] Brench
- [x] Jump
- [x] LUI
- [x] AUIPC

