#include "defs.h"

// Set to 0 to reduce boot messages.
#define VERBOSE_BOOT 1

void main(void) {
    // Basic console and lock initialization
    consoleinit();
    printfinit();
    
    #if (VERBOSE_BOOT)
    printf("\n");
    printf_color(GREEN, "===== Booting xv6-like Kernel =====\n");
    #endif

    // Core kernel subsystems initialization
    kinit();           // Physical memory allocator
    kvminit();         // Create kernel page table
    kvminithart();     // Enable paging
    procinit();        // Process table
    trapinit();        // Trap vectors for locks
    trapinithart();    // Install kernel trap vector
    plicinit();        // set up interrupt controller
    plicinithart();    // ask PLIC for device interrupts
    binit();           // Buffer cache
    iinit();           // Inode table
    fileinit();        // File table
    virtio_disk_init();// emulated hard disk
    userinit();        // Create the first user process (initcode)

    #if (VERBOSE_BOOT)
    printf_color(GREEN, "\nAll initializations complete. Starting scheduler...\n\n");
    #endif

    // Start the scheduler. It should never return.
    scheduler();
}