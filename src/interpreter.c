#include <stdio.h>
#include <string.h>

#include "lib/error.h"
#include "lib/address.h"

typedef enum {
    MSGD = 1,
    MSGA = 2,

    ADD = 3,
    SUB = 4,
    MUL = 5,
    DIV = 6,

    MOV = 7, // Move value to register.
    CLR = 8, // Clear register.

    JMP = 9, // Jump if condition in address is 1.

    GRT = 10, // If the value in the address is greater than the value of data, then set the value of address to 1, otherwise, 0.
} operator;

typedef enum {
    DIG = 0, // Digital type
    CHR = 1, // Char type
    ADDR = 2, // Address type
} remain;

int main(int argc, char* argv[]) {

    // Check if input file specified.
    if (argc < 2) error("No file specified. Please select a file to run.");

    int bit, bitcount = 0, instructor[64], skip = 0;
    long long reg[1024] = {0};
    char* filename = argv[1];
    FILE* fp;

    fp = fopen(filename, "r");

    // Check if file can be opned.
    if (fp == NULL) error("Cannot open file.");

    while((bit = fgetc(fp)) != EOF) {
        // Skip chars
        if (skip > 0) {
            skip--;
            continue;
        }

        if (bit == 110) bit = 1; // n
        else if (bit == 117) bit = 0; // u
        else continue; // Ignore illegal chars.

        instructor[bitcount] = bit;
        bitcount++;

        // Continue if instructor is incomplete.
        if (bitcount < 64) continue;
        else bitcount = 0;

        // Transfer binary to decimal.
        register int i = 0;
        register long long pow;
        int opcode = 0, address = 0, remain = 0;
        long long data = 0;

        // op code; 8 bits
        pow = 128;
        for (; i < 8; i++) {
            opcode += pow * instructor[i];
            pow /= 2;
        }

        // address; 10 bits
        pow = 512;
        for (; i < 18; i++) {
            address += pow * instructor[i];
            pow /= 2;
        }

        // remain; 6 bits
        pow = 32;
        for (; i < 24; i++) {
            remain += pow * instructor[i];
            pow /= 2;
        }

        // data; 40 bits
        pow = 549755813888;
        for (; i < 64; i++) {
            data += pow * instructor[i];
            pow /= 2;
        }

        switch (opcode) {
            case MSGD:
                if (remain == DIG) printf("%lld", data);
                else if (remain == CHR) printf("%c", (char)data);
                else if (remain == ADDR) showAddress(data);
                break;
            
            case MSGA:
                if (remain == DIG) printf("%lld", reg[address]);
                else if (remain == CHR) printf("%c", (char)reg[address]);
                break;
            
            case ADD:
                if (data > 1023) error("Invalid address");
                reg[address] += reg[data];
                break;
            
            case SUB:
                if (data > 1023) error("Invalid address");
                reg[address] -= reg[data];
                break;
            
            case MUL:
                if (data > 1023) error("Invalid address");
                reg[address] *= reg[data];
                break;
            
            case DIV:
                if (data > 1023) error("Invalid address");
                reg[address] /= reg[data];
                break;
            
            case MOV:
                reg[address] = data;
                break;
            
            case CLR:
                reg[address] = 0;
                break;
            
            case JMP:
                // Determine how many chars to skip (normally multiples of 64).
                if (reg[address] == 1) skip = data;
                break;
            
            case GRT:
                long long a = reg[address], b = 0;
                if (remain == ADDR) {
                    if (data > 1023) error("Invalid address");
                    b = reg[data];
                }
                else if (remain == DIG) b = data;
                else if (remain == CHR) b = (char)data;
                
                reg[address] = a > b ? 1 : 0;
                break;
            
            default:
                break;
        }
    }

    fclose(fp);

    return 0;
}
