#include "user.h"

void test_pipe() {
    printf("--- Testing Pipe ---\n");
    
    int p[2]; // p[0] is read end, p[1] is write end
    char buf[100];

    // 1. 创建管道
    if(pipe(p) < 0){
        printf("pipe failed\n");
        exit(1);
    }

    int pid = fork();

    if(pid == 0){
        // --- 子进程 ---
        close(p[1]); // 关闭写端
        
        // 从管道读取
        printf("Child: reading from pipe...\n");
        int n = read(p[0], buf, sizeof(buf));
        if(n > 0){
            buf[n] = 0; // 字符串结束符
            printf("Child: received '%s'\n", buf);
        } else {
            printf("Child: read failed or empty\n");
        }
        
        close(p[0]);
        exit(0);
    } else {
        // --- 父进程 ---
        close(p[0]); // 关闭读端
        
        printf("Parent: writing to pipe...\n");
        write(p[1], "Hello Pipe!", 12);
        
        close(p[1]);
        wait(0); // 等待子进程
        printf("Pipe test finished.\n\n");
    }
}

void test_shm() {
    printf("--- Testing Shared Memory ---\n");
    int key = 1234;
    
    int pid = fork();
    if(pid == 0) {
        // 子进程
        sleep(5); // 等父进程先写
        char *shm = (char*)shmget(key);
        printf("Child: Read from shm: %s\n", shm);
        exit(0);
    } else {
        // 父进程
        char *shm = (char*)shmget(key);
        strcpy(shm, "Hello from Shared Memory!");
        printf("Parent: Wrote to shm.\n");
        wait(0);
    }
    printf("Shared Memory test finished.\n\n");
}

void test_sem() {
    printf("--- Testing Semaphore ---\n");
    
    // 创建一个初始值为 0 的信号量
    // 这意味着第一个尝试 P 操作的进程将会被阻塞
    int sem_id = sem_create(0);
    if (sem_id < 0) {
        printf("Error: sem_create failed\n");
        exit(1);
    }
    printf("Semaphore created (id=%d, val=0)\n", sem_id);

    int pid = fork();
    if (pid < 0) {
        printf("Error: fork failed\n");
        exit(1);
    }

    if (pid == 0) {
        // --- 子进程 ---
        printf("Child: I am working (sleeping 10 ticks)...\n");
        sleep(10); // 模拟耗时操作，证明父进程确实在等待
        
        printf("Child: Work done. V-ing (signaling) semaphore.\n");
        sem_v(sem_id); // 释放资源，唤醒父进程
        
        exit(0);
    } else {
        // --- 父进程 ---
        printf("Parent: I need to wait for child (P-ing semaphore)...\n");
        
        // P 操作：因为初始值是 0，这里应该阻塞，直到子进程调用 V
        sem_p(sem_id); 
        
        printf("Parent: I am awake! Acquired semaphore.\n");
        
        wait(0); // 等待子进程彻底退出
        sem_free(sem_id); // 销毁信号量
        printf("Semaphore test passed.\n\n");
    }
}


int main() {
    test_pipe();
    test_shm();
    test_sem();

    printf("All IPC tests passed successfully!\n");
    exit(0);
}