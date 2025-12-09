// user/init.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main() {
    int pid, wpid;

    // 1. 设置控制台文件描述符 (0, 1, 2)
    if(open("console", O_RDWR) < 0){
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0);  // stdout
    dup(0);  // stderr

    printf("init: starting\n");

    // 2. Fork 一个子进程来运行测试
    pid = fork();
    if(pid < 0){
        printf("init: fork failed\n");
        exit(1);
    }
    
    if(pid == 0){
        // --- 子进程 ---
        printf("init: execing test\n");
        // 注意：argv 数组需要以 0 结尾
        char *argv[] = { "test", 0 };
        exec("test", argv);
        
        // 如果 exec 返回，说明失败了
        printf("init: exec test failed\n");
        exit(1);
    } 
    
    // --- 父进程 (init) ---
    printf("init: waiting for child %d\n", pid);
    
    // 等待子进程退出
    // wait() 返回退出的子进程 PID
    while((wpid = wait(0)) >= 0 && wpid != pid){
        //printf("a");
        // 可能有其他孤儿进程，继续等
    }
    
    printf("init: test finished. looping forever.\n");

    // 3. 永远不要退出！
    for(;;){
        //printf(".");
        // 在真实系统中，这里会调用 wait() 回收孤儿进程
        // 现在简单起见，只是死循环
        // sleep(10); // 如果有 sleep 可以加个 sleep
    }
}