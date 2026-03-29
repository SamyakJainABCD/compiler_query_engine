#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * RISKY C CODE - Buffer Overflow Examples
 * This file contains multiple buffer overflow vulnerabilities
 * Use it to test the buffer overflow detection system
 */

// ============================================================================
// RISK 1: strcpy - Unbounded Copy (CRITICAL)
// ============================================================================
void vulnerable_strcpy(char *user_input) {
    char buffer[32];
    strcpy(buffer, user_input);  // DANGER: No bounds checking!
    printf("Copied: %s\n", buffer);
}

// ============================================================================
// RISK 2: strcat - Unbounded Concatenation (HIGH)
// ============================================================================
void vulnerable_strcat(const char *name, const char *surname) {
    char fullname[20];
    strcpy(fullname, name);        // First copy
    strcat(fullname, " ");         // Add space
    strcat(fullname, surname);     // DANGER: Can overflow if strings are long
    printf("Full Name: %s\n", fullname);
}

// ============================================================================
// RISK 3: sprintf - Unbounded Format (HIGH)
// ============================================================================
void vulnerable_sprintf(const char *data, int value) {
    char output[50];
    sprintf(output, "Data: %s, Value: %d", data, value);  // DANGER: No size limit
    printf("%s\n", output);
}

// ============================================================================
// RISK 4: scanf - No Width Specification (HIGH)  
// ============================================================================
void vulnerable_scanf() {
    char username[16];
    printf("Enter username: ");
    scanf("%s", username);  // DANGER: Can read more than 16 characters
    printf("Username: %s\n", username);
}

// ============================================================================
// RISK 5: Multiple Overflows
// ============================================================================
void process_user_data(const char *input1, const char *input2) {
    char buffer1[20];
    char buffer2[20];
    
    strcpy(buffer1, input1);  // DANGER #1
    strcpy(buffer2, input2);  // DANGER #2
    
    char combined[30];
    sprintf(combined, "%s-%s", buffer1, buffer2);  // DANGER #3
    
    printf("Result: %s\n", combined);
}

// ============================================================================
// RISK 6: gets - Most Dangerous (CRITICAL)
// Note: gets() is deprecated and unavailable in modern C
// Simulated here, but scanner can detect if it appears
// ============================================================================
// void read_password() {
//     char password[8];
//     gets(password);  // EXTREME DANGER: Reads unlimited input
//     printf("Password stored\n");
// }

// ============================================================================
// RISK 7: sscanf - String Input Without Limits (HIGH)
// ============================================================================
void parse_config(const char *config_line) {
    char key[30];
    char value[30];
    sscanf(config_line, "%s = %s", key, value);  // DANGER: No limits
    printf("Key: %s, Value: %s\n", key, value);
}

// ============================================================================
// RISK 8: strncpy with Issues (MEDIUM)
// ============================================================================
void risky_strncpy_usage(const char *source) {
    char dest[16];
    strncpy(dest, source, 20);  // DANGER: size > buffer size
    // Also: strncpy doesn't null-terminate if truncated
    printf("Copied: %s\n", dest);
}

// ============================================================================
// RISK 9: Buffer in Function Stack
// ============================================================================
void process_network_data(const char *packet) {
    char local_buffer[64];
    strcpy(local_buffer, packet);  // DANGER: Overflow not caught until runtime
    
    // Process packet
    for (int i = 0; i < strlen(local_buffer); i++) {
        printf("%02X ", (unsigned char)local_buffer[i]);
    }
    printf("\n");
}

// ============================================================================
// RISK 10: Global Buffer Overflow
// ============================================================================
char global_buffer[40];

void fill_global_buffer(const char *data) {
    strcpy(global_buffer, data);  // DANGER: Global buffer overflow
    printf("Global: %s\n", global_buffer);
}

// ============================================================================
// RISK 11: Multiple String Operations (HIGH)
// ============================================================================
void build_query(const char *table, const char *condition) {
    char query[100];
    sprintf(query, "SELECT * FROM %s WHERE %s", table, condition);
    // DANGER: If table and condition are large, can overflow
    printf("Query: %s\n", query);
}

// ============================================================================
// RISK 12: Fixed Buffer with Loop Write
// ============================================================================
void copy_array_unsafe(int *source, int count) {
    int dest[10];  // Small fixed buffer
    for (int i = 0; i < count; i++) {
        dest[i] = source[i];  // DANGER: No bounds check on count
    }
    printf("Copied %d elements\n", count);
}

// ============================================================================
// RISK 13: String Operations Chain
// ============================================================================
void build_file_path(const char *dir, const char *filename) {
    char path[64];
    strcpy(path, dir);
    strcat(path, "/");
    strcat(path, filename);  // DANGER: Multiple operations can overflow
    printf("Path: %s\n", path);
}

// ============================================================================
// RISK 14: Format String in sprintf
// ============================================================================
void dangerous_format_output(const char *user_format) {
    char buffer[256];
    sprintf(buffer, "User input: %s", user_format);
    // DANGER: User format could contain format specifiers
    printf("%s\n", buffer);
}

// ============================================================================
// RISK 15: Partial mitigation (still risky)
// ============================================================================
void partially_safe_copy(const char *source) {
    char dest[32];
    strncpy(dest, source, sizeof(dest));
    // ISSUE: strncpy doesn't guarantee null termination
    dest[sizeof(dest) - 1] = '\0';  // Partial fix
    printf("Copied: %s\n", dest);
}

// ============================================================================
// Main Test function
// ============================================================================
int main(int argc, char *argv[]) {
    printf("========================================\n");
    printf("Vulnerable C Code - Buffer Overflow Test\n");
    printf("========================================\n\n");
    
    // Test each vulnerability
    printf("Test 1: strcpy\n");
    vulnerable_strcpy("This is a test");
    
    printf("\nTest 2: strcat\n");
    vulnerable_strcat("John", "Doe");
    
    printf("\nTest 3: sprintf\n");
    vulnerable_sprintf("test data", 42);
    
    printf("\nTest 4: scanf\n");
    // vulnerable_scanf();  // Commented out - interactive
    printf("(Skipped - requires input)\n");
    
    printf("\nTest 5: Multiple overflows\n");
    process_user_data("Data1", "Data2");
    
    printf("\nTest 7: sscanf\n");
    parse_config("key = value");
    
    printf("\nTest 8: strncpy issues\n");
    risky_strncpy_usage("test");
    
    printf("\nTest 9: Network data\n");
    process_network_data("\x01\x02\x03");
    
    printf("\nTest 10: Global buffer\n");
    fill_global_buffer("global data");
    
    printf("\nTest 11: Query building\n");
    build_query("users", "id = 1");
    
    printf("\nTest 13: File path\n");
    build_file_path("/home/user", "file.txt");
    
    printf("\nTest 15: Partial mitigation\n");
    partially_safe_copy("partial test");
    
    printf("\n========================================\n");
    printf("Tests completed\n");
    printf("========================================\n");
    
    return 0;
}
