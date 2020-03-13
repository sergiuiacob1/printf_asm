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
// we will use r12 to track where is the next parameter to print
// if r12 is < 8 bytes * 5 parameters (rsi, rdx, rcx, r8, r9), simply POP the next parameter from the stack
// if r12 is equal to 40, the parameter is at 16(%rbp)
// for any value for r12 bigger than 40, the next parameter should be at (r12 - 40 + 16)(%rbp)

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

    // save the current stack addres in r11
    // I'll use r11 to get the parameters that I have to print
    mov %rsp, %r11
    // initially, I "consumed" no bytes
    xor %r12, %r12

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
            // put in rax what to print
            call getNextParameter
            call printInteger
            jmp _parseFormatString

        myprintf_notInteger:
        // call checkIfLongInteger
        // cmp $1, %rax
        // jnz myprintf_notLongInteger
            // it is a long integer
            // put in rax what to print
        //     call getNextParameter
        //     call printLongInteger
        //     jmp _parseFormatString

        // myprintf_notLongInteger:
        call checkIfCharacter
        cmp $1, %rax
        jnz myprintf_notCharacter
            // it is a character
            // put what to print in rax
            call getNextParameter
            call printCharacter
            jmp _parseFormatString

        myprintf_notCharacter:
        call checkIfString
        cmp $1, %rax
        jnz myprintf_notString
            // it is a string
            // put in rax what to print
            call getNextParameter
            call printString
            jmp _parseFormatString

        myprintf_notString:
        call checkIfHex
        cmp $1, %rax
        jnz myprintf_notHex
            // it is a hex
            // put what to print in rax
            call getNextParameter
            call printHex
            jmp _parseFormatString

        myprintf_notHex:
        call checkIfIntArray
        cmp $1, %rax
        jnz myprintf_notIntArray
            // it is an int array
            // put what to print in rax
            call getNextParameter
            call printIntArray
            jmp _parseFormatString

        myprintf_notIntArray:
        call checkIfHexArray
        cmp $1, %rax
        jnz myprintf_notHexArray
            // it is a hex array
            // put what to print in rax
            call getNextParameter
            call printHexArray
            jmp _parseFormatString

        myprintf_notHexArray:

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

checkIfIntArray:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    cmpb $'%', (%rdi)
    jne checkIfIntArray_return
    cmpb $'v', 1(%rdi)
    jne checkIfIntArray_return
    cmpb $'d', 2(%rdi)
    jne checkIfIntArray_return
    mov $1, %rax

    // jump over format
    add $3, %rdi
    
    checkIfIntArray_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printIntArray:
    // in rax I have the vector to print
    push %rbp
    movq %rsp, %rbp

    mov %rax, %rbx

    // get the length of the vector
    push %rbx
    call getNumberFromFormatString
    pop %rbx
    mov %rax, %rcx
    dec %rcx

    printIntArray_printIndividualInts:
        mov (%rbx), %rax
        add $4, %rbx
        push %rbx
        push %rcx
        call printInteger
        // print a ', ' afterwards
        mov $',', %rax
        call printCharacter
        mov $' ', %rax
        call printCharacter

        pop %rcx
        pop %rbx
        loop printIntArray_printIndividualInts
    
    // print the last one without ", "
    mov (%rbx), %rax
    call printInteger

    movq %rbp, %rsp
    pop %rbp
    ret

checkIfHexArray:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    cmpb $'%', (%rdi)
    jne checkIfHexArray_return
    cmpb $'v', 1(%rdi)
    jne checkIfHexArray_return
    cmpb $'X', 2(%rdi)
    jne checkIfHexArray_return
    mov $1, %rax

    // jump over format
    add $3, %rdi
    
    checkIfHexArray_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printHexArray:
    // in rax I have the vector to print
    push %rbp
    movq %rsp, %rbp

    mov %rax, %rbx

    // get the length of the vector
    push %rbx
    call getNumberFromFormatString
    pop %rbx
    mov %rax, %rcx
    dec %rcx

    printHexArray_printIndividual:
        mov (%rbx), %rax
        add $4, %rbx
        push %rbx
        push %rcx
        call printHex
        // print a ', ' afterwards
        mov $',', %rax
        call printCharacter
        mov $' ', %rax
        call printCharacter

        pop %rcx
        pop %rbx
        loop printHexArray_printIndividual
    
    // print the last one without ", "
    mov (%rbx), %rax
    call printInteger

    movq %rbp, %rsp
    pop %rbp
    ret


checkIfString:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    cmpb $'%', (%rdi)
    jne checkIfString_return
    cmpb $'s', 1(%rdi)
    jne checkIfString_return
    mov $1, %rax

    // jump over "%s"
    add $2, %rdi
    
    checkIfString_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printString:
    push %rbp
    movq %rsp, %rbp

    // I have in rax what I want to print
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
    
    // jump over "%c"
    add $2, %rdi

    checkIfCharacter_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printCharacter:
    // receives in rax what to print
    push %rbp
    movq %rsp, %rbp

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

    // jump over "%d"
    add $2, %rdi
    
    checkIfInteger_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printInteger:
    // receives in rax what to print
    push %rbp
    movq %rsp, %rbp

    // remember the sign
    // work with eax!!! because this is an int!
    mov $1, %r14
    cmp $0, %eax
    jge printInteger_isPositive
    mov $-1, %r14
    neg %eax

    printInteger_isPositive:
    // get the number's digits
    mov $INVERSED, %rbx
    xor %rcx, %rcx
    mov $10, %r10
    printInteger_reverseNumber:
        xor %rdx, %rdx
        div %r10d, %eax
        movb %dl, (%rbx)
        inc %rcx
        inc %rbx

        cmp $0, %eax
        jnz printInteger_reverseNumber
    
    // move rbx to last digit
    dec %rbx
    // save total number of bytes to be written
    mov %rcx, %r15

    mov $BUFFER, %rax
    // check the sign
    cmp $-1, %r14
    jne printInteger_buildCorrectNumber
    movb $'-', (%rax)
    inc %rax
    inc %r15

    printInteger_buildCorrectNumber:
        mov (%rbx), %r13
        movb %r13b, (%rax)
        addb $48, (%rax)

        inc %rax
        dec %rbx

        loop printInteger_buildCorrectNumber
    // put null, just to be safe
    movb $0, (%rax)

    mov $4, %rax
    mov $1, %rbx
    mov $BUFFER, %rcx
    mov %r15, %rdx
    int $0x80


    movq %rbp, %rsp
    pop %rbp
    ret

checkIfLongInteger:
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax

    // check if what I have right now is an integer
    // it is an integer if I have "%d"
    cmpb $'%', (%rdi)
    jne checkIfLongInteger_return
    cmpb $'l', 1(%rdi)
    jne checkIfLongInteger_return
    cmpb $'d', 2(%rdi)
    jne checkIfLongInteger_return
    mov $1, %rax

    // jump over "%ld"
    add $3, %rdi
    
    checkIfLongInteger_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printLongInteger:
    // receives in rax what to print
    push %rbp
    movq %rsp, %rbp

    // remember the sign
    // this is on 8 bytes, so use rax
    mov $1, %r14
    cmp $0, %rax
    jge printLongInteger_isPositive
    mov $-1, %r14
    neg %rax

    printLongInteger_isPositive:
    // get the number's digits
    mov $INVERSED, %rbx
    xor %rcx, %rcx
    mov $10, %r10
    printLongInteger_reverseNumber:
        xor %rdx, %rdx
        div %r10, %rax
        movb %dl, (%rbx)
        inc %rcx
        inc %rbx

        cmp $0, %rax
        jnz printLongInteger_reverseNumber
    
    // move rbx to last digit
    dec %rbx
    // save total number of bytes to be written
    mov %rcx, %r15

    mov $BUFFER, %rax
    // check the sign
    cmp $-1, %r14
    jne printLongInteger_buildCorrectNumber
    movb $'-', (%rax)
    inc %rax
    inc %r15

    printLongInteger_buildCorrectNumber:
        mov (%rbx), %r13
        movb %r13b, (%rax)
        addb $48, (%rax)

        inc %rax
        dec %rbx

        loop printLongInteger_buildCorrectNumber
    // put null, just to be safe
    movb $0, (%rax)

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

    // jump over "%X"
    add $2, %rdi
    
    checkIfHex_return:
    movq %rbp, %rsp
    pop %rbp
    ret

printHex:
    // receives in rax what to print
    push %rbp
    movq %rsp, %rbp
    
    printHex_isPositive:
    // get the number's digits
    mov $INVERSED, %rbx
    xor %rcx, %rcx
    // working with base 16
    mov $16, %r10
    // work with eax!!! this is not long hex
    printHex_reverseNumber:
        xor %rdx, %rdx
        div %r10d, %eax
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
    mov $BUFFER, %rax
    // save total number of bytes to be written
    mov %rcx, %r15
    // set rbx to last digit
    dec %rbx

    printHex_buildCorrectNumber:
        mov (%rbx), %r13
        movb %r13b, (%rax)
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
    // puts in rax the next parameter that I have to print
    push %rbp
    movq %rsp, %rbp
    
    // r11 represents the stack address
    // if r12 < 40 bytes, then the next parameter is either rsi, rdx, rcx, r8 or r9
    // these were pushed on the stack at the beggining
    // if not, they were pushed on the stack BEFORE calling myprintf, so add an additional offset of 16

    // first, move %rsp to where it should be
    mov %r11, %rsp
    add %r12, %rsp
    cmp $40, %r12
    jl getNextParameter_getBytes
    // if I got here, then add an additional offset of 16
    add $16, %rsp

    getNextParameter_getBytes:
    pop %rax
    add $8, %r12

    getNextParameter_end:
    movq %rbp, %rsp
    pop %rbp
    ret


getNumberFromFormatString:
    // puts in rax the current number in the format string
    // ex: if rdi is now at "1312 %d something something" it will return 1312 and rdi will be on ' '
    push %rbp
    movq %rsp, %rbp

    xor %rax, %rax
    getNumberFromFormatString_whileDigit:
        cmpb $'0', (%rdi)
        jl getNumberFromFormatString_return
        cmpb $'9', (%rdi)
        jg getNumberFromFormatString_return
        imul $10, %rax
        xor %rbx, %rbx
        movb (%rdi), %bl
        sub $'0', %bl
        add %rbx, %rax
        inc %rdi
        jmp getNumberFromFormatString_whileDigit


    getNumberFromFormatString_return:
    movq %rbp, %rsp
    pop %rbp
    ret
