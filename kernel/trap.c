#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct spinlock tickslock;
uint ticks;

extern char trampoline[], uservec[];
void kernelvec();

static void print_exception_details(uint64, uint64, uint64);
static int devintr();

void trapinit(void) { 
  initlock(&tickslock, "time"); 
}

void trapinithart(void) { 
  w_stvec((uint64)kernelvec); 
}

uint64 usertrap(void) {
  int which_dev = 0;
  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();

  p->trapframe->epc = r_sepc();
  
  if(r_scause() == 8){
    if(killed(p)) kexit(-1);

    p->trapframe->epc += 4;
    intr_on();
    syscall();
  }
  else if((which_dev = devintr()) != 0){

  }
  else {
    printf_color(RED, "\n>>> USER EXCEPTION <<<\n");
    printf("  Process %d (%s) triggered.\n", p->pid, p->name);
    print_exception_details(r_scause(), r_sepc(), r_stval());
    setkilled(p);
  }
  if(killed(p))
    kexit(-1);

  if(which_dev == 2)
    yield();

  prepare_return();

  // the user page table to switch to, for trampoline.S
  uint64 satp = MAKE_SATP(p->pagetable);

  // return to trampoline.S; satp value in a0.
  return satp;
}

void prepare_return(void) {
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
  //uint64 fn = TRAMPOLINE + (userret - trampoline);
  //((void (*)(uint64, uint64))fn)(TRAPFRAME, (uint64)(p->pagetable));
}

void kerneltrap() {
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  int which_dev = 0;
  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    printf_color(RED, "\n>>> KERNEL EXCEPTION <<<\n");
    print_exception_details(r_scause(), sepc, r_stval());
    panic("Kernel exception");
  }
  if(which_dev == 2 && myproc() != 0)
    yield();
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr(void) {
  if(cpuid() == 0){
    acquire(&tickslock);
    ticks++;
    wakeup(&ticks);
    release(&tickslock);
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
}

static int devintr(void) {
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      //uartintr();
      panic("uartintr");
    } else 
    if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("unexpected interrupt irq=%d\n", irq);
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
  }
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