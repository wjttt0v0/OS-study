ENTRY(_entry)

SECTIONS
{
    /* Start execution at the QEMU default address for the virt machine */
    . = 0x80000000;

    /* Code section (.text) */
    .text : {
        *(.text .text.*)
        PROVIDE(etext = .); 
    }
    
    /* Read-only data section (.rodata) */
    .rodata : {
        . = ALIGN(16);
        *(.rodata .rodata.*)
    }

    /* Initialized data section (.data) */
    .data : {
        . = ALIGN(16);
        *(.data .data.*)
    }

    /*
     * Uninitialized data section (.bss).
     * The linker script provides the start (sbss) and end (ebss) symbols
     * so our startup code can zero this memory region.
     */
    .bss : {
        . = ALIGN(16);
        PROVIDE(sbss = .);
        *(.bss .bss.*)
        *(.sbss .sbss.*) /* Also collect small bss sections */
        . = ALIGN(16);
        PROVIDE(ebss = .);
    }

    /* A symbol for the end of all kernel data */
    PROVIDE(end = .);

    /*
     * Define the stack region at the end.
     * We allocate a 16KB stack. The stack grows downwards,
     * so we set the stack pointer to the top of this region.
     */
    . = . + 4096 * 4; /* 16 KB stack */
    PROVIDE(stack_top = .);
}