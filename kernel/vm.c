#include "types.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

// The kernel's page table.
pagetable_t kernel_pagetable;

extern char etext[];  // End of kernel .text, from kernel.ld.

// Find the PTE for a virtual address.
// If alloc is non-zero, create new page-table pages if necessary.
pte_t* walk(pagetable_t pagetable, uint64 va, int alloc) {
  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pagetable_t)kalloc()) == 0)
        return 0;
      // Note: xv6 uses memset, but we don't have it yet.
      // A simple loop is fine for now.
      for(int i = 0; i < 512; i++) pagetable[i] = 0;
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

// Create a PTE for a virtual address mapping to a physical address.
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

// Create the kernel's page table.
void kvminit(void) {
  kernel_pagetable = (pagetable_t) kalloc();
  // Note: xv6 uses memset here too.
  for(int i = 0; i < 512; i++) kernel_pagetable[i] = 0;

  // Now, let's address the RWX issue!
  // Map UART registers.
  mappages(kernel_pagetable, UART0, PGSIZE, UART0, PTE_R | PTE_W);

  // Map kernel code segment (Text). Read-Only and Executable.
  mappages(kernel_pagetable, KERNBASE, (uint64)etext - KERNBASE, KERNBASE, PTE_R | PTE_X);

  // Map kernel data segment. Read-Write.
  // Start mapping from the page *after* etext to avoid overlap.
  uint64 data_start = PGROUNDUP((uint64)etext);
  mappages(kernel_pagetable, data_start, PHYSTOP - data_start, data_start, PTE_R | PTE_W);
}

// Switch to the kernel page table.
void kvminithart() {
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
}