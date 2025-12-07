// kernel/trap.c
#include "types.h"
#include "param.h"
#include "riscv.h"
#include "defs.h"

volatile int *test_flag = 0;

volatile int ticks = 0;

// Assembly entry point for supervisor traps, defined in kernelvec.S.
extern void kernelvec(void);

// Set up supervisor trap handling for the current hart.
void trapinithart(void) {
  // Set the supervisor trap vector to our assembly wrapper.
  w_stvec((uint64)kernelvec);
  // Enable supervisor-level timer interrupts.
  w_sie(r_sie() | SIE_STIE);
}

// The main C trap handler, called from kernelvec.S.
void kerneltrap() {
  uint64 scause = r_scause();
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  
  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled upon entry");

  // Is it an interrupt or an exception?
  if ((scause & 0x8000000000000000L)) {
    // --- Interrupt ---
    if (scause == 0x8000000000000005L) { // Supervisor timer interrupt
      ticks++;

       if (test_flag != 0) {
         (*test_flag)++;
      }
      // Uncomment the line below for visual feedback during testing.
      //printf("."); 

      // Acknowledge and set the next timer interrupt.
      // This is now a legal operation because M-mode in start.c
      // has granted S-mode the necessary permissions.
      w_stimecmp(r_time() + 1000000);
    } else {
      // An unknown interrupt.
      printf("Unexpected interrupt scause=%p sepc=%p\n", scause, sepc);
      panic("kerneltrap: unknown interrupt");
    }
    
  } else {
    // --- Exception ---
    uint64 stval = r_stval();
    printf_color(RED, "\n>>> KERNEL EXCEPTION <<<\n");
    printf("  scause: 0x%p (cause code: %d)\n", scause, scause);
    printf("  sepc:   0x%p (faulting address)\n", sepc);
    printf("  stval:  0x%p (trap value)\n", stval);

    switch (scause) {
      case 2:
        printf_color(RED, "  -> Type: Illegal Instruction\n");
        break;
      case 12:
        printf_color(RED, "  -> Type: Instruction Page Fault\n");
        break;
      case 13:
        printf_color(RED, "  -> Type: Load Page Fault\n");
        break;
      case 15:
        printf_color(RED, "  -> Type: Store Page Fault\n");
        break;
      default:
        printf_color(RED, "  -> Type: Unknown exception\n");
        break;
    }
    panic("Kernel exception");
  }
  
  // Restore trap-related CSRs for sret.
  w_sstatus(sstatus);
  w_sepc(sepc);
}