#include <stdarg.h>
#include "defs.h"

static char digits[] = "0123456789abcdef";
volatile int panicked = 0;

// Print a 64-bit integer in a given base.
static void printint(long long val, int base, int sign) {
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

// A simple kernel printf.
void printf(const char *fmt, ...) {
    va_list ap;
    char *s;
    int c;

    va_start(ap, fmt);
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
    va_end(ap);
}

// Kernel panic function.
void panic(const char *s) {
    panicked = 1;
    printf("kernel panic: %s\n", s);
    for (;;)
        ;
}