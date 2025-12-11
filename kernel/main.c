#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

#define VERBOSE_BOOT 1

volatile static int started = 0;

void main(void) {
  if(cpuid() == 0){
    consoleinit();
    printfinit();
    
    #if (VERBOSE_BOOT)
    printf("\n");
    printf_color(GREEN, "===== Booting xv6-like Kernel =====\n");
    #endif

    kinit();         // physical page allocator
    kvminit();       // create kernel page table
    kvminithart();   // turn on paging
    procinit();      // process table
    trapinit();      // trap vectors
    trapinithart();  // install kernel trap vector
    plicinit();      // set up interrupt controller
    plicinithart();  // ask PLIC for device interrupts
    seminit();
    shminit();
    binit();         // buffer cache
    iinit();         // inode table
    fileinit();      // file table
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;

    #if (VERBOSE_BOOT)
    printf_color(GREEN, "\nAll initializations complete. Starting scheduler...\n\n");
    #endif

  } else {
    while(started == 0)
      ;
    __sync_synchronize();
    printf("hart %d starting\n", cpuid());
    kvminithart();    // turn on paging
    trapinithart();   // install kernel trap vector
    plicinithart();   // ask PLIC for device interrupts
  }

  scheduler();        
}