# Supervisor-mode trap entry vector.
.globl kernelvec
.align 4
kernelvec:
    # Save all caller-saved registers onto the stack.
    addi sp, sp, -256
    sd ra, 0(sp)
    sd sp, 8(sp)
    sd gp, 16(sp)
    sd tp, 24(sp)
    sd t0, 32(sp)
    sd t1, 40(sp)
    sd t2, 48(sp)
    sd a0, 72(sp)
    sd a1, 80(sp)
    sd a2, 88(sp)
    sd a3, 96(sp)
    sd a4, 104(sp)
    sd a5, 112(sp)
    sd a6, 120(sp)
    sd a7, 128(sp)
    sd t3, 216(sp)
    sd t4, 224(sp)
    sd t5, 232(sp)
    sd t6, 240(sp)

    # Call the C trap handler.
    call kerneltrap

    # Restore all saved registers from the stack.
    ld ra, 0(sp)
    ld gp, 16(sp)
    # tp is not restored as it holds the hartid.
    ld t0, 32(sp)
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld a0, 72(sp)
    ld a1, 80(sp)
    ld a2, 88(sp)
    ld a3, 96(sp)
    ld a4, 104(sp)
    ld a5, 112(sp)
    ld a6, 120(sp)
    ld a7, 128(sp)
    ld t3, 216(sp)
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)
    ld sp, 8(sp)
    addi sp, sp, 256
    
    # Return from supervisor trap.
    sret