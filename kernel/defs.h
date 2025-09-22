// ANSI Color Codes
#define COLOR_BLACK   30
#define COLOR_RED     31
#define COLOR_GREEN   32
#define COLOR_YELLOW  33
#define COLOR_BLUE    34
#define COLOR_MAGENTA 35
#define COLOR_CYAN    36
#define COLOR_WHITE   37

// uart.c
void uartinit(void);
void uartputc(char c);

// console.c
void consoleinit(void);
void consoleputc(char c);
void clear_screen(void);
void goto_xy(int x, int y);
void clear_line(void);

// printf.c
void printf(const char *fmt, ...);
void printf_color(int color_code, const char *fmt, ...);
void panic(const char *s);