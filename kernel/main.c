void uartinit(void);
void uartputs(const char *s);

void main() {
    uartinit();
    uartputs("Hello OS\n");

    //while (1);
}