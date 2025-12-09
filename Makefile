#
# Simplified xv6-riscv Makefile
#

# --- Toolchain ---
TOOLCHAIN_PREFIX := riscv64-unknown-elf-
CC := $(TOOLCHAIN_PREFIX)gcc
LD := $(TOOLCHAIN_PREFIX)ld
OBJDUMP := $(TOOLCHAIN_PREFIX)objdump

# --- Compiler Flags ---
CFLAGS := -Wall -Werror -O -g -nostdlib -ffreestanding -fno-common -I. -Ikernel
CFLAGS += -mcmodel=medany -fno-omit-frame-pointer
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

# --- QEMU ---
ifndef CPUS
CPUS := 1
endif

QEMU := qemu-system-riscv64
QEMUOPTS := -machine virt -bios none -kernel $K/kernel -m 128M -smp $(CPUS) -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

# ====================================================================
# Kernel Build
# ====================================================================

K = kernel

OBJS := \
    $(K)/entry.o \
    $(K)/start.o \
    $(K)/main.o \
    $(K)/uart.o \
    $(K)/printf.o \
    $(K)/console.o \
    $(K)/kalloc.o \
    $(K)/string.o \
    $(K)/vm.o \
    $(K)/trap.o \
    $(K)/kernelvec.o \
    $(K)/swtch.o \
    $(K)/trampoline.o \
    $(K)/spinlock.o \
    $(K)/sleeplock.o \
    $(K)/proc.o \
    $(K)/syscall.o \
    $(K)/sysproc.o \
    $(K)/exec.o \
    $(K)/plic.o \
    $(K)/virtio_disk.o \
    $(K)/bio.o \
    $(K)/fs.o \
    $(K)/log.o \
    $(K)/file.o \
    $(K)/pipe.o \
    $(K)/sysfile.o

KERNEL_ELF = $(K)/kernel.elf
LDFLAGS := -T $(K)/kernel.ld

$(KERNEL_ELF): $(OBJS) $(K)/kernel.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

$(K)/%.o: $(K)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(K)/%.o: $(K)/%.S
	$(CC) $(CFLAGS) -c -o $@ $<

# ====================================================================
# User Space Build
# ====================================================================

U = user

UPROGS = \
    $(U)/_init \
    $(U)/_test

ULIBS = \
    $(U)/ulib.o \
    $(U)/printf.o \
    $(U)/umalloc.o \
    $(U)/usys.o

$(U)/usys.S: $(U)/usys.pl $(K)/syscall.h
	perl $< > $@

$(U)/%.o: $(U)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(U)/usys.o: $(U)/usys.S
	$(CC) $(CFLAGS) -c -o $@ $<

$(U)/_%: $(U)/%.o $(ULIBS)
	$(LD) -N -e main -T $(U)/user.ld -o $@ $^
	$(OBJDUMP) -S $@ > $@.asm

# ====================================================================
# mkfs (host build)
# ====================================================================

MKFS_EXEC = mkfs/mkfs

HOST_CC := gcc

HOST_CFLAGS = -Wall -Werror -I.

$(MKFS_EXEC): mkfs/mkfs.c $(K)/fs.h $(K)/param.h
	# CRITICAL FIX: Ensure $(HOST_CC) is at the beginning of the command.
	$(HOST_CC) $(HOST_CFLAGS) -o $@ mkfs/mkfs.c

# ====================================================================
# File System Image
# ====================================================================

fs.img: $(MKFS_EXEC) $(UPROGS)
	# This command will now work because $(MKFS_EXEC) will be correctly built.
	./$(MKFS_EXEC) fs.img $(UPROGS)

# ====================================================================
# Top-level Targets
# ====================================================================

all: $(KERNEL_ELF) $(UPROGS) $(MKFS) fs.img

qemu: all
	@echo "Starting QEMU..."
	$(QEMU) $(QEMUOPTS) -kernel $(KERNEL_ELF)

qemu-gdb: all
	@echo "Starting QEMU (GDB)..."
	$(QEMU) $(QEMUOPTS) -kernel $(KERNEL_ELF) -S -s


# ====================================================================
# Clean Target
# ====================================================================
clean:
	@echo "Cleaning project..."
	rm -f $(K)/*.o $(K)/*.d $(KERNEL_ELF) \
	  initcode initcode.o initcode.out \
	  user/*.o user/*.d user/*.asm user/usys.S \
	  user/_* \
	  fs.img \
	  $(MKFS_EXEC)

.PHONY: all qemu qemu-gdb clean