#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

// --- Test functions based on PPT ---

// Renamed kalloc/kfree to match PPT's test case.
#define alloc_page() kalloc()
#define free_page(p) kfree(p)

void test_physical_memory(void) {
    printf("[TEST] Physical memory allocator...\n");

    // 测试基本分配和释放
    void *page1 = alloc_page();
    void *page2 = alloc_page();
    assert(page1 != 0 && page2 != 0);
    assert(page1 != page2);

    // 页对齐检查
    assert(((uint64)page1 & 0xFFF) == 0);
    printf("  - Allocation & Alignment: OK\n");

    // 测试数据写入
    *(int*)page1 = 0x12345678;
    assert(*(int*)page1 == 0x12345678);
    printf("  - Data Integrity: OK\n");

    // 测试释放和重新分配
    free_page(page1);
    void *page3 = alloc_page();
    assert(page3 == page1); // Our allocator should immediately reuse the freed page
    printf("  - Free & Re-allocation: OK\n");

    free_page(page2);
    free_page(page3);
    
    printf_color(GREEN, "[OK] Physical memory test passed.\n\n");
}

// Renamed functions and types to match PPT's test case.
#define create_pagetable() (pagetable_t)kalloc()
#define walk_lookup(pt, va) walk(pt, va, 0)
#define map_page(pt, va, pa, perm) mappages(pt, va, PGSIZE, pa, perm)

void test_pagetable(void) {
    printf("[TEST] Page table functionality...\n");

    pagetable_t pt = create_pagetable();
    assert(pt != 0);
    memset(pt, 0, PGSIZE);

    // 测试基本映射
    uint64 va = 0x1000000;
    uint64 pa = (uint64)alloc_page();
    assert(pa != 0);
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    printf("  - Basic Mapping: OK\n");

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    assert(pte != 0 && (*pte & PTE_V));
    assert(PTE2PA(*pte) == pa);
    printf("  - Address Translation: OK\n");

    // 测试权限位
    assert(*pte & PTE_R);
    assert(*pte & PTE_W);
    assert(!(*pte & PTE_X));
    printf("  - Permission Bits: OK\n");

    kfree((void*)pa);
    kfree(pt); // Note: this doesn't free intermediate pages from walk.
    
    printf_color(GREEN, "[OK] Page table test passed.\n\n");
}

void test_virtual_memory(void) {
    printf("[TEST] Virtual memory activation...\n");
    printf("  Before enabling paging...\n");
    kvminit();
    kvminithart();
    printf("  After enabling paging...\n");
    
    printf("  Kernel runs in virtual memory. SUCCESS.\n");

    // Extra check: Stack Pointer
    uint64 sp;
    asm volatile("mv %0, sp" : "=r"(sp));
    uint64 stack_bottom = (uint64)stack0;
    uint64 stack_top = stack_bottom + NCPU * PGSIZE;
    
    if (sp > stack_bottom && sp <= stack_top) {
         printf("  Stack pointer check: OK\n");
    } else {
         panic("Stack pointer INVALID");
    }

    printf_color(GREEN, "[OK] Virtual memory activated successfully.\n\n");
}

void main(void) {
    consoleinit();
    clear_screen();
    kinit();
    
    printf_color(YELLOW, "===== Memory Management Test Suite =====\n\n");
    
    test_physical_memory();
    test_pagetable();
    test_virtual_memory();

    printf_color(GREEN, "All memory tests completed. Halting.\n");
    for(;;);
}