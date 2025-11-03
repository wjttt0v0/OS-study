#include "types.h"
#include "param.h"
#include "defs.h"

// Per-CPU stacks for entry.S.
// NCPU is defined in param.h.
// This array will be placed in the .bss section by the linker.
__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

void main(void) {
    consoleinit();
    clear_screen();
    printf("console initialized\n");

    kinit();
    printf("physical memory allocator initialized\n");

    kvminit();
    printf("kernel page table created\n");

    kvminithart();
    printf("paging enabled!\n");

    printf_color(GREEN, "Hello from virtual memory!\n");
}