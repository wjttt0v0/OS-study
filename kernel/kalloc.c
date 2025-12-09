#include "defs.h"
#include "memlayout.h"


extern char end[];

struct run {
  struct run *next;
};

struct {
  struct run *freelist;
} kmem;


void kfree(void *pa) {
  
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  memset(pa, 1, PGSIZE);

  struct run *r;
  r = (struct run*)pa;
  r->next = kmem.freelist;
  kmem.freelist = r;
}

void freerange(void *pa_start, void *pa_end) {
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

void kinit() {
  freerange(end, (void*)PHYSTOP);
}

void* kalloc(void) {
  struct run *r;

  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;

  if(r)
    memset((char*)r, 5, PGSIZE);
  
  return (void*)r;
}