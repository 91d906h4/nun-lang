#include <stdio.h>

// Convert decimal input to binary.
void decimal2binary(long long d, char* res) {
    int t = 39;
    while (d > 0) {
        res[t] = d % 2 + 48;
        d /= 2;
        t--;
    }
}

// Show address in binary.
void showAddress(long long address) {
    char temp[40] = { 0 };
    decimal2binary(address, temp);

    for (int i = 0; i < 40; i++) {
        if (temp[i]) printf("%c", temp[i]);
    }
}
