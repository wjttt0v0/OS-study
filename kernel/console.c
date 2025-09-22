#include "defs.h"

// Initialize the console.
void consoleinit(void) {
    // Initialize the underlying hardware (UART).
    uartinit();
    
    // Announce that the console is ready.
    // We use a direct uartputs here or a very simple printf
    // because the full printf might rely on console being fully ready.
    // For simplicity, let's just use printf after uartinit.
    printf("console: UART initialized\n");
}

// The central console output function. Forwards a character to the UART.
void consoleputc(char c) {
    uartputc(c);
}

// Clears the screen using ANSI escape codes.
void clear_screen(void) {
    // \033[2J: Clears the entire screen.
    // \033[H:  Moves the cursor to the home position (top-left corner).
    printf("\033[2J\033[H");
}