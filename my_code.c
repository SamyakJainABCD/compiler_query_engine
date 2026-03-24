#include <stdio.h>
#include <stdlib.h>

void error_handler() {
    printf("Error occurred!\n");
    exit(1);
}

int process_value(int val, int x) {
    int v = 0;
    if (val < 0) {
        printf("Negative value detected\n");
        return -1;
    }
    if (val > 100) {
    // if(0){       //uncomment to test "Is the error_handler block reachable from main?"
        error_handler();
    }
    return val * 2;
}

int main(int argc, char *argv[]) {
    int result;
    int input = 50;
    
    if (argc > 1) {
        input = atoi(argv[1]);
    }
    
    result = process_value(input, 0);
    
    
    printf("Result: %d\n", result);
    return 0;
}

