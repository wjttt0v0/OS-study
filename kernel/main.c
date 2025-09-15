void uart_puts(const char *s);

void main() {
    uart_puts("Hello OS\n");

    while (1);
}