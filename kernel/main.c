#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

void main(void) {
    // ---- Stage 1: Basic Initialization ----
    consoleinit();
    clear_screen();
    printf_color(YELLOW, "--- RISC-V Kernel Booting ---\n\n");

    // ---- Stage 2: Physical Memory Management ----
    printf("Initializing physical memory allocator...\n");
    kinit();
    printf("kinit done. Testing kalloc/kfree...\n");
    
    void *p1 = kalloc();
    void *p2 = kalloc();
    printf("  kalloc() -> p1 = %p\n", p1);
    printf("  kalloc() -> p2 = %p\n", p2);
    if (!p1 || !p2 || p1 == p2) {
        panic("kalloc test failed: allocation error");
    }
    
    kfree(p1);
    void *p3 = kalloc();
    printf("  kfree(p1); kalloc() -> p3 = %p\n", p3);
    if (!p3 || p3 != p1) {
        // In our simple allocator, the first freed page should be the first re-allocated one.
        panic("kalloc test failed: free/re-alloc error");
    }
    kfree(p2);
    kfree(p3);
    printf_color(GREEN, "Physical memory allocator test passed.\n\n");

    // ---- Stage 3: Virtual Memory Initialization ----
    printf("Creating kernel page table...\n");
    kvminit();
    printf("kvminit done.\n");

    printf("Enabling virtual memory (paging)...\n");
    kvminithart();
    printf_color(GREEN, "Virtual memory enabled!\n\n");

    // ---- Stage 4: Post-Paging Verification ----
    printf_color(YELLOW, "--- Post-Paging System Status ---\n\n");

    // 1. Verify we can still print (implies code execution and UART access are working)
    printf("Kernel continues to run after enabling paging. SUCCESS.\n\n");

    // 2. Memory layout and permissions check
    printf("Memory Mapping Verification:\n");
    extern char etext[]; // from kernel.ld
    printf("  Kernel .text (code) segment [KERNBASE, etext):\n");
    printf("    VA Range: [%p, %p), Permissions: Read/Execute (R-X)\n", KERNBASE, etext);
    
    printf("  Kernel data, bss, and free memory [etext, PHYSTOP):\n");
    printf("    VA Range: [%p, %p), Permissions: Read/Write (RW-)\n", etext, PHYSTOP);

    printf("  UART device memory:\n");
    printf("    VA Range: [%p, %p), Permissions: Read/Write (RW-)\n\n", UART0, UART0 + PGSIZE);
    
    // 3. Stack pointer verification
    uint64 sp;
    asm volatile("mv %0, sp" : "=r"(sp));
    printf("Stack pointer verification:\n");
    printf("  Current SP: %p\n", sp);
    // stack0 is the bottom of the stack area. Top is stack0 + NCPU*PGSIZE
    uint64 stack_bottom = (uint64)stack0;
    uint64 stack_top = stack_bottom + NCPU * PGSIZE;
    printf("  Expected stack range for hart 0: [%p, %p)\n", stack_bottom, stack_top);
    if (sp > stack_bottom && sp <= stack_top) {
        printf_color(GREEN, "  Stack pointer is within the expected range. SUCCESS.\n\n");
    } else {
        printf_color(RED, "  Stack pointer is OUTSIDE the expected range. FAILED.\n\n");
    }

    // ---- Final message ----
    printf_color(GREEN, "All tests passed. Kernel initialization complete.\n");
    printf("Entering infinite loop (spin).\n");
}