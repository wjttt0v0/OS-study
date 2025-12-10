#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

// 引用 trap.c 中定义的全局指针
extern volatile int *test_flag;

// 适配 PPT 中的函数名
#define get_time() r_time()

// --- PPT 截图 1: 中断功能测试 ---
void test_timer_interrupt(void) {
    printf("Testing timer interrupt...\n");

    // 记录中断前的时间
    uint64 start_time = get_time();
    int interrupt_count = 0;

    // 设置测试标志
    // 让 trap.c 知道要把中断次数写到这个变量里
    test_flag = &interrupt_count;

    // 在时钟中断处理函数中增加计数
    // 等待几次中断
    while (interrupt_count < 5) {
        // 可以在这里执行其他任务
        printf("Waiting for interrupt %d...\n", interrupt_count + 1);
        
        // 简单延时
        // 使用 volatile 防止编译器优化掉空循环
        for (volatile int i = 0; i < 10000000; i++);
    }
    
    // 测试结束，清空标志，防止后续干扰
    test_flag = 0;

    uint64 end_time = get_time();
    // 注意：这里的 %lu 用于打印 uint64
    printf("Timer test completed: %d interrupts in %d cycles\n", 
           interrupt_count, end_time - start_time);
}

// --- PPT 截图 2: 异常处理测试 ---
void test_exception_handling(void) {
    printf("Testing exception handling...\n");

    // 测试除零异常 (如果支持)
    // RISC-V 硬件通常不产生除零异常，而是设置标志位，这里略过

    // 测试非法指令异常
    printf("Triggering Illegal Instruction...\n");

    // 这是一个内联汇编，插入一条全0指令，必然触发非法指令异常
    asm volatile(".word 0x00000000");

    // 测试内存访问异常 (Load/Store Page Fault)
    // 注意：上面的非法指令会导致 panic，所以代码执行不到这里
    // 如果要测试这个，需要注释掉上面的非法指令
    // volatile char *p = (char *)0x0; *p = 10; 

    printf("Exception tests completed\n");
}

// --- 主入口 ---
void main(void) {
    // 1. 初始化
    consoleinit();
    clear_screen();
    kinit();
    kvminit();
    kvminithart();
    trapinithart();
    intr_on(); // 开启中断

    printf_color(GREEN, "Kernel initialized. Starting tests...\n\n");

    // 2. 运行中断测试
    test_timer_interrupt();

    printf_color(GREEN, "\nTimer test passed. Now running exception test.\n");
    printf_color(RED, "The system is expected to PANIC below:\n\n");

    // 3. 运行异常测试 (会导致系统停止)
    test_exception_handling();

    // 理论上运行不到这里
    for(;;) 
        ;
}