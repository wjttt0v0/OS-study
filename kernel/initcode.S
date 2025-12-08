.section .text
.globl _start
_start:
        # call exit(0)
        li a0, 0     # return value 0
        li a7, 2     # SYS_exit
        ecall