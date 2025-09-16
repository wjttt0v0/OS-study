.section .text
.global _entry

_entry:
    la sp, stack0

    la t0, sbss
    la t1, ebss
bss_loop:
    beq t0, t1, bss_done
    sd zero, 0(t0) 
    addi t0, t0, 8
    j bss_loop
bss_done:

    call main

spin:
    j spin