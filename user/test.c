#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

#define assert(x) \
  do { \
    if (!(x)) { \
      printf("Assertion failed: %s\n", #x); \
      exit(1); \
    } \
  } while (0)

/* ========================
 * 简单子进程任务
 * ======================== */
void
simple_task(void)
{
  printf("simple_task: pid=%d\n", getpid());
  exit(0);
}

/* ========================
 * CPU 密集型任务
 * ======================== */
void
cpu_task(void)
{
  volatile int x = 0;
  for (int i = 0; i < 100000000; i++)
    x++;

  printf("cpu_task done: pid=%d\n", getpid());
  exit(0);
}

/* ========================
 * 1. 进程创建测试
 * ======================== */
void
test_process_creation(void)
{
  printf("=== [1] Process creation test ===\n");

  int pid = fork();
  if (pid == 0)
    simple_task();

  assert(pid > 0);
  wait(0);

  int count = 0;
  for (int i = 0; i < NPROC + 5; i++) {
    int cpid = fork();
    if (cpid < 0)
      break;
    if (cpid == 0)
      simple_task();
    count++;
  }

  printf("Created %d processes before failure\n", count);

  for (int i = 0; i < count; i++)
    wait(0);

  printf("=== [1] Done ===\n\n");
}

/* ========================
 * 2. 调度器测试（无 IPC）
 * ======================== */
void
test_scheduler(void)
{
  printf("=== [2] Scheduler test ===\n");

  for (int i = 0; i < 3; i++) {
    if (fork() == 0)
      cpu_task();
  }

  uint start = uptime();

  for (int i = 0; i < 3; i++)
    wait(0);

  uint end = uptime();

  printf("Scheduler ran 3 CPU tasks in %d ticks\n", end - start);
  printf("=== [2] Done ===\n\n");
}

/* ========================
 * 3. wait / sleep 行为测试
 * ======================== */
void
test_wait_and_sleep(void)
{
  printf("=== [3] wait & sleep test ===\n");

  int pid = fork();
  if (pid == 0) {
    sleep(50);
    exit(0);
  }

  uint start = uptime();
  wait(0);
  uint end = uptime();

  printf("Child slept ~50 ticks, observed %d ticks\n", end - start);
  assert(end - start >= 50);

  printf("=== [3] Done ===\n\n");
}

/* ========================
 * main
 * ======================== */
int
main(void)
{
  printf("\n===== Process / Scheduler Tests (No IPC) =====\n\n");

  test_process_creation();
  test_scheduler();
  test_wait_and_sleep();

  printf("===== All tests finished =====\n");
  exit(0);
}
