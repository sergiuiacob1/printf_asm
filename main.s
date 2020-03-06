.data
    DMAX: .long 16384
    FORMAT: .space 16384
 

.global myprintf

myprintf:
    push %rbp
    movq %rsp, %rbp

    // first parameter is the format string
    // mov 16(%rbp), %rcx
    mov 16(%rbp), %rcx


    // go through the format string
    _printFormatString:
        mov $4, %rax
        mov $1, %rbx
        mov $2, %rdx
        int $0x80

        inc %rcx
        cmpb $0, (%rcx)
        jnz _printFormatString

    movq %rbp, %rsp
    pop %rbp
    ret

finish:
    mov $1, %rax
    mov $0, %rbx
    int $0x80
