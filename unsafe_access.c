#include <stdio.h>
#include <stddef.h>

int unsafe_access(int* arr, size_t arr_size) {
    // Bounds check - validates index before access
    if (10 >= arr_size) {
        fprintf(stderr, "Error: Index 10 out of bounds (array size: %zu)\n", arr_size);
        return -1;
    }
    arr[10] = 1;  // Now protected by the check above
    return 0;
}