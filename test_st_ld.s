li sp, 0x7FF
li x1, 1000
li x3, 2000         /*FINO QUA TUTTO OK                     */
addi sp, sp, -4     /* alloco spazio per un intero          */
sw x1, 0(sp)        /* mem[sp] = x1 => mem[sp] = 1000       */
sw x3, 4(sp)        /* mem[sp - 4] = x3 => mem[sp] = 2000   */
lw x4, 0(sp)        /* x4 = mem[sp] => x4 = x1 => x4 = 1000 */
lw x5, 4(sp)        /* x5 = mem[sp - 4] => x5 = x3 => x5 = 2000 */