#include <stdio.h>
#include <inttypes.h>

void myprintf(char *, ...);

int main()
{
    // data to use
    char charTest = 'x';
    int intTest = 9786;
    char *stringTest = "This is a string.";
    long int longIntTest = 1275031850281302;
    int intArrayTest[] = {1, 2, 3, 4, 5, 6, -1, -2, -3, 1 << 10, -1 << 19, 1 << 30};
    int anotherIntArrayTest[] = {-101, -102, -103};

    // simple chars
    myprintf("---CHAR CHARACTERS---\n");
    myprintf("");   // nothing
    myprintf("1");  // single digit
    myprintf("a");  // single char
    myprintf("\n"); // special character
    myprintf("\n"); // special character
    myprintf("---CHAR CHARACTERS---\n\n");

    // simple string
    myprintf("---STRINGS---\n");
    myprintf("89184\n");
    myprintf("Hello, world!");
    myprintf("\n");
    myprintf("---STRINGS---\n\n");

    // characters
    myprintf("---CHAR PARAMETERS---\n");
    myprintf("single character: %c\n", charTest);
    myprintf("single character: %c\n", 'a');
    myprintf("---CHAR PARAMETERS---\n\n");

    // integers
    myprintf("---INTEGERS---\n");
    printf("printf displaying an int: %d\n", 1 << 31);
    myprintf("myprintf displaying the same int: %d\n", 1 << 31);
    myprintf("%d\n", intTest);
    myprintf("The number %d is the solution\n", 42);
    printf("printf example of int overflow: %d\n", 999999999999999999);
    myprintf("myprintf example of int overflow: %d\n", 999999999999999999);
    myprintf("---INTEGERS---\n\n");

    // string parameters
    myprintf("---STRING PARAMETERS---\n");
    myprintf("%s\n", "Hello, world!");
    myprintf("string parameter: %s\n", stringTest);
    myprintf("---STRING PARAMETERS---\n\n");

    // HEX
    myprintf("---HEX---\n");
    printf("printf hex value for %d: %X\n", intTest, intTest);
    myprintf("myprintf hex value for %d: %X\n", intTest, intTest);
    printf("printf hex value for %d: %X\n", -intTest, -intTest);
    myprintf("myprintf hex value for %d: %X\n", -intTest, -intTest);
    myprintf("---HEX---\n\n");

    // Arrays
    printf("---Arrays---\n");
    // v = vector; d = for ints; 5 = the length
    myprintf("Array of ints: %vd12\n", intArrayTest);
    myprintf("Another array of ints: %vd5\n", (int[]){101, 102, 103, 104});
    myprintf("Printing arrays in one myprintf call:\nFirst array: %vd12\nAnd now another one: %vd3\nLet's also add a string: %s\nNow also printing a int array as hex numbers: %vX3\nArrays printed!\n", intArrayTest, anotherIntArrayTest, "This works well!", anotherIntArrayTest);
    printf("---Arrays---\n\n");

    // multiple parameters
    myprintf("---MULTIPLE PARAMETERS---\n");
    myprintf("Current date of writing this code line: %d/%d/%d\n", 6, 3, 2020);
    myprintf("Fibonacci numbers: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 34 + 55, 34 + 55 * 2);
    myprintf("A character: %c. A string: %s. Some ints: %d, %d, %d. Some hexas: %X, %X. One more character: %c\n", charTest, "String parameter", -1, -2, -3, 123125412, 1 << 31, 'z');
    myprintf("printf with the exact same parameters:\n");
    printf("A character: %c. A string: %s. Some ints: %d, %d, %d. Some hexas: %X, %X. One more character: %c\n", charTest, "String parameter", -1, -2, -3, 123125412, 1 << 31, 'z');
    myprintf("Printing a char: %c, a string: %s, an int: %d, an array: %vd3\n", charTest, intTest, anotherIntArrayTest);
    myprintf("---MULTIPLE PARAMETERS---\n\n");

    // mixed parameters
    myprintf("'%c' is the %drd letter of the English alphabet\n", 'c', 3);
    myprintf("\n");

    return 0;
}
