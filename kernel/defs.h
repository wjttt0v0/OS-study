#ifndef __DEFS_H__
#define __DEFS_H__

#include "types.h"
#include "riscv.h"

#define assert(x)                                       \
  do {                                                  \
    if (!(x))                                           \
      panic("assertion failed: " #x);                   \
  } while (0)

// uart.c
void uartinit(void);
void uartputc(char c);

// console.c
void consoleinit(void);
void consoleputc(char c);
void clear_screen(void);
void goto_xy(int x, int y);
void clear_line(void);

// printf.c
void printf(const char *fmt, ...);
void printf_color(int color, const char *fmt, ...);
void panic(const char *s);

// kalloc.c
void  kinit();
void* kalloc(void);
void  kfree(void *);

// vm.c
void  kvminit(void);
void  kvminithart(void);

int   mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm);
pte_t* walk(pagetable_t pagetable, uint64 va, int alloc);

// string.c
void* memset(void *dst, int c, uint n);

// trap.c
void trapinithart(void);

#endif // __DEFS_H__