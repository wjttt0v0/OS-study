#ifndef __MEMLAYOUT_H__
#define __MEMLAYOUT_H__

#define KERNBASE 0x80000000L
#define PHYSTOP (KERNBASE + 128*1024*1024) // QEMU virt machine has 128MB RAM

#define UART0 0x10000000L

#endif // __MEMLAYOUT_H__