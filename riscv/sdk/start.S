// Start-up code: the first instructions the core executes after reset.
//
// The core starts at 0x40000000, where linker_script.ld places the .init
// section, before any other code. _init sets the global pointer and the stack
// from the symbols of the linker script, then calls main with two arguments
// read from the first two words of the data memory, which the loader on the
// Zynq writes before starting the core: a0 is the heap size, a1 the heap
// address.
//
// The program is linked with -e main, so the ELF entry point is main, not
// _init: a loader must not use e_entry to find the start-up code.

    .section .init, "ax"
    .globl _init
_init:
    // Without relaxation, so the linker does not turn "la gp" into an
    // address relative to gp itself, which is not set yet
    .option norelax
    la      gp, __global_pointer$
    la      sp, __stack_start
    li      t0, 0x40010000
    lw      a0, 0(t0)
    lw      a1, 4(t0)
    call    main
