.section .text
    .intel_syntax noprefix
    .global _main

    # esp           [reserved]
    # esp + 4       [reserved]
    # esp + 8       [reserved]
    # esp + 12      file address
    # esp + 16      [fgetc]
    # esp + 20      _status_recorder // record the status is on opcode, address, or data
    # esp + 24      _status_counter
    # esp + 28      _status_data
    # esp + 32      _status_power // provide the number of power of 2
    # esp + 36      _opcode
    # esp + 40      _address
    # esp + 44      _remain
    # esp + 48      _data
    # esp + 52      _skip_pointer // used to record how many char will be skipped
    # esp + 56      [memory]
    # |             [memory]
    # esp + 4052    [memory]

.section .data
fopen_mode:
    .ascii "r\0"

print_char:
    .ascii "%c\0"

print_integer:
    .ascii "%d\0"

error_message:
    .ascii "Cannot open file '%s'.\0"

.section .code
_main:
    push    ebp
    mov     ebp, esp
    sub     esp, 4052

    # initialization
    mov     DWORD PTR [esp + 20], 0 # _status_recorder
    mov     DWORD PTR [esp + 24], 0 # _status_counter
    mov     DWORD PTR [esp + 28], 0 # _status_data
    mov     DWORD PTR [esp + 32], 1 # _status_power
    mov     DWORD PTR [esp + 36], 0 # _status_power
    mov     DWORD PTR [esp + 52], 0 # _skip_pointer

    # get filename from command line arguments
    mov     eax, DWORD PTR [ebp + 12]
    add     eax, 4
    mov     eax, DWORD PTR [eax]

    # save filename to register ebx
    # error_message will get file name from ebx
    mov     ebx, eax

    # open file
    mov     DWORD PTR [esp + 4], OFFSET FLAT:fopen_mode
    mov     DWORD PTR [esp], eax
    call    _fopen

    # check if file opened successfully
    cmp     eax, 0
    je      ERROR

    # store filename address to stack [esp + 12]
    mov     DWORD PTR [esp + 12], eax

    jmp NEXT

CCHECKER:
    movsx   eax, BYTE PTR [esp + 16]

    # ignore any chars except 'n' (110) and 'u' (117)
    cmp     eax, 110
    je      CHAR_N
    cmp     eax, 117
    je      CHAR_U
    jmp     NEXT

CHAR_N:
    mov     edx, 1
    jmp     L0

CHAR_U:
    mov     edx, 0
    jmp     L0

L0:
    inc     DWORD PTR [esp + 24]

    cmp     DWORD PTR [esp + 32], 0
    jne     C00
    mov     DWORD PTR [esp + 32], 1

C00: # condition 00: if _status_recorder == 0 && _status_counter == 8
    cmp     DWORD PTR [esp + 20], 0
    jne     C10
    cmp     DWORD PTR [esp + 24], 8
    je      CHSTATUS

    jmp     UPDATE

C10: # condition 10: if _status_recorder == 1 && _status_counter == 10
    cmp     DWORD PTR [esp + 20], 1
    jne     C20
    cmp     DWORD PTR [esp + 24], 10
    je      CHSTATUS

    jmp     UPDATE

C20: # condition 20: if _status_recorder == 2 && _status_counter == 6
    cmp     DWORD PTR [esp + 20], 2
    jne     C30
    cmp     DWORD PTR [esp + 24], 6
    je      CHSTATUS

    jmp     UPDATE

C30: # condition 30: if _status_recorder == 3 && _status_counter == 20
    cmp     DWORD PTR [esp + 20], 3
    jne     C20
    cmp     DWORD PTR [esp + 24], 20
    je      CHSTATUS

    jmp     UPDATE

UPDATE:
    imul    edx, DWORD PTR [esp + 32]
    add     DWORD PTR [esp + 28], edx
    shl     DWORD PTR [esp + 32]

    jmp     NEXT

CHSTATUS:
    # store value to register
    mov     edx, DWORD PTR [esp + 20]
    imul    edx, 4
    add     edx, 36
    mov     eax, DWORD PTR [esp + 28]
    mov     DWORD PTR [esp + edx], eax

    # reset register to 0
    mov     DWORD PTR [esp + 24], 0 # _status_counter
    mov     DWORD PTR [esp + 28], 0 # _status_data
    mov     DWORD PTR [esp + 32], 0 # _status_power

    # update _status_recorder
    # reset _status_recorder to 0 if _status_recorder == 4
    inc     DWORD PTR [esp + 20]
    cmp     DWORD PTR [esp + 20], 4
    jne     NEXT
    mov     DWORD PTR [esp + 20], 0

    # check op code
    # IST (instruction)
    cmp     DWORD PTR [esp + 36], 1
    je      INST_01
    cmp     DWORD PTR [esp + 36], 2
    je      INST_02
    cmp     DWORD PTR [esp + 36], 3
    je      INST_03
    cmp     DWORD PTR [esp + 36], 4
    je      INST_04
    cmp     DWORD PTR [esp + 36], 5
    je      INST_05
    cmp     DWORD PTR [esp + 36], 6
    je      INST_06
    cmp     DWORD PTR [esp + 36], 7
    je      INST_07
    cmp     DWORD PTR [esp + 36], 8
    je      INST_08
    cmp     DWORD PTR [esp + 36], 9
    je      INST_09
    cmp     DWORD PTR [esp + 36], 10
    je      INST_10

INST_01: # print char directly
    mov     DWORD PTR [esp], OFFSET FLAT:print_char
    mov     eax, DWORD PTR [esp + 48]
    mov     DWORD PTR [esp + 4], eax
    call    _printf

    jmp     NEXT

INST_02: # print integer directly
    mov     DWORD PTR [esp], OFFSET FLAT:print_integer
    mov     eax, DWORD PTR [esp + 48]
    mov     DWORD PTR [esp + 4], eax
    call    _printf

    jmp     NEXT

INST_03: # print char in memory
    mov     DWORD PTR [esp], OFFSET FLAT:print_char
    mov     edx, DWORD PTR [esp + 48]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + edx]
    mov     DWORD PTR [esp + 4], eax
    call    _printf

    jmp     NEXT

INST_04: # print integer in memory
    mov     DWORD PTR [esp], OFFSET FLAT:print_integer
    mov     edx, DWORD PTR [esp + 48]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + edx]
    mov     DWORD PTR [esp + 4], eax
    call    _printf

    jmp     NEXT

INST_05: # store value to memory
    mov     edx, DWORD PTR [esp + 40]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + 48]
    mov     DWORD PTR [esp + edx], eax

    jmp     NEXT

INST_06: # add
    mov     edx, DWORD PTR [esp + 40]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + 48]
    add     DWORD PTR [esp + edx], eax

    jmp     NEXT

INST_07: # sub
    mov     edx, DWORD PTR [esp + 40]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + 48]
    sub     DWORD PTR [esp + edx], eax

    jmp     NEXT

INST_08: # mul
    mov     edx, DWORD PTR [esp + 40]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + 48]
    mul     DWORD PTR [esp + edx]
    mov     DWORD PTR [esp + edx], eax

    jmp     NEXT

INST_09: # div
    mov     edx, DWORD PTR [esp + 40]
    imul    edx, 4
    add     edx, 52
    mov     eax, DWORD PTR [esp + 48]
    div     DWORD PTR [esp + edx]
    mov     DWORD PTR [esp + edx], eax

    jmp     NEXT

INST_10: # skip
    mov     edx, DWORD PTR [esp + 40]
    imul    edx, 4
    add     edx, 52
    cmp     DWORD PTR [esp + edx], 0
    je      INST_10T

    mov     eax, DWORD PTR [esp + 48]
    add     eax, 1
    mov     DWORD PTR [esp + 52], eax

INST_10T:
    jmp     NEXT

SKIP:
    sub     DWORD PTR [esp + 52], 1

NEXT:
    # read chars from file
    mov     eax, DWORD PTR [esp + 12]
    mov     DWORD PTR [esp], eax
    call    _fgetc

    cmp     DWORD PTR [esp + 52], 0
    jg      SKIP

    mov     BYTE PTR [esp + 16], al
    cmp     al, -1
    jne     CCHECKER

    # close file
    mov     eax, DWORD PTR [esp + 12]
    mov     DWORD PTR [esp], eax
    call    _fclose

    # exit program
    xor     eax, eax
    jmp     EXIT

ERROR:
    # output error message
    mov     DWORD PTR [esp], OFFSET FLAT:error_message
    mov     DWORD PTR [esp + 4], ebx
    call    _printf

    # set exit status to -1
    mov     eax, -1

EXIT:
    leave
    ret
