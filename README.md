# Minimal RISC-V OS for Operating System Practice

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/your-username/your-repo)
[![Platform](https://img.shields.io/badge/platform-QEMU%20RISC--V-orange)](https://www.qemu.org/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

## 1. 项目简介

本项目是一个为**《操作系统实践》**课程设计的、极简的64位RISC-V操作系统内核。项目的核心目标是**从零开始，理解并实现操作系统最核心的引导流程（Bootstrapping）**。

通过参考经典教学操作系统 xv6-riscv 的设计思想，我们动手编写了从汇编入口、BSS段清零、栈指针设置，到C语言环境搭建和串口驱动的全部代码，最终在QEMU RISC-V `virt` 模拟器上成功打印出 "Hello OS!"。

这个过程帮助我们深入理解了计算机加电后，CPU是如何执行第一行指令，以及操作系统是如何在“裸机”之上建立起最基本的运行环境的。

**核心特性：**
*   **平台**: RISC-V (RV64GC)
*   **目标机器**: QEMU `virt` machine
*   **功能**: 引导启动并通过UART串口输出 "Hello OS!"
*   **代码风格**: 简洁、注释详尽，关键部分的设计思路参考了xv6

> **开发者**: [你的姓名]
> **学号**: [你的学号]
> **课程**: [你的课程全名，例如：操作系统实践A (2025-2026)]

## 2. 环境搭建

本项目在Linux环境下开发，需要RISC-V交叉编译工具链和QEMU模拟器。

### 2.1. 依赖安装 (以Ubuntu/Debian为例)
```bash
sudo apt-get update
sudo apt-get install -y build-essential git gcc-riscv64-unknown-elf qemu-system-misc
```

### 2.2. 验证环境
确保交叉编译器和QEMU已正确安装：
```bash
# 检查GCC版本
riscv64-unknown-elf-gcc --version

# 检查QEMU版本
qemu-system-riscv64 --version
```

## 3. 项目结构

项目文件组织清晰，职责分明：

```
.
├── kernel
│   ├── entry.S        # 汇编入口：设置栈、清零BSS、跳转到C
│   ├── kernel.ld      # 链接脚本：定义内存布局和程序入口
│   ├── main.c         # C语言主函数：内核的主逻辑
│   └── uart.c         # 串口驱动：实现向UART硬件写入字符的功能
├── Makefile         # 构建脚本：自动化编译、链接和运行流程
└── README.md        # 项目说明文档
```

## 4. 构建与运行

本项目使用`make`进行自动化管理。

### 4.1. 编译内核
在项目根目录执行：
```bash
make
```
或者
```bash
make all
```
此命令会编译所有源文件，并将它们链接成一个位于`kernel/`目录下的可执行文件`kernel.elf`。

### 4.2. 在QEMU中运行
执行以下命令来启动QEMU并运行我们的内核：
```bash
make qemu
```
如果一切顺利，你将会在终端看到QEMU启动，并打印出：
```
Hello OS from xv6-style minimal kernel!
```
程序将在此处挂起。按 `Ctrl+A` 然后按 `X` 即可退出QEMU。

### 4.3. 清理构建文件
执行以下命令可以删除所有编译生成的文件：
```bash
make clean
```

### 4.4. 调试 (使用GDB)
本项目支持使用GDB进行源码级调试。
1.  **启动QEMU并等待GDB连接**:
    ```bash
    make qemu-gdb
    ```
    这个终端将会挂起，等待GDB连接。

2.  **打开一个新的终端，启动GDB**:
    ```bash
    riscv64-unknown-elf-gdb kernel/kernel.elf
    ```

3.  **在GDB中连接到QEMU**:
    在GDB的 `(gdb)` 提示符下输入：
    ```gdb
    target remote :1234
    ```

现在你就可以使用GDB的全部功能（如设置断点`b main`，单步执行`si`或`next`，打印变量`p var`）来调试你的内核了。

## 5. 核心设计解析

### 5.1. 启动流程

1.  **QEMU** 将 `kernel.elf` 加载到物理地址 `0x80000000`。
2.  **`entry.S`** 作为入口点开始执行：
    a. **设置栈指针 (`sp`)**: 将`sp`指向`kernel.ld`中定义的栈顶，为C函数调用做准备。
    b. **清零BSS段**: 找到链接器提供的`sbss`和`ebss`符号，用循环将这块内存区域全部置零，确保C语言环境的正确性。
    c. **跳转到C**: 使用`call`指令跳转到`main`函数。
3.  **`main.c`** 调用`uart.c`中的函数，通过串口输出字符串。
4.  执行完毕后，返回到`entry.S`中的`spin`标签，CPU进入无限循环，系统安全停机。

### 5.2. 内存布局

由`kernel.ld`定义，结构如下：
*   **代码段 (`.text`)**: 存放所有编译后的机器指令。
*   **只读数据段 (`.rodata`)**: 存放常量字符串等。
*   **数据段 (`.data` & `.bss`)**: 存放全局和静态变量。
*   **内核栈**: 在所有程序数据之后，静态分配一块16KB的内存作为内核栈。

## 6. 学习总结

通过这个项目，我深刻体会到了：
*   **计算机的启动原理**：明白了CPU是如何在没有操作系统的“裸机”上执行第一行指令的。
*   **C语言运行环境的构建**：理解了栈的初始化和BSS段清零对于C代码正确运行的必要性。
*   **硬件与软件的交互**：学会了通过读写内存映射的寄存器来控制硬件设备（UART）。
*   **交叉编译和链接**：掌握了使用`Makefile`和链接脚本来构建一个独立于宿主机的可执行程序。

这个项目为后续学习更复杂的操作系统概念（如中断、内存管理、多任务调度）打下了坚实的基础。

---
