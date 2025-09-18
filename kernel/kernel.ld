ENTRY(_entry)

SECTIONS
{
    . = 0x80000000;

    .text : {
        *(.text .text.*)
        PROVIDE(etext = .); 
    }
    
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

    . = . + 4096; /* 4 KB stack */
    PROVIDE(stacktop = .);
}