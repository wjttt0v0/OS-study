#ifndef __RISCV_H__
#define __RISCV_H__

#include "types.h"

// --- C functions to read/write CSRs ---

static inline uint64 r_mhartid() {
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
  return x;
}

// Machine Status Register, mstatus
#define MSTATUS_MPP_MASK (3L << 11) // Previous Privilege Mode
#define MSTATUS_MPP_M    (3L << 11)
#define MSTATUS_MPP_S    (1L << 11)
#define MSTATUS_MPP_U    (0L << 11)

static inline uint64 r_mstatus() {
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
  return x;
}
static inline void w_mstatus(uint64 x) {
  asm volatile("csrw mstatus, %0" : : "r" (x));
}

// Machine Exception Program Counter, mepc
static inline void w_mepc(uint64 x) {
  asm volatile("csrw mepc, %0" : : "r" (x));
}

// Supervisor Status Register, sstatus
#define SSTATUS_SIE (1L << 1) // Supervisor Interrupt Enable

static inline uint64 r_sstatus() {
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
  return x;
}
static inline void w_sstatus(uint64 x) {
  asm volatile("csrw sstatus, %0" : : "r" (x));
}

// Supervisor Interrupt Enable Register, sie
#define SIE_SEIE (1L << 9) // Supervisor External Interrupt Enable
#define SIE_STIE (1L << 5) // Supervisor Timer Interrupt Enable

static inline uint64 r_sie() {
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
  return x;
}
static inline void w_sie(uint64 x) {
  asm volatile("csrw sie, %0" : : "r" (x));
}

// Machine-mode Interrupt Enable, mie
#define MIE_STIE (1L << 5)  // Supervisor Timer Interrupt Enable

static inline uint64 r_mie() {
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
  return x;
}
static inline void w_mie(uint64 x) {
  asm volatile("csrw mie, %0" : : "r" (x));
}

// Machine Exception Delegation Registers
static inline void w_medeleg(uint64 x) {
  asm volatile("csrw medeleg, %0" : : "r" (x));
}
static inline void w_mideleg(uint64 x) {
  asm volatile("csrw mideleg, %0" : : "r" (x));
}

// Supervisor Trap Vector Base Address, stvec
static inline void w_stvec(uint64 x) {
  asm volatile("csrw stvec, %0" : : "r" (x));
}

// Machine-mode Counter-Enable, mcounteren
static inline uint64 r_mcounteren() {
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
  return x;
}
static inline void w_mcounteren(uint64 x) {
  asm volatile("csrw mcounteren, %0" : : "r" (x));
}

// Machine Environment Configuration Register, menvcfg
static inline uint64 r_menvcfg()
{
  uint64 x;
  asm volatile("csrr %0, 0x30a" : "=r" (x) ); // CSR 0x30a is menvcfg
  return x;
}
static inline void w_menvcfg(uint64 x)
{
  asm volatile("csrw 0x30a, %0" : : "r" (x)); // CSR 0x30a is menvcfg
}


// Physical Memory Protection Registers
static inline void w_pmpaddr0(uint64 x) {
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
}
static inline void w_pmpcfg0(uint64 x) {
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
}

// Supervisor Address Translation and Protection Register, satp
#define SATP_SV39 (8L << 60)
#define MAKE_SATP(pagetable) (SATP_SV39 | (((uint64)pagetable) >> 12))

static inline void w_satp(uint64 x) {
  asm volatile("csrw satp, %0" : : "r" (x));
}

// Supervisor Cause Register, scause
static inline uint64 r_scause() {
  uint64 x;
  asm volatile("csrr %0, scause" : "=r" (x) );
  return x;
}

// Supervisor Exception Program Counter, sepc
static inline uint64 r_sepc() {
  uint64 x;
  asm volatile("csrr %0, sepc" : "=r" (x) );
  return x;
}


// --- Timer Registers ---
static inline uint64 r_time() {
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
  return x;
}
// This is actually an M-mode CSR, but S-mode can be granted access.
// We write to it via an SBI call in xv6, but for simplicity,
// we'll try direct access after enabling it.
// The standard CSR for supervisor timer is stimecmp, but QEMU's CLINT model
// uses M-mode timer, which S-mode controls via SBI or direct CSR access
// if mdelegated and enabled.
static inline void w_stimecmp(uint64 x) {
  // This is a special case for QEMU's CLINT. S-mode writes to a memory-mapped
  // register, but xv6's approach sets up an M-mode handler that S-mode triggers
  // via SBI call. A simpler model is to delegate M-timer interrupt to S-mode
  // and let S-mode set the M-mode timer's compare register, which requires
  // access enabled. In QEMU, supervisor can write mtimecmp (part of CLINT).
  // For simplicity, we assume we're directly setting the next M-level interrupt time.
  // The SBI call `sbi_set_timer` is the "official" way.
  // We're doing what xv6's M-mode `timerinit` does.
  // Direct access to mtimecmp is usually memory-mapped, not a CSR.
  // The CSR being set is actually the *supervisor's* view of the timer compare.
  // Let's stick to the CSR that xv6's M-mode code writes to for S-mode.
  // xv6 uses an SBI call, but its M-mode `timerinit` writes to mtimecmp memory-mapped.
  // The `w_stimecmp` here might be misleading. Let's assume SBI is abstracted.
  // For our simplified model, we will assume M-mode setup allows S-mode
  // to directly request a timer interrupt by writing to a CSR.
  // Let's use the CSR number for `stimecmp` just in case, it's 0x14D.
  // Actually, xv6's `w_stimecmp` in riscv.h writes to CSR 0x14d, so let's use that.
  asm volatile("csrw 0x14d, %0" : : "r" (x));
}

// --- Thread Pointer Register (tp) ---
static inline uint64 r_tp() {
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
  return x;
}
static inline void w_tp(uint64 x) {
  asm volatile("mv tp, %0" : : "r" (x));
}

// --- Interrupt Control ---
static inline void intr_on() {
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}
static inline void intr_off() {
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}
static inline int intr_get() {
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
}

// --- Paging-related Definitions ---
#define PGSIZE 4096
#define PGSHIFT 12
#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

#define PTE_V (1L << 0)
#define PTE_R (1L << 1)
#define PTE_W (1L << 2)
#define PTE_X (1L << 3)
#define PTE_U (1L << 4)

#define PA2PTE(pa) ((((uint64)pa) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)

#define PXMASK 0x1FF
#define PX(level, va) ((((uint64)(va)) >> (PGSHIFT + 9 * (level))) & PXMASK)

static inline void sfence_vma() {
  asm volatile("sfence.vma zero, zero");
}

typedef uint64 pte_t;
typedef uint64 *pagetable_t;

#endif // __RISCV_H__