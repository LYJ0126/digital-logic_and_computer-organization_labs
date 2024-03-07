ENTRY(entry)
OUTPUT_FORMAT("elf32-littleriscv")

SECTIONS {
	. = 0x00000000;
	.text : {
		*(entry)
		main.o (.text)
		*(.text*)
		*(text_end)
	}
	etext = .;
	_etext = .;
	. = 0x00100000;
    .rodata : {
		*(.rodata*)
	}
	.data : {
		*(.data)
	}
	edata = .;
	_data = .;
	.bss : {
	_bss_start = .;
		*(.bss*)
		*(.sbss*)
		*(.scommon)
	}
	_stack_top = ALIGN(1024);
	. = _stack_top + 1024;
	_stack_pointer = .;
	end = .;
	_end = .;
	_heap_start = ALIGN(1024);
}
