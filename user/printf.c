#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include <stdarg.h>

#define PRINTF_BUF_SIZE 512

static char digits[] = "0123456789ABCDEF";

struct printbuf {
  char buf[PRINTF_BUF_SIZE];
  int idx;
};

static void
buf_putc(struct printbuf *b, char c)
{
  if (b->idx < PRINTF_BUF_SIZE - 1)
    b->buf[b->idx++] = c;
}

static void
buf_printint(struct printbuf *b, long long xx, int base, int sgn)
{
  char tmp[20];
  int i = 0;
  unsigned long long x;

  if (sgn && xx < 0) {
    buf_putc(b, '-');
    x = -xx;
  } else {
    x = xx;
  }

  do {
    tmp[i++] = digits[x % base];
  } while ((x /= base) != 0);

  while (--i >= 0)
    buf_putc(b, tmp[i]);
}

static void
buf_printptr(struct printbuf *b, uint64 x)
{
  buf_putc(b, '0');
  buf_putc(b, 'x');
  for (int i = 0; i < sizeof(uint64) * 2; i++, x <<= 4)
    buf_putc(b, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

static void
buf_vprintf(struct printbuf *b, const char *fmt, va_list ap)
{
  char *s;
  int c;

  for (int i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    if (c != '%') {
      buf_putc(b, c);
      continue;
    }

    c = fmt[++i] & 0xff;
    if (c == 0)
      break;

    switch (c) {
    case 'd':
      buf_printint(b, va_arg(ap, int), 10, 1);
      break;
    case 'x':
      buf_printint(b, va_arg(ap, int), 16, 0);
      break;
    case 'p':
      buf_printptr(b, va_arg(ap, uint64));
      break;
    case 's':
      if ((s = va_arg(ap, char *)) == 0)
        s = "(null)";
      while (*s)
        buf_putc(b, *s++);
      break;
    case 'c':
      buf_putc(b, va_arg(ap, int));
      break;
    case '%':
      buf_putc(b, '%');
      break;
    default:
      buf_putc(b, '%');
      buf_putc(b, c);
      break;
    }
  }
}

void
fprintf(int fd, const char *fmt, ...)
{
  struct printbuf b;
  va_list ap;

  b.idx = 0;
  va_start(ap, fmt);
  buf_vprintf(&b, fmt, ap);
  va_end(ap);

  write(fd, b.buf, b.idx);
}

void
printf(const char *fmt, ...)
{
  struct printbuf b;
  va_list ap;

  b.idx = 0;
  va_start(ap, fmt);
  buf_vprintf(&b, fmt, ap);
  va_end(ap);

  write(1, b.buf, b.idx);
}
