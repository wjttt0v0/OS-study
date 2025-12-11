#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

#define MAX_SHM_PAGES 8
#define MAX_SEMS     16

struct shm_page {
  int key;            // 0 表示未使用
  void *phys_addr;    // 物理地址
  int ref_count;      // 引用计数
};
static struct shm_page shm_table[MAX_SHM_PAGES];

struct sem {
  struct spinlock lock;
  int value;
  int used;
};
static struct sem sems[MAX_SEMS];


void shminit(void) {
    // 目前依靠 BSS 段自动清零即可
    printf("shminit: OK\n");
}

// 核心逻辑：只负责查找/分配物理页，并映射给当前进程
// 返回：映射后的虚拟地址，失败返回 0 (对应用户态的NULL)
uint64 shmget_impl(int key) {
    struct proc *p = myproc();
    void *pa = 0;
    uint64 sz;
    int i;

    // 1. 查找是否已存在
    for(i = 0; i < MAX_SHM_PAGES; i++) {
        if(shm_table[i].key == key) {
            pa = shm_table[i].phys_addr;
            break;
        }
    }

    // 2. 如果不存在，分配新页
    if(pa == 0) {
        for(i = 0; i < MAX_SHM_PAGES; i++) {
            if(shm_table[i].key == 0) {
                pa = kalloc();
                if(pa == 0) return 0;
                memset(pa, 0, PGSIZE);
                shm_table[i].key = key;
                shm_table[i].phys_addr = pa;
                break;
            }
        }
    }
    if(pa == 0) return 0; // 没内存了或表满了

    // 3. 映射到当前进程
    sz = PGROUNDUP(p->sz);
    if(mappages(p->pagetable, sz, PGSIZE, (uint64)pa, PTE_W|PTE_R|PTE_U) < 0){
        // 简单处理：如果是新分配的应该释放，这里略过
        return 0;
    }
    p->sz = sz + PGSIZE;
    return sz;
}


void seminit(void) {
  for(int i = 0; i < MAX_SEMS; i++) {
    initlock(&sems[i].lock, "semaphore");
    sems[i].used = 0;
  }
  printf("seminit: OK\n");
}

int sem_create_impl(int value) {
  if(value < 0) return -1;

  for(int i = 0; i < MAX_SEMS; i++) {
    acquire(&sems[i].lock);
    if(sems[i].used == 0) {
      sems[i].used = 1;
      sems[i].value = value;
      release(&sems[i].lock);
      return i; // 返回 ID
    }
    release(&sems[i].lock);
  }
  return -1;
}

int sem_free_impl(int id) {
  if(id < 0 || id >= MAX_SEMS) return -1;

  acquire(&sems[id].lock);
  if(sems[id].used == 1) {
    sems[id].used = 0;
  }
  release(&sems[id].lock);
  return 0;
}

int sem_p_impl(int id) {
  if(id < 0 || id >= MAX_SEMS) return -1;

  acquire(&sems[id].lock);
  
  if(sems[id].used == 0) {
      release(&sems[id].lock);
      return -1;
  }

  while(sems[id].value == 0) {
    // 资源为0，睡眠。
    // sleep 原子地释放锁并挂起当前进程
    sleep(&sems[id], &sems[id].lock);
    
    // 醒来后再次检查有效性
    if(sems[id].used == 0) {
        release(&sems[id].lock);
        return -1;
    }
  }
  
  sems[id].value--;
  release(&sems[id].lock);
  return 0;
}

int sem_v_impl(int id) {
  if(id < 0 || id >= MAX_SEMS) return -1;

  acquire(&sems[id].lock);
  
  if(sems[id].used == 0) {
      release(&sems[id].lock);
      return -1;
  }

  sems[id].value++;
  wakeup(&sems[id]); // 唤醒等待者
  
  release(&sems[id].lock);
  return 0;
}