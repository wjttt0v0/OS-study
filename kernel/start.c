#include "defs.h"

void main(void);
static void timerinit(void);

__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

// M-mode entry point
void start(void) {
    // Set M Previous Privilege mode to Supervisor for mret
    unsigned long x = r_mstatus();
    x &= ~MSTATUS_MPP_MASK;
    x |= MSTATUS_MPP_S;
    w_mstatus(x);

    // Set M Exception Program Counter to main for mret
    w_mepc((uint64)main);

    // Disable paging for M-mode.
    w_satp(0);

    // Delegate all interrupts and exceptions to supervisor mode.
    w_medeleg(0xffff);
    w_mideleg(0xffff);
    
    // Ask for clock interrupts.
    timerinit();

    // Configure Physical Memory Protection to grant S-mode access to all memory.
    w_pmpaddr0(0x3fffffffffffffull);
    w_pmpcfg0(0xf);

    // Keep each CPU's hartid in its tp register.
    w_tp(r_mhartid());

    // Switch to supervisor mode and jump to main().
    asm volatile("mret");
}

// Machine-mode timer initialization.
static void timerinit() {
    // Enable supervisor-mode timer interrupts in M-mode.
    w_mie(r_mie() | MIE_STIE);
  
    // Grant S-mode permission to read the 'time' register.
    w_mcounteren(0xffffffff); // Enable all counters for simplicity

    // Grant S-mode permission to write the 'stimecmp' register.
    w_menvcfg(r_menvcfg() | (1L << 63)); 
  
    // Set the first timer interrupt.
    uint64 interval = 1000000;
    //w_stimecmp(r_time() + interval);

    volatile uint64 *mtime = (uint64*)CLINT_MTIME;
    volatile uint64 *mtimecmp = (uint64*)CLINT_MTIMECMP(r_mhartid());
    *mtimecmp = *mtime + interval;
}