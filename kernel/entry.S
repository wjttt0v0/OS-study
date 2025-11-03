.section .text
.global _entry

_entry:
    csrr a0, mhartid
    la sp, stack0
    li t0, 4096
    addi a0, a0, 1
    mul t1, a0, t0
    add sp, sp, t1

    la t0, sbss
    la t1, ebss
bss_loop:
    beq t0, t1, bss_done
    sd zero, 0(t0)
    addi t0, t0, 8
    j bss_loop
bss_done:

    call start

spin:
    j spin