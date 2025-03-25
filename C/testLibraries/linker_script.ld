  __heap_size   = 0x200;  /* required amount of heap */
  __stack_size  = 0x800;  /* required amount of stack */

MEMORY
{
	INSTR(RX) : ORIGIN = 0x40000000, LENGTH = 4096 
	RAM(RWX) : ORIGIN = 0x40010000, LENGTH = 8192
}

SECTIONS
{
	. = 0x40000000;
	. = ALIGN(4);
	.text : {
		*(.init)
		*(.text.main)
		*(.text*)
		. = ALIGN(4);
		_etext = .;		
	} > INSTR 

	.entry : {
		. = . + 12;
		. = ALIGN(4);
	} > RAM

	.const : {
		*(.rodata*)
		*(.const*)
		. = ALIGN(4);
		_econst = .;
	} > RAM

	.bss (NOLOAD): {
		_sbss = .;
		__bss_start = .;
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
	} > RAM

	.data : {
		_sdata = .;
		*(.data*)
		*(.sdata*)
		. = ALIGN(4);
		PROVIDE( __global_pointer$ = .);
		_edata = .;
	} > RAM
	

	.heap :
    {
      . = ALIGN(4);
	  _end = .;
      _sheap = .;
      . = . + __heap_size;
      . = ALIGN(4);
      _eheap = .;
    } >RAM

	.stack :
    {
      . = ALIGN(4);
      _estack = .;
      . = . + __stack_size;
      . = ALIGN(4);
      _sstack = .;
	  PROVIDE(_sp = . );
    } > RAM
}
