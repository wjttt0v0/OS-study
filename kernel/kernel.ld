OUTPUT_ARCH("riscv")
ENTRY(_entry)

SECTIONS
{
    . = 0x80000000;

    .text : {
        KEEP(*(.text._entry))
        *(.text .text.*)
    }
    
    PROVIDE(etext = .);

    .rodata : {
        . = ALIGN(16);
        *(.rodata .rodata.*)
    }

    .data : {
        . = ALIGN(16);
        *(.data .data.*)
    }

    .bss : {
        . = ALIGN(16);
        PROVIDE(sbss = .);
        *(.bss .bss.*)
        *(.sbss .sbss.*) 
        . = ALIGN(16);
        PROVIDE(ebss = .);
    }

    PROVIDE(end = .);
}