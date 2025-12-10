K=kernel

OBJS := \
    $K/entry.o \
    $K/main.o \
    $K/uart.o 


TOOLCHAIN_PREFIX := riscv64-unknown-elf-
CC := $(TOOLCHAIN_PREFIX)gcc
LD := $(TOOLCHAIN_PREFIX)ld

CFLAGS := -Wall -Werror -O0 -g -Wno-main \
          -ffreestanding -nostdlib -I. \
          -fno-common -fno-omit-frame-pointer -mcmodel=medany \
          $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
LDFLAGS := -T $K/kernel.ld


KERNEL := $K/kernel.elf

$(KERNEL): $(OBJS) $K/kernel.ld
	@$(LD) $(LDFLAGS) -o $@ $(OBJS)


$K/%.o: $K/%.c
	@$(CC) $(CFLAGS) -c -o $@ $<

$K/%.o: $K/%.S
	@$(CC) $(CFLAGS) -c -o $@ $<


clean:
	@echo "CLEAN"
	@rm -f $K/*.o  $K/*.d $(KERNEL)


QEMU := qemu-system-riscv64
QEMUOPTS := -machine virt -bios none -kernel $(KERNEL) -m 128M -nographic

qemu: $(KERNEL)
	@echo "Starting QEMU..."
	@$(QEMU) $(QEMUOPTS)

qemu-gdb: $(KERNEL)
	@echo "Starting QEMU for GDB..."
	@$(QEMU) $(QEMUOPTS) -S -s

.PHONY: clean qemu qemu-gdb