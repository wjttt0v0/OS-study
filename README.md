# RISC-V OS for study

这是一个基于 RISC-V 64位架构的用于个人学习的操作系统内核项目。

## 🛠 开发环境依赖

在 Ubuntu 20.04/22.04 下，请安装以下工具链和模拟器：

```bash
sudo apt-get update
sudo apt-get install -y build-essential git qemu-system-misc gcc-riscv64-unknown-elf gdb-multiarch
```

## 🚀 编译与运行指令

本项目使用 Makefile 进行自动化构建。

### 1. 编译并启动 (默认方式)
编译代码并自动启动 QEMU 模拟器：
```bash
make qemu
```
> **退出 QEMU 的方法**：先按 `Ctrl+A`，松开后快速按 `X`。

好的，这是更新后的调试模式部分，增加了具体的操作步骤，更加清晰易懂：

### 2. 调试模式
此模式用于通过 GDB 跟踪内核执行流程。请按照以下步骤操作：

**步骤 1：启动调试服务器**
在一个终端窗口中运行：
```bash
make qemu-gdb
```
此时 QEMU 会启动并暂停执行，等待 GDB 连接（默认监听 1234 端口）。

**步骤 2：连接 GDB**
打开**另一个**终端窗口，加载内核符号文件并启动 GDB：
```bash
riscv64-unknown-elf-gdb kernel/kernel.elf
```

**步骤 3：调试指令**
进入 GDB 交互界面后，输入以下指令连接并开始调试：
```gdb
(gdb) target remote :1234    # 连接到 QEMU
(gdb) b main                 # 在 main 函数设置断点（仅作示例）
(gdb) c                      # 继续执行 (Continue)
```

### 3. 清理构建
删除所有生成文件和内核镜像：
```bash
make clean
```