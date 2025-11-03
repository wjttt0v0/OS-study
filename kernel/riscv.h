#ifndef __RISCV_H__
#define __RISCV_H__

#include "types.h"

#define PGSIZE 4096 // bytes per page
#define PGSHIFT 12  // bits of offset within a page

#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

#define PTE_V (1L << 0) // Valid
#define PTE_R (1L << 1) // Read
#define PTE_W (1L << 2) // Write
#define PTE_X (1L << 3) // Execute
#define PTE_U (1L << 4) // User can access

#define PA2PTE(pa) ((((uint64)pa) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)

// Extract the three 9-bit page table indices from a virtual address.
#define PXMASK 0x1FF
#define PX(level, va) ((((uint64)(va)) >> (PGSHIFT + 9 * (level))) & PXMASK)

// satp register: supervisor address translation and protection register.
#define SATP_SV39 (8L << 60)
#define MAKE_SATP(pagetable) (SATP_SV39 | (((uint64)pagetable) >> 12))

static inline uint64 r_mhartid() {
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
  return x;
}

static inline void w_satp(uint64 x) {
  asm volatile("csrw satp, %0" : : "r" (x));
}

static inline void sfence_vma() {
  // The zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
}

typedef uint64 pte_t;
typedef uint64 *pagetable_t;

#endif // __RISCV_H__