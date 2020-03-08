#include <stdio.h>
#include <inttypes.h>

void myprintf(char *, ...);

int main()
{
    // data to use
    char charTest = 'x';
    int intTest = 9786;
    char *stringTest = "This is a string.";

    // simple chars
    // myprintf("");   // nothing
    // myprintf("1");  // single digit
    // myprintf("a");  // single char
    // myprintf("\n"); // special character
    // myprintf("\n"); // special character

    // simple string
    // myprintf("89184\n");
    // myprintf("Hello, world!");
    // myprintf("\n");

    // characters
    // myprintf("single character: %c\n", charTest);
    // myprintf("single character: %c\n", 'a');

    // integers
    myprintf ("---INTEGERS---\n");
    printf ("printf displaying an int: %d\n", 1 << 31);
    myprintf("myprintf displaying the same int: %d\n", 1 << 31);
    myprintf("%d\n", intTest);
    myprintf("The number %d is the solution\n", 42);
    printf ("printf example of int overflow: %d\n", 999999999999999999);
    myprintf ("myprintf example of int overflow: %d\n", 999999999999999999);
    myprintf("---INTEGERS---\n\n");

    // string parameters
    // myprintf ("%s\n", "Hello, world!");
    // myprintf("string parameter: %s\n", stringTest);

    // HEX
    myprintf ("---HEX---\n");
    printf ("printf hex value for %d: %X\n", intTest, intTest);
    myprintf ("myprintf hex value for %d: %X\n", intTest, intTest);
    printf ("printf hex value for %d: %X\n", -intTest, -intTest);
    myprintf ("myprintf hex value for %d: %X\n", -intTest, -intTest);
    printf ("printf hex value for %d: %X\n", 1231231233344, 1231231233344);
    myprintf ("myprintf hex value for %d: %X\n", 1231231233344, 1231231233344);
    myprintf("---HEX---\n\n");

    // multiple parameters
    // myprintf("Current date of writing this code line: %d/%d/%d\n", 6, 3, 2020);
    // myprintf("Fibonacci numbers: %d, %d, %d, %d, %d, %d, %d, %d, %d\n", 1, 1, 2, 3, 5, 8, 13, 21, 34);
    // myprintf("\n");

    // mixed parameters
    // myprintf("'%c' is the %drd letter of the English alphabet\n", 'c', 3);
    // myprintf("\n");

    return 0;
}
