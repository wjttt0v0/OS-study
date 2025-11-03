#include "types.h"
#include "riscv.h"
#include "defs.h"

extern void kernelvec(void);

// Set up to take exceptions and traps while in the kernel.
void trapinithart(void) {
  // Set the supervisor trap vector to kernelvec.
  w_stvec((uint64)kernelvec);
  
  // Enable supervisor timer interrupts.
  w_sie(r_sie() | SIE_STIE);
}

// The C part of the kernel trap handler.
void kerneltrap() {
  uint64 scause = r_scause();

  // Check if it's a supervisor timer interrupt.
  if(scause == 0x8000000000000005L) {
    // It is! Let's just print a message for now.
    printf_color(CYAN, "Timer interrupt!\n");

    // Ask for the next timer interrupt.
    // Let's set it to be about 1/10 of a second from now.
    //w_stimecmp(r_time() + 1000000);
    w_sie(r_sie() & ~SIE_STIE);
    
  } else {
    // Not a timer interrupt. Something else happened.
    uint64 sepc = r_sepc();
    printf("Unexpected kernel trap.\n");
    printf("scause=%p sepc=%p\n", scause, sepc); 
    panic("kerneltrap");
  }
}