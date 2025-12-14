OUTPUT_ARCH("riscv")
ENTRY(_entry)

/* Program Headers: Tell the loader how to map sections into memory. */
PHDRS {
  text PT_LOAD FLAGS(5);  /* R+X = 5 */
  data PT_LOAD FLAGS(6);  /* R+W = 6 */
}

SECTIONS
{
    . = 0x80000000;

    .text : {
        KEEP(*(.text._entry))
        *(.text .text.*)
        . = ALIGN(4096);
        _trampoline = .;
        *(trampsec)
        . = ALIGN(4096);
        PROVIDE(etext = .); 
    } :text 
    
    .rodata : {
        . = ALIGN(16);
        *(.rodata .rodata.*)
    } :text 
    .data : {
        . = ALIGN(16);
        *(.data .data.*)
    } :data 

    .bss : {
        . = ALIGN(16);
        PROVIDE(sbss = .);
        *(.bss .bss.*)
        *(.sbss .sbss.*) 
        . = ALIGN(16);
        PROVIDE(ebss = .);
    } :data 
    PROVIDE(end = .);
}