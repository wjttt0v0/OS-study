# ================================================================
# Toolchain
# ================================================================
TOOLPREFIX = riscv64-unknown-elf-

CC      = $(TOOLPREFIX)gcc
LD      = $(TOOLPREFIX)ld
AS      = $(TOOLPREFIX)as
OBJDUMP = $(TOOLPREFIX)objdump
OBJCOPY = $(TOOLPREFIX)objcopy

# ================================================================
# Flags
# ================================================================
COMMON_FLAGS = -march=rv64gc -ffreestanding -nostdlib -mcmodel=medany \
               -fno-omit-frame-pointer -ggdb -gdwarf-2

CFLAGS = -Wall -Werror -Wno-unknown-attributes -O0 \
         -MD $(COMMON_FLAGS) \
         -I.

KERNEL_LDFLAGS = -T $(K)/kernel.ld -z max-page-size=4096
USER_LDFLAGS   = -T $(U)/user.ld   -z max-page-size=4096

# ================================================================
# Kernel Build
# ================================================================
K = kernel

KOBJS = \
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
    $(K)/sysfile.o \
    $(K)/ipc.o

KERNEL_ELF = $(K)/kernel.elf

$(KERNEL_ELF): $(KOBJS)
	$(LD) $(KERNEL_LDFLAGS) -o $(KERNEL_ELF) $(KOBJS)
	$(OBJDUMP) -S $(KERNEL_ELF) > $(KERNEL_ELF).asm
	$(OBJDUMP) -t $(KERNEL_ELF) | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(KERNEL_ELF).sym

$(K)/%.o: $(K)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(K)/%.o: $(K)/%.S
	$(CC) -march=rv64gc -g -c -o $@ $<

# ================================================================
# User Build
# ================================================================
U = user

ULIBS = \
    $(U)/ulib.o \
    $(U)/printf.o \
    $(U)/umalloc.o \
    $(U)/usys.o

UPROGS = \
    $(U)/_init \
    $(U)/_test

$(U)/usys.S: $(U)/usys.pl
	perl $(U)/usys.pl > $(U)/usys.S

$(U)/usys.o: $(U)/usys.S
	$(CC) $(CFLAGS) -c -o $@ $<

$(U)/%.o: $(U)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(U)/_%: $(U)/%.o $(ULIBS)
	$(LD) $(USER_LDFLAGS) -o $@ $< $(ULIBS)
	$(OBJDUMP) -S $@ > $@.asm

# ================================================================
# mkfs
# ================================================================
mkfs/mkfs: mkfs/mkfs.c $(K)/fs.h $(K)/param.h
	gcc -Wno-unknown-attributes -I. -o mkfs/mkfs mkfs/mkfs.c

# ================================================================
# File System Image
# ================================================================
fs.img: mkfs/mkfs $(UPROGS)
	mkfs/mkfs fs.img $(UPROGS)

# ================================================================
# QEMU
# ================================================================
CPUS := 1
QEMU := qemu-system-riscv64

QEMUOPTS := -machine virt -bios none -kernel $K/kernel.elf -m 128M -smp $(CPUS) -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

all: $(KERNEL_ELF) fs.img

qemu: all
	@echo "Starting QEMU..."
	$(QEMU) $(QEMUOPTS)

qemu-gdb: all
	@echo "Starting QEMU (GDB)..."
	$(QEMU) $(QEMUOPTS) -S -s
# ================================================================
# Clean
# ================================================================
clean:
	rm -f $(K)/*.o $(K)/*.d $(K)/*.asm $(K)/*.sym $(K)/kernel
	rm -f $(U)/*.o $(U)/*.d $(U)/*.asm $(U)/_*
	rm -f mkfs/mkfs fs.img
	rm -f $(U)/usys.S

-include $(K)/*.d $(U)/*.d

.PHONY: all qemu qemu-gdb clean