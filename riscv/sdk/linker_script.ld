MEMORY
{
	INSTR(RX) : ORIGIN = 0x40000000, LENGTH = 16384
	RAM(RWX) : ORIGIN = 0x40010000, LENGTH = 65536
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
		__text_end = .;		
	} > INSTR 

	.entry : {
		__entry_start = .;
		. = . + 8;
		. = ALIGN(4);
	} > RAM

	.const : {
		__const_start = .;
		*(.rodata*)
		*(.srodata*)
		*(.const*)
		. = ALIGN(4);
		__const_end = .;
	} > RAM

	.data : {
		__data_start = .;
		*(.data*)
		*(.sdata*)
		. = ALIGN(4);
		__data_end = .;
	} > RAM

	.bss (NOLOAD): {
		__bss_start = .;
		*(.bss*)
		*(.sbss*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end = .;
	} > RAM
	
	PROVIDE(__global_pointer$ = __data_start + ((__bss_end - __data_start) / 2));
	
	PROVIDE(_end  = .); 
	PROVIDE(__heap_start = _end);
	PROVIDE(__stack_start = ORIGIN(RAM) + LENGTH(RAM));
}
