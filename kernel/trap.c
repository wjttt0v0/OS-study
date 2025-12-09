#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct spinlock tickslock;
volatile uint ticks;

extern char trampoline[], uservec[], userret[];
void kernelvec();

static void print_exception_details(uint64, uint64, uint64);
static int devintr(void);
void usertrapret(void);
void clockintr(void);

void trapinit(void) { initlock(&tickslock, "time"); }
void trapinithart(void) { w_stvec((uint64)kernelvec); }

void usertrap(void) {
  int which_dev = 0;
  if((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
  w_stvec((uint64)kernelvec);
  struct proc *p = myproc();
  p->trapframe->epc = r_sepc();
  if(r_scause() == 8){
    if(p->killed) exit(-1);
    p->trapframe->epc += 4;
    intr_on();
    syscall();
  } else if((which_dev = devintr()) != 0){}
  else {
    printf_color(RED, "\n>>> USER EXCEPTION <<<\n");
    printf("  Process %d (%s) triggered.\n", p->pid, p->name);
    print_exception_details(r_scause(), r_sepc(), r_stval());
    p->killed = 1;
  }
  if(p->killed) exit(-1);
  if(which_dev == 2) yield();
  usertrapret();
}

void usertrapret(void) {
  struct proc *p = myproc();
  intr_off();
  w_stvec(TRAMPOLINE + (uservec - trampoline));
  p->trapframe->kernel_satp = r_satp();
  p->trapframe->kernel_sp = p->kstack + PGSIZE;
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;
  x |= SSTATUS_SPIE;
  w_sstatus(x);
  w_sepc(p->trapframe->epc);
  uint64 fn = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, (uint64)(p->pagetable));
}

void kerneltrap() {
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  int which_dev = 0;
  if((sstatus & SSTATUS_SPP) == 0) panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0) panic("kerneltrap: interrupts enabled");
  if((which_dev = devintr()) == 0){
    printf_color(RED, "\n>>> KERNEL EXCEPTION <<<\n");
    print_exception_details(r_scause(), sepc, r_stval());
    panic("Kernel exception");
  }
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr(void) {
  acquire(&tickslock);
  ticks++;
  wakeup((void*)&ticks);
  release(&tickslock);
}

static int devintr(void) {
  uint64 scause = r_scause();
  if(scause == 0x8000000000000005L){ clockintr(); return 2; }
  return 0;
}

static void print_exception_details(uint64 scause, uint64 sepc, uint64 stval) {
    printf("  scause: 0x%p (cause code: %d)\n", scause, scause);
    printf("  sepc:   0x%p (faulting address)\n", sepc);
    printf("  stval:  0x%p (trap value)\n", stval);
    switch (scause) {
      case 2:  printf_color(RED, "  -> Type: Illegal Instruction\n"); break;
      case 12: printf_color(RED, "  -> Type: Instruction Page Fault\n"); break;
      case 13: printf_color(RED, "  -> Type: Load Page Fault\n"); break;
      case 15: printf_color(RED, "  -> Type: Store Page Fault\n"); break;
      default: printf_color(RED, "  -> Type: Unknown exception\n"); break;
    }
}