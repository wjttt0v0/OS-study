#include "types.h"
#include "param.h"
#include "riscv.h"
#include "defs.h"

void main(void);
static void timerinit(void); // timerinit is local to this file

void start(void) {
  // Set M Previous Privilege mode to Supervisor
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
  x |= MSTATUS_MPP_S;
  w_mstatus(x);

  // Set M Exception Program Counter to main
  w_mepc((uint64)main);

  // Disable paging for now.
  w_satp(0);

  // Delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
  w_mideleg(0xffff);

  // Ask for clock interrupts.
  timerinit();

  // Configure Physical Memory Protection
  w_pmpaddr0(0x3fffffffffffffull);
  w_pmpcfg0(0xf);

  // Keep each CPU's hartid in its tp register
  int id = r_mhartid();
  w_tp(id);

  // Switch to supervisor mode and jump to main().
  asm volatile("mret");
}

// Machine-mode timer initialization.
static void timerinit() {
  // Enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);

  // Allow supervisor to access time registers.
  // Set the CY(0), TM(1), IR(2) bits. 3 means CY and TM.
  w_mcounteren(0xffffffff); // Simplest way: enable all counters for S-mode.
  
  // Set the first timer interrupt.
  // 1000000 is about 1/10 of a second in QEMU.
  uint64 interval = 1000000;
  w_stimecmp(r_time() + interval);
}