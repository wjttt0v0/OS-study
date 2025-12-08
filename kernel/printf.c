#include "defs.h"
#include <stdarg.h>

static char digits[] = "0123456789abcdef";
volatile int panicking = 0; // printing a panic message
volatile int panicked = 0; // spinning forever at end of a panic

// lock to avoid interleaving concurrent printf's.
static struct {
  struct spinlock lock;
} pr;

static void printint(long long val, int base, int sign) {
    char buf[20];
    int i = 0;
    uint64 x;

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
            printint(va_arg(ap, uint64), 16, 0);
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

void printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
}

void printf_color(int color, const char *fmt, ...) {
    va_list ap;

    consoleputc('\033');
    consoleputc('[');
    printint(color, 10, 0);
    consoleputc('m');

    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);

    const char *reset = "\033[0m";
    while(*reset)
        consoleputc(*reset++);
}

void panic(const char *s) {
    panicked = 1;
    printf("kernel panic: %s\n", s);
    for (;;)
        ;
}

void
printfinit(void)
{
  initlock(&pr.lock, "pr");
}