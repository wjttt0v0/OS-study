// kernel/main.c
#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

// --- Global variables & externs ---
extern volatile int ticks;
extern char stack0[];

// --- Test function declarations ---
void run_all_tests(void);
void delay_seconds(int secs);

// --- Kernel's main entry point ---
void main(void) {
    // 1. Initialize all kernel subsystems
    consoleinit();
    clear_screen();
    kinit();
    kvminit();
    kvminithart();
    trapinithart();
    intr_on();
    
    printf_color(GREEN, "===== Kernel Interrupt & Exception Test Suite =====\n");
    printf("All subsystems initialized. Interrupts are enabled.\n\n");

    // 2. Run the full test suite
    run_all_tests();

    // 3. If all non-halting tests pass, enter idle loop
    printf_color(GREEN, "\nAll tests passed. Entering kernel idle loop.\n");
    for(;;)
      ;
}


// --- Test Suite Controller ---


// --- Test Function Implementations ---

void test_timer_interrupts(void) {
    printf_color(YELLOW, "[TEST 1] Timer Interrupts\n");
    printf("  - Visual spinner will appear for 10 ticks to show liveness.\n\n");
    goto_xy(1, 8);

    int last_ticks = 0;
    ticks = 0;
    while(ticks <= 10) {
        if (ticks > last_ticks) {
            last_ticks = ticks;
            goto_xy(1, 8);
            printf_color(CYAN, "  [%c] System is responsive. Tick count: %d", "|/-\\"[ticks % 4], ticks);
        }
    }
    goto_xy(1, 10);
    printf_color(GREEN, "[OK] Timer interrupt test passed.\n\n");
    delay_seconds(2);
}

void test_store_page_fault(void) {
    printf_color(YELLOW, "[TEST 2] Store Page Fault (scause=15)\n");
    printf("  - Attempting to write to read-only kernel code (.text segment).\n");
    printf("  - EXPECTED: Kernel panic with scause=15.\n\n");
    delay_seconds(3);

    volatile char *p = (char *)KERNBASE;
    *p = 'X'; // Should trigger a store page fault.
    
    printf_color(RED, "[FAIL] Store page fault test FAILED.\n");
}

void test_load_page_fault(void) {
    printf_color(YELLOW, "[TEST 3] Load Page Fault (scause=13)\n");
    printf("  - Attempting to read from an unmapped memory address (NULL pointer).\n");
    printf("  - EXPECTED: Kernel panic with scause=13 and stval=0.\n\n");
    delay_seconds(3);
    
    // Reading from address 0, which is not mapped in our page table.
    volatile char val = *( (char *)0x0 );
    
    // This line is to prevent compiler optimization.
    // It should never be reached.
    printf_color(RED, "[FAIL] Load page fault test FAILED. Read value: %c\n", val);
}

void test_instruction_page_fault(void) {
    printf_color(YELLOW, "[TEST 4] Instruction Page Fault (scause=12)\n");
    printf("  - Attempting to jump and execute code at an unmapped address.\n");
    printf("  - EXPECTED: Kernel panic with scause=12.\n\n");
    delay_seconds(3);

    // Create a function pointer to an invalid address (e.g., NULL).
    void (*func_ptr)(void) = (void (*)(void))0x0;
    
    // Call the function pointer. This will cause the CPU to try to fetch
    // an instruction from address 0, triggering an instruction page fault.
    func_ptr();
    
    printf_color(RED, "[FAIL] Instruction page fault test FAILED.\n");
}

void test_illegal_instruction(void) {
    printf_color(YELLOW, "[TEST 5] Illegal Instruction (scause=2)\n");
    printf("  - Deliberately executing an invalid instruction.\n");
    printf("  - EXPECTED: Kernel panic with scause=2.\n\n");
    delay_seconds(3);

    trigger_illegal_instruction();
    
    printf_color(RED, "[FAIL] Illegal instruction test FAILED.\n");
}

void delay_seconds(int secs) {
    volatile uint64 end_time = r_time() + (uint64)secs * 10000000;
    while(r_time() < end_time);
}

void run_all_tests(void) {
    // --- TEST SWITCHBOARD ---
    // Comment out or uncomment calls below to run specific tests.
    // Note: Exception tests will cause the kernel to panic, which is expected.
    
    // Test 1: Periodic timer interrupts (non-halting)
    // test_timer_interrupts();

    // Test 2: Store Page Fault (halting) - writing to read-only memory
    // test_store_page_fault();

    // Test 3: Load Page Fault (halting) - reading from an invalid address
     test_load_page_fault();
    
    // Test 4: Instruction Page Fault (halting) - executing an invalid address
    //test_instruction_page_fault();
    
    // Test 5: Illegal Instruction (halting)
    // test_illegal_instruction();
}