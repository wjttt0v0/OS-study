# We are in Machine Mode.
# The .section directive places the following code in the .text section.
.section .text

# Declare _entry as a global symbol so the linker can find it.
.global _entry

_entry:

    # 1. Set the stack pointer.
    # The stack grows downwards. We load the address of the top of our
    # stack region (defined in the linker script) into the 'sp' register.
    la sp, stack_top

    # 2. Clear the .bss section to meet the C standard.
    # The linker provides the start (sbss) and end (ebss) addresses.
    la t0, sbss
    la t1, ebss
bss_loop:
    beq t0, t1, bss_done  # If start address meets end address, we are done.
    sd zero, 0(t0)      # Store a double-word (8 bytes) of zero from the hardwired zero register.
    addi t0, t0, 8      # Move to the next 8-byte boundary.
    j bss_loop
bss_done:

    call main

spin:
    j spin