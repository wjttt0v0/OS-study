.section .text
.globl kernelvec
.align 4
kernelvec:
    addi sp, sp, -256
    sd ra, 0(sp)
    sd sp, 8(sp)
    sd gp, 16(sp)
    sd tp, 24(sp)

    call kerneltrap

    ld ra, 0(sp)
    ld sp, 8(sp)
    addi sp, sp, 256

    sret