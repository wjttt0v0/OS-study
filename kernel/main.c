#include "defs.h"

void main(void) {
    consoleinit();
    printf_color(COLOR_YELLOW, "--- Kernel Console Extended Features Test ---\n\n");
    

    printf("Testing colored output:\n");
    clear_screen();

    printf_color(COLOR_RED, "This text is RED.\n");
    printf_color(COLOR_GREEN, "This text is GREEN.\n");
    printf_color(COLOR_BLUE, "This text is BLUE.\n");
    
}