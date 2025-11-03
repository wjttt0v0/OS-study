#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

void main(void) {
    consoleinit();
    //clear_screen();
    printf("console initialized\n");
    
    kinit();
    printf("kinit done\n");

    kvminit();
    kvminithart();
    
    printf("paging enabled\n");

    trapinithart(); // Set up supervisor trap vector.
    printf("trap init done\n");
    
    // Enable supervisor interrupts.
    // The first timer interrupt was already set in M-mode's timerinit().
    intr_on();
    
    printf_color(GREEN, "Interrupts enabled. Kernel is alive and waiting for timer ticks.\n");

    for(;;)
        ;

}