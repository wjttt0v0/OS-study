#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main() {
    // 设置标准文件描述符 (0:stdin, 1:stdout, 2:stderr)
    // 如果 console 设备不存在则创建
    if(open("console", O_RDWR) < 0){
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0);  // stdout
    dup(0);  // stderr

    printf("init: starting\n");

    // --- 执行一次测试 ---
    int pid = fork();
    if(pid < 0){
        printf("init: fork failed\n");
        exit(1);
    }
    
    if(pid == 0){
        char *argv[] = { "test", 0 };
        exec("test", argv);
        printf("init: exec failed\n");
        exit(1);
    } 
    
    int wpid;
    while((wpid = wait(0)) >= 0 && wpid != pid){
    }
    
    printf("init: system halting.\n");
    for(;;){
    }
}
