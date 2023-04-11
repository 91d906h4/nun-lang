#include <stdio.h>
#include <stdlib.h>

// Error handler
void error(char* message) {
    printf("%s", message);
    exit(-1);
}