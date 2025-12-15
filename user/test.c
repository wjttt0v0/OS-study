#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

// 简单的 assert 实现，测试失败则退出
#define assert(x) \
  do { \
    if (!(x)) { \
      printf("Error: assertion failed %s at line %d\n", #x, __LINE__); \
      exit(1); \
    } \
  } while (0)

// 获取当前时钟周期数 (需要 kernel/sysproc.c 中实现 sys_uptime 或类似的 get_time)
// 如果没有 get_time，我们可以用 uptime() 替代，或者如果你实现了 r_time() 的系统调用
// 这里假设有一个 get_time() 系统调用返回微秒或周期数，如果没有，可以用 uptime() * 1000000 估算
// 为了兼容性，这里使用一个简单的计时循环模拟或者假设 uptime 返回值
uint64 get_time() {
    return uptime(); 
}

// -------------------------------------------------------------------
// 1. 文件系统完整性测试
// -------------------------------------------------------------------
void test_filesystem_integrity(void) {
    printf("Testing filesystem integrity...\n");
    
    // 创建测试文件
    int fd = open("testfile", O_CREATE | O_RDWR);
    assert(fd >= 0);

    // 写入数据
    char buffer[] = "Hello, filesystem!";
    int len = strlen(buffer);
    int bytes = write(fd, buffer, len);
    assert(bytes == len);
    close(fd);

    // 重新打开并验证
    fd = open("testfile", O_RDONLY);
    assert(fd >= 0);
    
    char read_buffer[64];
    bytes = read(fd, read_buffer, sizeof(read_buffer) - 1);
    assert(bytes == len);
    read_buffer[bytes] = '\0';
    
    assert(strcmp(buffer, read_buffer) == 0);
    close(fd);

    // 删除文件
    assert(unlink("testfile") == 0);
    
    printf("Filesystem integrity test passed\n\n");
}

// -------------------------------------------------------------------
// 2. 并发访问测试
// -------------------------------------------------------------------
void test_concurrent_access(void) {
    printf("Testing concurrent file access...\n");
    
    // 创建多个进程同时访问文件系统
    int i;
    for (i = 0; i < 4; i++) {
        int pid = fork();
        if (pid == 0) {
            // 子进程：创建、写入、读取、删除文件
            char filename[32];
            // snprintf 没有实现，我们手动构造文件名 "test_0", "test_1"...
            strcpy(filename, "test_");
            filename[5] = '0' + i;
            filename[6] = '\0';
            
            for (int j = 0; j < 100; j++) {
                int fd = open(filename, O_CREATE | O_RDWR);
                if (fd >= 0) {
                    write(fd, &j, sizeof(j));
                    close(fd);
                    unlink(filename);
                }
            }
            exit(0);
        }
    }

    // 等待所有子进程完成
    for (i = 0; i < 4; i++) {
        wait(0);
    }
    
    printf("Concurrent access test completed\n\n");
}

// -------------------------------------------------------------------
// 3. 性能测试
// -------------------------------------------------------------------
void test_filesystem_performance(void) {
    printf("Testing filesystem performance...\n");
    uint64 start_time = get_time();
    
    // 大量小文件测试
    int i;
    for (i = 0; i < 100; i++) { // 减少到100次以节省测试时间
        char filename[32];
        strcpy(filename, "small_");
        // 简单的整数转字符串
        int tmp = i;
        int idx = 6;
        if(tmp == 0) filename[idx++] = '0';
        else {
             while(tmp > 0) { filename[idx++] = '0' + (tmp % 10); tmp /= 10; }
        }
        filename[idx] = '\0';

        int fd = open(filename, O_CREATE | O_RDWR);
        write(fd, "test", 4);
        close(fd);
    }
    
    uint64 small_files_time = get_time() - start_time;
    
    // 大文件测试
    start_time = get_time();
    int fd = open("large_file", O_CREATE | O_RDWR);
    char large_buffer[1024]; // 1KB buffer
    
    // 写入 1MB (1024 * 1KB)
    for (i = 0; i < 1024; i++) { 
        write(fd, large_buffer, sizeof(large_buffer));
    }
    close(fd);
    
    uint64 large_file_time = get_time() - start_time;
    
    printf("Small files (100 ops): %d ticks\n", (int)small_files_time);
    printf("Large file (1MB): %d ticks\n", (int)large_file_time);
    
    // 清理测试文件
    // (在真实场景中应该遍历删除 small_*, 这里为了演示略过)
    unlink("large_file");
    
    printf("Performance test completed\n\n");
}

// -------------------------------------------------------------------
// 崩溃恢复测试
// -------------------------------------------------------------------
void test_crash_recovery(void) {
    printf("Testing crash recovery...\n");
    
    int fd = open("crash_marker", O_RDONLY);
    
    if (fd < 0) {
        // --- 阶段 1：崩溃前 ---
        printf("Phase 1: Creating file and crashing...\n");
        
        // 1. 创建一个标记文件
        fd = open("crash_marker", O_CREATE | O_RDWR);
        assert(fd >= 0);
        
        // 2. 写入重要数据
        // 在 xv6 中，write 调用结束时，事务已经提交到 Log 区，但可能还没覆盖到数据区
        char *data = "This data must survive crash!";
        int n = write(fd, data, strlen(data));
        assert(n == strlen(data));
        
        // 注意：不要 close(fd)，我们要在一切还在热乎的时候崩溃
        // 3. 触发系统崩溃
        printf("Boom!\n");
        crash(); 
        
    } else {
        // --- 阶段 2：崩溃重启后 ---
        printf("Phase 2: Recovered from crash. Checking data...\n");
        
        char buf[64];
        int n = read(fd, buf, sizeof(buf));
        buf[n] = 0;
        
        printf("Read content: '%s'\n", buf);
        
        // 验证数据是否完整
        // 如果日志恢复机制（recover_from_log）工作正常，数据应该完全一致
        assert(strcmp(buf, "This data must survive crash!") == 0);
        
        close(fd);
        // 清理现场
        unlink("crash_marker");
        printf("Crash recovery test passed!\n\n");
    }
}

// -------------------------------------------------------------------
// 主函数
// -------------------------------------------------------------------
int main(int argc, char *argv[]) {
    printf("===== File System Test Suite =====\n");
    
    test_crash_recovery();
    test_filesystem_integrity();
    test_concurrent_access();
    test_filesystem_performance();
    
    printf("All file system tests passed successfully!\n");
    exit(0);
}