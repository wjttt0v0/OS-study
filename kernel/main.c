#include "types.h"
#include "defs.h"

// 测试1：基础格式化功能
void test_printf_basic() {
    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xABC);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
}

// 测试2：边界条件与鲁棒性
void test_printf_edge_cases() {
    printf("INT_MAX: %d\n", 2147483647);
    // 测试最小负数，验证补码溢出处理
    printf("INT_MIN: %d\n", -2147483648); 
    // 测试空指针，验证系统是否崩溃
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
}

// 测试3：视觉特效 (光标与颜色)
void test_visual_features() {
    clear_screen();
    
    // 在屏幕中央打印彩色标题
    goto_xy(10, 5);
    printf_color(RED, "=== Kernel Visual Test ===\n");
    
    goto_xy(10, 7);
    printf("Color Palette:\n");
    
    goto_xy(12, 8);
    printf_color(GREEN, "[SUCCESS] System Initialized\n");
    
    goto_xy(12, 9);
    printf_color(BLUE, "[INFO]    Loading modules...\n");
    
    goto_xy(12, 10);
    printf_color(MAGENTA, "[DEBUG]   Memory check: OK\n");
    
    // 恢复光标到下方，避免覆盖
    goto_xy(1, 15);
}

void main(void) {
    consoleinit();
    
    printf("\n--- Phase 2: Visual Features ---\n");
    test_visual_features();

    printf("--- Phase 1: Basic & Edge Cases ---\n");
    test_printf_basic();
    test_printf_edge_cases();
}