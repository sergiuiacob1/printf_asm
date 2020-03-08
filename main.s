.data
    DMAX: .long 16384
    FORMAT: .space 16384

    BUFFER: .space 128
    INVERSED: .space 128

    HEXA_CHARS: .string "0123456789ABCDEF"

.global myprintf

// global conventions:
// rdi is used for the format string
// printf can have a variable number of parameters
// we will use r11 to track where is the next parameter to print
// if r11 is < 8 bytes * 5 parameters (rsi, rdx, rcx, r8, r9), simply POP the next parameter from the stack
// if r11 is equal to 40, the parameter is at 16(%rbp)
// for any value for r11 bigger than 40, the next parameter should be at (r11 - 40 + 16)(%rbp)

myprintf:
    push %rbp
    movq %rsp, %rbp
    
    // parameter order: rdi, rsi, rdx, rcx, r8, r9
    // first parameter (rdi) is the format string, we keep that one separately
    // we will often overwrite rdx, rcx, so it is better if
    // we push all of these registers that are parameters on the stack
    // we won't push rdi to the stack, we'll use it as it is

    // IMPORTANT:
    // in case myprintf has more than 6 parameters, the rest of them are already on the stack

    // push registers in the inversed order
    // so I can just pop the parameters when I need them
    push %r9
    push %r8
    push %rcx
    push %rdx
    push %rsi


    // initially, r10 == 0 (we are at the first parameter)
    xor %r10, %r10

    // go through the format string
    _parseFormatString:
        cmpb $0, (%rdi)
        je myprintf_done

        call checkIfInteger
        cmp $1, %rax
        jnz myprintf_notInteger
            // it is an integer
            call printInteger
            jmp _parseFormatString

        myprintf_notInteger:
        call checkIfCharacter
        cmp $1, %rax
        jnz myprintf_notCharacter
            // it is a character
            call printCharacter
            jmp _parseFormatString

        myprintf_notCharacter:
        call checkIfString
        cmp $1, %rax
        jnz myprintf_notString
            // it is a string
            call printString
            jmp _parseFormatString

        myprintf_notString:
        call checkIfHex
        cmp $1, %rax
        jnz myprintf_notHex
            // it is a hex
            call printHex
            jmp _parseFormatString

        myprintf_notHex:


        // if I reach this, simply print the current character and go to the next one
        mov %rdi, %rcx
        mov $4, %rax
        mov $1, %rbx
        mov $1, %rdx
        int $0x80

        inc %rdi
        jmp _parseFormatString
            

    myprintf_done:
    movq %rbp, %rsp
    pop %rbp
    ret

checkIfString:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    cmpb $'%', (%rdi)
    jne checkIfCharacter_return
    cmpb $'s', 1(%rdi)
    jne checkIfString_return
    mov $1, %rax
    
    checkIfString_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printString:
    push %rbp
    movq %rsp, %rbp

    // first, go to the end of %...s in the string format (rdi)
    printString_jumpOverFormat:
        inc %rdi
        cmpb $'s', (%rdi)
        jne printString_jumpOverFormat
    // jump over the last 's'
    inc %rdi

    // get in rax what I have to print
    // for strings, this is AN ADDRESS!!!
    call getNextParameter

    // find the length of the string first of all
    mov %rax, %rbx
    xor %rdx, %rdx
    printString_findLength:
        cmpb $0, (%rbx)
        je printfString_doneFindingLength
        inc %rbx
        inc %rdx
        jmp printString_findLength
    printfString_doneFindingLength:

    // print string (which is now in rax)
    // and in rdx i already have the number of chars to print
    mov %rax, %rcx
    mov $4, %rax
    mov $1, %rbx
    int $0x80

    movq %rbp, %rsp
    pop %rbp
    ret

checkIfCharacter:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    cmpb $'%', (%rdi)
    jne checkIfCharacter_return
    cmpb $'c', 1(%rdi)
    jne checkIfCharacter_return
    mov $1, %rax
    
    checkIfCharacter_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printCharacter:
    push %rbp
    movq %rsp, %rbp

    // first, go to the end of %...c in the string format (rdi)
    printCharacter_jumpOverFormat:
        inc %rdi
        cmpb $'c', (%rdi)
        jne printCharacter_jumpOverFormat
    // jump over the last 'c'
    inc %rdi

    // get in rax what I have to print
    call getNextParameter

    mov $BUFFER, %rbx
    movb %al, (%rbx)
    inc %rbx
    movb $0, (%rbx)

    mov $4, %rax
    mov $1, %rbx
    mov $BUFFER, %rcx
    mov $1, %rdx
    int $0x80

    movq %rbp, %rsp
    pop %rbp
    ret

checkIfInteger:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    // check if what I have right now is an integer
    // it is an integer if I have "%d"
    cmpb $'%', (%rdi)
    jne checkIfInteger_return
    cmpb $'d', 1(%rdi)
    jne checkIfInteger_return
    mov $1, %rax
    
    checkIfInteger_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printInteger:
    push %rbp
    movq %rsp, %rbp

    // first, go to the end of %...d in the string format (rdi)
    printInteger_JumpOverIntegerFormat:
        inc %rdi
        cmpb $'d', (%rdi)
        jne printInteger_JumpOverIntegerFormat
    // jump over the last 'd'
    inc %rdi

    // get in rax what I have to print
    call getNextParameter

    // remember the sign
    mov $1, %r14
    cmp $0, %rax
    jg printInteger_isPositive
    mov $-1, %r14
    // neg %rax
    imul $-1, %rax 

    printInteger_isPositive:
    // get the number's digits
    mov $INVERSED, %rbx
    xor %rcx, %rcx
    mov $10, %r10
    printInteger_reverseNumber:
        xor %rdx, %rdx
        idiv %r10, %rax
        movb %dl, (%rbx)
        inc %rcx
        inc %rbx

        cmp $0, %rax
        jnz printInteger_reverseNumber

    // put the digits in the BUFFER, but reverse them
    mov $BUFFER, %rbx
    // save total number of bytes to be written
    mov %rcx, %r15

    // check the sign
    cmp $-1, %r14
    jne _do_not_adjust_sign
    movb $'-', (%rbx)
    inc %rbx
    inc %r15

    _do_not_adjust_sign:
    mov $INVERSED, %rax
    
    // for rbx, go to the end
    add %rcx, %rbx
    movb $0, (%rbx)
    dec %rbx

    _build_correct_number:
        mov (%rax), %r13
        movb %r13b, (%rbx)
        addb $48, (%rbx)

        inc %rax
        dec %rbx

        loop _build_correct_number
    
    mov $4, %rax
    mov $1, %rbx
    mov $BUFFER, %rcx
    mov %r15, %rdx
    int $0x80


    movq %rbp, %rsp
    pop %rbp
    ret

checkIfHex:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    // format for hex: %X
    cmpb $'%', (%rdi)
    jne checkIfHex_return
    cmpb $'X', 1(%rdi)
    jne checkIfHex_return
    mov $1, %rax
    
    checkIfHex_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printHex:
    push %rbp
    movq %rsp, %rbp

    // first, go to the end of %...X in the string format (rdi)
    printHex_jumpOverFormat:
        inc %rdi
        cmpb $'X', (%rdi)
        jne printHex_jumpOverFormat
    // jump over the last 'X'
    inc %rdi

    // get in rax what I have to print
    call getNextParameter

    // remember the sign
    mov $1, %r14
    cmp $0, %rax
    jg printHex_isPositive
    mov $-1, %r14
    neg %rax

    printHex_isPositive:
    // get the number's digits
    mov $INVERSED, %rbx
    xor %rcx, %rcx
    // working with base 16
    mov $16, %r10
    printHex_reverseNumber:
        xor %rdx, %rdx
        idiv %r10, %rax
        // if res is 11, for example, I have to print HEXA_CHARS[11]
        mov $HEXA_CHARS, %r15
        add %rdx, %r15
        mov (%r15), %rdx
        movb %dl, (%rbx)
        inc %rcx
        inc %rbx

        cmp $0, %rax
        jnz printHex_reverseNumber

    // I have to reverse the result
    mov $BUFFER, %rbx
    // save total number of bytes to be written
    mov %rcx, %r15
    mov $INVERSED, %rax
    // for rbx, go to the end
    add %rcx, %rbx
    movb $0, (%rbx)
    dec %rbx

    printHex_buildCorrectNumber:
        mov (%rax), %r13
        movb %r13b, (%rbx)
        inc %rax
        dec %rbx
        loop printHex_buildCorrectNumber
    
    mov $4, %rax
    mov $1, %rbx
    mov $BUFFER, %rcx
    mov %r15, %rdx
    int $0x80


    movq %rbp, %rsp
    pop %rbp
    ret


getNextParameter:
    push %rbp
    movq %rsp, %rbp

    mov %rsi, %rax
    jmp getNextParameter_end

    // puts in rax the next parameter that I have to print
    
    cmp $40, %r11
    jge getNextParameter_isAfterFirstParameters
    // if r11 < 40 bytes, then the next parameter is either rsi, rdx, rcx, r8 or r9
    // these were pushed on the stack at the beggining
    pop %rax
    // I "consumed" 8 bytes
    add $8, %r11
    jmp getNextParameter_end

    getNextParameter_isAfterFirstParameters:
    // get from stack
    mov %r11, %rax
    sub $40, %rax
    // mov %rbp, 

    

    getNextParameter_end:
    movq %rbp, %rsp
    pop %rbp
    ret
