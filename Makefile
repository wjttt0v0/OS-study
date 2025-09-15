# Makefile (Final Debugged Version)

# Set the default shell
SHELL := /bin/bash

# Toolchain definitions
TOOLCHAIN_PREFIX := riscv64-unknown-elf-
CC := $(TOOLCHAIN_PREFIX)gcc
LD := $(TOOLCHAIN_PREFIX)ld

# Compiler and Linker Flags
CFLAGS := -Wall -Werror -O0 -g -nostdlib -ffreestanding -mcmodel=medany
LDFLAGS := -T kernel/kernel.ld

# --- MODIFICATION START ---
# Explicitly list all object files instead of using wildcard functions.
# This is a more robust way to define sources.
OBJS := \
    kernel/entry.o \
    kernel/main.o \
    kernel/uart.o
# --- MODIFICATION END ---


# The final kernel ELF file
KERNEL_ELF := kernel.elf

# Default target: build the kernel
all: $(KERNEL_ELF)

# Linker rule
$(KERNEL_ELF): $(OBJS)
	@echo "LD $(KERNEL_ELF)"
	@$(LD) -o $(KERNEL_ELF) $(OBJS) $(LDFLAGS)

# Compilation rule for .c files
kernel/%.o: kernel/%.c
	@echo "CC $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Compilation rule for .S assembly files
kernel/%.o: kernel/%.S
	@echo "AS $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Clean up build artifacts
clean:
	@echo "CLEAN"
	@rm -f kernel/*.o $(KERNEL_ELF)

# QEMU command and options
QEMU := qemu-system-riscv64
QEMUOPTS := -machine virt -bios none \
            -kernel $(KERNEL_ELF) \
            -m 128M -nographic

# Target to run the kernel in QEMU
qemu: all
	@echo "Starting QEMU..."
	@$(QEMU) $(QEMUOPTS)

# Target to run QEMU in debugging mode
qemu-gdb: all
	@echo "Starting QEMU for GDB..."
	@$(QEMU) $(QEMUOPTS) -S -s

.PHONY: all clean qemu qemu-gdb
