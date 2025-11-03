#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

pagetable_t kernel_pagetable;
extern char etext[];

pte_t* walk(pagetable_t pagetable, uint64 va, int alloc) {
  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pagetable_t)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 sz, uint64 pa, int perm) {
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

pagetable_t kvmmake(void) {
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
  if (kpgtbl == 0)
    panic("kvmmake: out of memory");
  
  memset(kpgtbl, 0, PGSIZE);

  kvmmap(kpgtbl, UART0, PGSIZE, UART0, PTE_R | PTE_W);
  kvmmap(kpgtbl, KERNBASE, (uint64)etext - KERNBASE, KERNBASE, PTE_R | PTE_X);
  kvmmap(kpgtbl, (uint64)etext, PHYSTOP - (uint64)etext, (uint64)etext, PTE_R | PTE_W);

  return kpgtbl;
}

void kvminit(void) {
  kernel_pagetable = kvmmake();
}

void kvminithart(void) {
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
}