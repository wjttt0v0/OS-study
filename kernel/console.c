#include "defs.h"

// A private helper to print a simple unsigned int for goto_xy.
// This avoids a dependency on printf.c.
static void consoleputuint(unsigned int n) {
    char buf[10];
    int i = 0;
    if (n == 0) {
        consoleputc('0');
        return;
    }
    while(n > 0){
        buf[i++] = (n % 10) + '0';
        n /= 10;
    }
    while(--i >= 0){
        consoleputc(buf[i]);
    }
}

static void consoleputs(const char *s) {
    while (*s) {
        consoleputc(*s++);
    }
}

void consoleinit(void) {
    uartinit();
    consoleputs("console: UART initialized\n");
}

void consoleputc(char c) {
    uartputc(c);
}

void clear_screen(void) {
    consoleputs("\033[2J\033[3J\033[H");
}

// Moves the cursor to the specified row and column.
// Note: Terminal coordinates are typically 1-based.
void goto_xy(int x, int y) {
    consoleputs("\033[");
    consoleputuint(y);
    consoleputs(";");
    consoleputuint(x);
    consoleputs("H");
}

// Clears the current line from the cursor to the end.
void clear_line() {
    // \033[K: Clears from cursor to the end of the line.
    // \033[2K: Clears the entire line. We'll use this one.
    consoleputs("\033[2K");
}