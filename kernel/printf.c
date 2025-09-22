#include <stdarg.h>
#include "defs.h"

// ... (printint, digits[], panicked 变量保持不变) ...
static char digits[] = "0123456789abcdef";
volatile int panicked = 0;

static void printint(long long val, int base, int sign) {
    // ... (此函数实现不变)
    char buf[20];
    int i = 0;
    unsigned long long x;

    if (sign && val < 0) {
        consoleputc('-');
        x = -val;
    } else {
        x = val;
    }

    do {
        buf[i++] = digits[x % base];
    } while ((x /= base) != 0);

    while (--i >= 0)
        consoleputc(buf[i]);
}


// The core worker function for printf and its variants.
// It takes a va_list, making it callable from other variadic functions.
static void vprintf(const char *fmt, va_list ap) {
    char *s;
    int c;

    for (int i = 0; (c = fmt[i] & 0xff) != 0; i++) {
        if (c != '%') {
            consoleputc(c);
            continue;
        }

        c = fmt[++i] & 0xff;
        if (c == 0) break;

        switch (c) {
        case 'd':
            printint(va_arg(ap, int), 10, 1);
            break;
        case 'x':
            printint(va_arg(ap, int), 16, 0);
            break;
        case 'p':
            consoleputc('0');
            consoleputc('x');
            printint(va_arg(ap, unsigned long), 16, 0);
            break;
        case 's':
            if ((s = va_arg(ap, char *)) == 0)
                s = "(null)";
            while (*s)
                consoleputc(*s++);
            break;
        case 'c':
            consoleputc(va_arg(ap, int));
            break;
        case '%':
            consoleputc('%');
            break;
        default:
            consoleputc('%');
            consoleputc(c);
            break;
        }
    }
}

// Standard printf, now a wrapper around vprintf.
void printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
}

// Color printf function.
void printf_color(int color_code, const char *fmt, ...) {
    va_list ap;

    // 1. Print the escape code to set the color.
    printf("\033[%dm", color_code);

    // 2. Call the core vprintf worker to print the formatted string.
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);

    // 3. Print the escape code to reset to default color.
    printf("\033[0m");
}

// Kernel panic function remains the same.
void panic(const char *s) {
    panicked = 1;
    printf("kernel panic: %s\n", s);
    for (;;)
        ;
}