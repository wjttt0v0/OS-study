#include <stdarg.h>

#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
#include "proc.h"

static struct spinlock cons_lock;

int consolewrite(int user_src, uint64 src, int n) {
    int i;
    char c;
    acquire(&cons_lock);
    for (i = 0; i < n; i++) {
        if (either_copyin(&c, user_src, src + i, 1) == -1)
            break;
        uartputc(c);
    }
    release(&cons_lock);
    return i; 
}

static void consoleputuint(uint n) {
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

void consoleputc(char c) {
    acquire(&cons_lock);
    uartputc(c);
    release(&cons_lock);
}

static void consoleputs(const char *s) {
    while (*s)
        consoleputc(*s++);
}

void consoleinit(void) {
    uartinit();
    //consoleputs("console: UART initialized\n");

    devsw[CONSOLE].read = 0;
    devsw[CONSOLE].write = consolewrite;
}

void clear_screen(void) {
    acquire(&cons_lock);
    consoleputs("\033[2J\033[3J\033[H");
    release(&cons_lock);
}

void goto_xy(int x, int y) {
    acquire(&cons_lock);
    consoleputs("\033[");
    consoleputuint(y);
    consoleputc(';');
    consoleputuint(x);
    consoleputc('H');
    release(&cons_lock);
}

void clear_line() {
    acquire(&cons_lock);
    // \033[K:  Clears from cursor to the end of the line.
    // \033[2K: Clears the entire line. We'll use this one.
    consoleputs("\033[2K");
    release(&cons_lock);
}