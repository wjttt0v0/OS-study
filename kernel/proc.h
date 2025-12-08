#ifndef __PROC_H__
#define __PROC_H__

#include "param.h"
#include "riscv.h"
#include "spinlock.h"

// Saved registers for context switching.
struct context {
  uint64 ra;
  uint64 sp;
  // callee-saved registers
  uint64 s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;
};

struct cpu {
  struct proc *proc;
  struct context context;
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};
extern struct cpu cpus[NCPU];

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Saved registers for kernel context switches.
struct trapframe {
  uint64 kernel_satp;         // kernel page table
  uint64 kernel_sp;           // top of process's kernel stack
  uint64 kernel_trap;         // usertrap()
  uint64 epc;                 // saved user program counter
  uint64 kernel_hartid;       // saved kernel tp
  uint64 ra, sp, gp, tp;
  uint64 t0, t1, t2, t3, t4, t5, t6;
  uint64 s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;
  uint64 a0, a1, a2, a3, a4, a5, a6, a7;
};

struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state;        // Process state
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  int xstate;                  // Exit status to be returned to parent's wait
  int pid;                     // Process ID

  // wait_lock must be held when using this:
  struct proc *parent;         // Parent process

  // these are private to the process, so p->lock need not be held.
  uint64 kstack;               // Virtual address of kernel stack
  uint64 sz;                   // Size of process memory (bytes)
  pagetable_t pagetable;       // User page table
  struct trapframe *trapframe; // data page for trampoline.S
  struct context context;      // swtch() here to run process
  struct file *ofile[NOFILE];  // Open files, needs param.h for NOFILE
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (for debugging)
};

#endif // __PROC_H__