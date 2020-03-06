#include <stdio.h>
#include <inttypes.h>

void myprintf(char *, ...);

int main()
{
    // data to use
    char charTest = 'x';
    int intTest = 9786;

    // chars
    // myprintf("");   // nothing
    // myprintf("1");  // single digit
    // myprintf("a");  // single char
    // myprintf("\n"); // special character
    // myprintf("\n"); // special character

    // string
    // myprintf("89184\n");
    // myprintf("Hello, world!");
    // myprintf("\n");

    // integers
    myprintf("%d\n", intTest);
    myprintf("The number %d is the solution\n", 42);
    myprintf("\n");

    // multiple parameters
    myprintf("Current date of writing this code line: %d/%d/%d\n", 6, 3, 2020);
    myprintf("Fibonacci numbers: %d, %d, %d, %d, %d, %d, %d, %d, %d\n", 1, 1, 2, 3, 5, 8, 13, 21, 34);
    // myprintf("\n");

    // mixed parameters
    // myprintf("%c is the %drd letter of the English alphabet\n", 'c', 3);
    // myprintf("\n");

    return 0;
}
