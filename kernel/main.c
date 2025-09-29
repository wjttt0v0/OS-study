#include "types.h"
#include "defs.h"

void main(void) {
    consoleinit();
    clear_screen();

    printf_color(YELLOW, "--- Kernel Console Extended Features Test ---\n\n");

    printf("Testing colored output:\n");
    printf_color(RED, "This text is RED.\n");
    printf_color(GREEN, "This text is GREEN.\n");
    printf_color(BLUE, "This text is BLUE.\n");
    printf("Back to default color.\n\n");

    printf("Testing cursor positioning with goto_xy(x, y):\n");
    goto_xy(5, 10);
    printf_color(MAGENTA, "This text is at (x=5, y=10).");
    
    goto_xy(20, 12);
    printf_color(CYAN, "This text is at (x=20, y=12).");
    
    goto_xy(1, 15);
    printf("\n");

    printf("Testing line clearing. This line will be cleared: XXXXX\n");
    goto_xy(1, 16);
    clear_line();
    printf("The line above should now be empty.\n");
    
    goto_xy(1, 20);
    printf_color(GREEN, "\nAll tests completed!\n");
}