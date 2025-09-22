#include "defs.h"

void main(void) {
    // Initialize the console system.
    consoleinit();

    // Clear the screen.
    clear_screen();
    printf("%s\n", "abc");
    printf("----------------------------------------\n");
    printf(" Minimal RISC-V Kernel printf Test\n");
    printf("----------------------------------------\n\n");

    // ... (rest of the tests remain the same)
    printf("Hello OS! The number is %d\n", 42);
    printf("A negative number: %d\n", -123);
    printf("Hexadecimal: 0x%x\n", 0xDEADBEEF);
    char *str = "a test string";
    printf("A string: %s\n", str);
    printf("A character: %c\n", 'Z');
    printf("A literal percent sign: %%\n");
    printf("\n--- Edge Cases ---\n");
    printf("NULL string: %s\n", (char*)0);
    printf("Pointer address: %p\n", (void*)main);
    
    printf("\nAll tests passed. System is alive.\n");
    
    // Returns to the spin loop in entry.S
}