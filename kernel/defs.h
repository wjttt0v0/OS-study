// uart.c
void uartinit(void);
void uartputc(char c);

// console.c
void consoleinit(void);
void consoleputc(char c);
void clear_screen(void);

// printf.c
void printf(const char *fmt, ...);
void panic(const char *s);