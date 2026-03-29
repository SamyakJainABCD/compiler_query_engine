#include <stdio.h>
#include <string.h>

// Example 1: strcpy vulnerability
void copy_name(char *dest) {
    char buffer[10];
    strcpy(buffer, dest);  // DANGER: unbounded string copy
    printf("%s\n", buffer);
}

// Example 2: sprintf vulnerability  
void format_string(char *input) {
    char result[20];
    sprintf(result, "User: %s", input);  // DANGER: unchecked format
    printf("%s\n", result);
}

// Example 3: fscanf vulnerability
void read_from_file(FILE *fp) {
    char buffer[16];
    fscanf(fp, "%s", buffer);  // DANGER: no width specification
    printf("Data: %s\n", buffer);
}

// Example 4: scanf vulnerability
void process_data() {
    char name[15];
    scanf("%s", name);  // DANGER: no width specification
    printf("Name: %s\n", name);
}

// Example 5: strcat vulnerability
void append_string(char *user_data) {
    char buffer[32];
    strcpy(buffer, "Hello ");
    strcat(buffer, user_data);  // DANGER: no length checking
    printf("%s\n", buffer);
}
