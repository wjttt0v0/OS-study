#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

/* ========================
 * 1. 基础系统调用测试
 * ======================== */
void
test_basic_syscalls(void)
{
  printf("=== [1] Testing basic system calls ===\n");

  // getpid
  int pid = getpid();
  printf("Current PID: %d\n", pid);

  // fork / wait / exit
  int child_pid = fork();
  if (child_pid == 0) {
    // 子进程
    printf("Child process running, PID=%d\n", getpid());
    exit(42);
  } else if (child_pid > 0) {
    // 父进程
    int status = -1;
    int ret = wait(&status);
    printf("wait returned pid=%d, status=%d\n", ret, status);
  } else {
    printf("fork failed!\n");
  }

  printf("=== [1] Basic syscall test done ===\n\n");
}

/* ========================
 * 2. 参数传递测试
 * ======================== */
void
test_parameter_passing(void)
{
  printf("=== [2] Testing parameter passing ===\n");

  char buffer[] = "Hello, World!\n";

  int fd = open("/dev/console", O_RDWR);
  if (fd >= 0) {
    int n = write(fd, buffer, strlen(buffer));
    printf("write returned %d\n", n);
    close(fd);
  } else {
    printf("open /dev/console failed\n");
  }

  // 边界 / 非法参数测试（期望失败）
  int r;

  r = write(-1, buffer, 10);
  printf("write(-1, ...) = %d (expected = 0)\n", r);

  r = write(1, 0, 10);
  printf("write(fd, NULL, ...) = %d (expected = 0)\n", r);

  r = write(1, buffer, -1);
  printf("write(fd, buf, -1) = %d (expected = 0)\n", r);

  printf("=== [2] Parameter passing test done ===\n\n");
}

/* ========================
 * 3. 安全性测试
 * ======================== */
void
test_security(void)
{
  printf("=== [3] Testing security checks ===\n");

  // 非法用户指针（指向内核或未映射区域）
  
  char *invalid_ptr = (char*)0x1000000;
  int r = write(1, invalid_ptr, 10);
  printf("write(invalid_ptr) = %d (expected = 0)\n", r);

  printf("=== [3] Security test done ===\n\n");
}

/* ========================
 * 4. 性能测试
 * ======================== */
void
test_syscall_performance(void)
{
  printf("=== [4] Testing syscall performance ===\n");

  uint64 start = uptime();

  for (int i = 0; i < 10000; i++) {
    getpid();
  }

  uint64 end = uptime();
  printf("10000 getpid() calls took %d ticks\n", (int)(end - start));

  printf("=== [4] Performance test done ===\n\n");
}

/* ========================
 * main
 * ======================== */
int
main(int argc, char *argv[])
{
  printf("\n===== User Test Program Started =====\n\n");

  test_basic_syscalls();
  test_parameter_passing();
  test_security();
  test_syscall_performance();

  printf("===== All tests finished =====\n");
  for (;;) ;
  exit(0);
}
