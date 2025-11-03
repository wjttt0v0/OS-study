// Physical memory allocator.
#include "types.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

// This symbol is defined by the linker script.
extern char end[];

struct run {
  struct run *next;
};

struct {
  struct run *freelist;
} kmem;

// Free the page of physical memory pointed at by pa.
void kfree(void *pa) {
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Treat the page as a list element and add it to the freelist.
  r = (struct run*)pa;
  r->next = kmem.freelist;
  kmem.freelist = r;
}

// Free a range of memory pages.
void freerange(void *pa_start, void *pa_end) {
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Initialize the free list.
void kinit() {
  freerange(end, (void*)PHYSTOP);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void* kalloc(void) {
  struct run *r;

  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  
  return (void*)r;
}