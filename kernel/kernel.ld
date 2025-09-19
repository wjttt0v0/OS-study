OUTPUT_ARCH("riscv")
ENTRY(_entry)

PHDRS {
  text PT_LOAD FLAGS(5);  /* Read + Execute (R-X). 5 = 4(R) + 1(X) */
  data PT_LOAD FLAGS(6);  /* Read + Write (RW-).   6 = 4(R) + 2(W) */
}

SECTIONS
{
    . = 0x80000000;

    .text : {
        kernel/entry.o(_entry)   /* -->  KEEP(*(.text._entry)) */
        *(.text .text.*)
        PROVIDE(etext = .); 
    }:text
    
    .rodata : {
        . = ALIGN(16);
        *(.rodata .rodata.*)
    }:text

    .data : {
        . = ALIGN(16);
        *(.data .data.*)
    }:data

    .bss : {
        . = ALIGN(16);
        PROVIDE(sbss = .);
        *(.bss .bss.*)
        *(.sbss .sbss.*) 
        . = ALIGN(16);
        PROVIDE(ebss = .);
    }:data

    PROVIDE(end = .);

    . = ALIGN(16);
    . = . + 4096;    /* 4 KB stack */
    PROVIDE(stacktop = .);
}