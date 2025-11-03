#include "types.h"
#include "defs.h"

void main(void) {
    consoleinit();
    clear_screen();
    printf("console initialized\n");

    kinit();
    printf("physical memory allocator initialized\n");

    kvminit();
    printf("kernel page table created\n");

    kvminithart();
    printf("paging enabled!\n");

    printf_color(GREEN, "Hello from virtual memory!\n");
}