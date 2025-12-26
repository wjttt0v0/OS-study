#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h" // Needed for O_RDWR, O_CREATE

uint64 get_time() {
    return uptime(); 
}

// --- Test 1: Basic Functionality ---
void test_basic_syscalls(void) {
    printf("Testing basic system calls...\n");

    // Test getpid
    int pid = getpid();
    printf("Current PID: %d\n", pid);

    // Test fork
    int child_pid = fork();
    if (child_pid == 0) {
        // Child process
        printf("Child process: PID=%d\n", getpid());
        exit(42); // Exit with status 42
    }
    else if (child_pid > 0) {
        // Parent process
        int status;
        wait(&status); // Wait for child
        printf("Child exited with status: %d\n", status);
        if(status != 42){
            printf("[FAIL] Child exit status incorrect.\n");
        } else {
             printf("[PASS] Basic syscalls test passed.\n");
        }
    }
    else {
        printf("Fork failed!\n");
    }
    printf("\n");
}

// --- Test 2: Parameter Passing ---
void test_parameter_passing(void) {
    printf("Testing parameter passing...\n");
    
    // Test writing to console
    char buffer[] = "Hello, World!\n";
    // Assuming file descriptor 1 is stdout/console
    int fd = 1; 
    
    // Attempt to open console (optional, depends on your FS setup)
    int console_fd = open("console", O_RDWR);
    if(console_fd >= 0){
        fd = console_fd;
    }

    if (fd >= 0) {
        int bytes_written = write(fd, buffer, strlen(buffer));
        printf("Wrote %d bytes\n", bytes_written);
        if(bytes_written != strlen(buffer)) {
             printf("[FAIL] Write count mismatch.\n");
        }
        if(console_fd >= 0) close(console_fd);
    }

    // Test edge cases
    printf("Testing edge cases:\n");
    
    // Invalid file descriptor
    if(write(-1, buffer, 10) != -1) {
         printf("[FAIL] write to fd -1 should fail.\n");
    } else {
         printf("[PASS] write to fd -1 failed as expected.\n");
    }

    // NULL pointer
    if(write(fd, (char*)0, 10) != -1) {
         printf("[FAIL] write with NULL buffer should fail.\n");
    } else {
         printf("[PASS] write with NULL buffer failed as expected.\n");
    }

    // Negative length (size_t is unsigned, so this becomes a huge number)
    if(write(fd, buffer, -1) != -1) {
         printf("[FAIL] write with negative length should fail.\n");
    } else {
         printf("[PASS] write with negative length failed as expected.\n");
    }
    printf("\n");
}

// --- Test 3: Security ---
void test_security(void) {
    printf("Testing security...\n");

    char *invalid_ptr = (char*)0x10000000; 
    
    printf("Attempting write from invalid pointer %p...\n", invalid_ptr);
    
    int result = write(1, invalid_ptr, 10);
    printf("Invalid pointer write result: %d\n", result);
    
    if (result > 0) {
        printf("[FAIL] Security check failed: Kernel allowed write from invalid pointer.\n");
    } else {
        printf("[PASS] Kernel correctly rejected invalid pointer (ret=%d).\n", result);
    }

    printf("\n");
}

// --- Test 4: Performance ---
void test_syscall_performance(void) {
    printf("Testing syscall performance...\n");
    
    uint start_time = get_time();

    // Loop a simple syscall
    for (int i = 0; i < 10000; i++) {
        getpid(); 
    }

    uint end_time = get_time();
    
    // Note: uptime() returns ticks, not CPU cycles. 
    // So the granularity might be coarse.
    printf("10000 getpid() calls took %d ticks\n", end_time - start_time);
    printf("\n");
}

int main(int argc, char *argv[]) {
    printf("===== System Call Lab Test Suite =====\n\n");

    test_basic_syscalls();
    test_parameter_passing();
    test_security();
    test_syscall_performance();

    printf("===== All Tests Completed =====\n");
    exit(0);
}