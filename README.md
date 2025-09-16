# 极简RISC-V操作系统内核

本项目是一个为操作系统课程实践设计的最小化RISC-V内核。

## 环境要求

*   **操作系统**: Linux (推荐 Ubuntu/Debian)
*   **交叉编译器**: `gcc-riscv64-unknown-elf`
*   **模拟器**: `qemu-system-misc`

## 编译与运行说明

本项目使用`Makefile`进行全自动化的构建和管理。请在项目根目录下执行以下命令。

### 1. 编译内核

要编译所有源代码并链接生成最终的内核可执行文件 `kernel/kernel.elf`，请运行：
```bash
make
```

### 2. 启动QEMU并运行内核

编译成功后，使用以下命令即可在QEMU模拟器中启动并运行你的操作系统：
```bash
make qemu
```

**预期输出：**
终端将会显示QEMU启动，并成功打印出以下信息：
```
Hello OS from xv6-style minimal kernel!
```
程序将在此处挂起。若要退出QEMU，请按组合键 **`Ctrl+A`**，然后按 **`X`**。

### 3. 清理构建产物

如果你想删除所有编译生成的文件（`.o` 文件和 `.elf` 文件），恢复项目至干净状态，请运行：
```bash
make clean
```

### 4. 使用GDB进行调试

本项目已配置好GDB调试支持。

**第一步：在一个终端中，启动QEMU并使其暂停，等待GDB连接。**```bash
make qemu-gdb
```

**第二步：打开一个新的终端，启动GDB客户端并加载内核符号。**
```bash
riscv64-unknown-elf-gdb kernel/kernel.elf```

**第三步：在GDB提示符 `(gdb)` 下，连接到QEMU。**```gdb
target remote :1234
```
连接成功后，你就可以使用GDB进行源码级调试了。
