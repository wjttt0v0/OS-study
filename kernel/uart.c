// The base address of the NS16550A UART registers.
// In a larger OS, this would typically be in a separate "memlayout.h" file.
#define UART0 0x10000000L

// This macro calculates the memory-mapped address of a UART register.
// It takes an offset (like THR, RHR, etc.) and returns a pointer of
// the correct type. 'volatile' is crucial to prevent the compiler from
// optimizing away register reads/writes, ensuring we always access the
// hardware directly.
#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))

// UART register offsets, as defined by the NS16550A specification.
// Note: RHR and THR share the same offset but are read-only and write-only respectively.
#define RHR 0  // Receive Holding Register (read-only)
#define THR 0  // Transmit Holding Register (write-only)
#define IER 1  // Interrupt Enable Register
#define FCR 2  // FIFO Control Register (write-only)
#define ISR 2  // Interrupt Status Register (read-only)
#define LCR 3  // Line Control Register
#define LSR 5  // Line Status Register

// Bits in the Line Status Register (LSR).
// These bits report the current status of the UART.
#define LSR_RX_READY (1 << 0) // Data is waiting in the Receive Holding Register.
#define LSR_TX_IDLE  (1 << 5) // The Transmit Holding Register is empty and ready for a new character.

// A helper macro to read a value from a given register.
#define ReadReg(reg) (*(Reg(reg)))

// A helper macro to write a value to a given register.
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void uartputc(char c) {
  // Wait until the transmit holding register is empty.
  // We do this by continuously polling (checking) the TX_IDLE bit
  // in the Line Status Register. The loop continues as long as the
  // bit is 0 (not idle).
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ; // Spin until ready

  // Once the transmitter is ready, write the character to the
  // Transmit Holding Register (THR). The UART hardware will then
  // take care of sending it out serially.
  WriteReg(THR, c);
}

void uartputs(const char *s) {
  while (*s)
    uartputc(*s++);
}