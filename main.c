#include <stdio.h>
#include <inttypes.h>

void myprintf(char *, ...);
void fmyprintf(int, char *, ...);

int main()
{
    // data to use
    char charTest = 'x';
    int intTest = 9786;
    char *stringTest = "This is a string.";
    long int longIntTest = 1275031850281302;
    int intArrayTest[] = {1, 2, 3, 4, 5, 6, -1, -2, -3, 1 << 10, -1 << 19, 1 << 30};
    int anotherIntArrayTest[] = {-101, -102, -103};

    // file test
    FILE *fout = fopen ("test.out", "w");
    int outPointer = fileno(fout);

    // simple chars
    myprintf("---CHAR CHARACTERS---\n");
    myprintf("");   // nothing
    myprintf("1");  // single digit
    myprintf("a");  // single char
    myprintf("\n"); // special character
    myprintf("---CHAR CHARACTERS---\n\n");
    // print in file
    fmyprintf(outPointer, "---CHAR CHARACTERS---\n");
    fmyprintf(outPointer, "");   // nothing
    fmyprintf(outPointer, "1");  // single digit
    fmyprintf(outPointer, "a");  // single char
    fmyprintf(outPointer, "\n"); // special character
    fmyprintf(outPointer, "---CHAR CHARACTERS---\n\n");


    // simple string
    myprintf("---STRINGS---\n");
    myprintf("89184\n");
    myprintf("Hello, world!");
    myprintf("\n");
    myprintf("---STRINGS---\n\n");
    // print in file
    fmyprintf(outPointer, "---STRINGS---\n");
    fmyprintf(outPointer, "89184\n");
    fmyprintf(outPointer, "Hello, world!");
    fmyprintf(outPointer, "\n");
    fmyprintf(outPointer, "---STRINGS---\n\n");
    

    // characters
    myprintf("---CHAR PARAMETERS---\n");
    myprintf("single character: %c\n", charTest);
    myprintf("single character: %c\n", 'a');
    myprintf("---CHAR PARAMETERS---\n\n");
    // print in file
    fmyprintf(outPointer, "---CHAR PARAMETERS---\n");
    fmyprintf(outPointer, "single character: %c\n", charTest);
    fmyprintf(outPointer, "single character: %c\n", 'a');
    fmyprintf(outPointer, "---CHAR PARAMETERS---\n\n");


    // integers
    myprintf("---INTEGERS---\n");
    printf("printf displaying an int: %d\n", 1 << 31);
    myprintf("myprintf displaying the same int: %d\n", 1 << 31);
    myprintf("%d\n", intTest);
    myprintf("The number %d is the solution\n", 42);
    printf("printf example of int overflow: %d\n", intTest * intTest * intTest);
    myprintf("myprintf example of int overflow: %d\n", intTest * intTest * intTest);
    myprintf("---INTEGERS---\n\n");
    // print in file
    fmyprintf(outPointer, "---INTEGERS---\n");
    fprintf(fout, "fprintf displaying an int: %d\n", 1 << 31);
    fflush(fout);
    fmyprintf(outPointer, "fmyprintf displaying the same int: %d\n", 1 << 31);
    fmyprintf(outPointer, "%d\n", intTest);
    fmyprintf(outPointer, "The number %d is the solution\n", 42);
    fprintf(fout, "fprintf example of int overflow: %d\n", intTest * intTest * intTest);
    fflush(fout);
    fmyprintf(outPointer, "fmyprintf example of int overflow: %d\n", intTest * intTest * intTest);
    fmyprintf(outPointer, "---INTEGERS---\n\n");


    // string parameters
    myprintf("---STRING PARAMETERS---\n");
    myprintf("%s\n", "Hello, world!");
    myprintf("string parameter: %s\n", stringTest);
    myprintf("---STRING PARAMETERS---\n\n");
    // file
    fmyprintf(outPointer, "---STRING PARAMETERS---\n");
    fmyprintf(outPointer, "%s\n", "Hello, world!");
    fmyprintf(outPointer, "string parameter: %s\n", stringTest);
    fmyprintf(outPointer, "---STRING PARAMETERS---\n\n");


    // HEX
    myprintf("---HEX---\n");
    printf("printf hex value for %d: %X\n", intTest, intTest);
    myprintf("myprintf hex value for %d: %X\n", intTest, intTest);
    printf("printf hex value for %d: %X\n", -intTest, -intTest);
    myprintf("myprintf hex value for %d: %X\n", -intTest, -intTest);
    myprintf("---HEX---\n\n");
    // print in file
    fmyprintf(outPointer, "---HEX---\n");
    fprintf(fout, "fprintf hex value for %d: %X\n", intTest, intTest);
    fflush(fout);
    fmyprintf(outPointer, "fmyprintf hex value for %d: %X\n", intTest, intTest);
    fprintf(fout, "fprintf hex value for %d: %X\n", -intTest, -intTest);
    fflush(fout);
    fmyprintf(outPointer, "fmyprintf hex value for %d: %X\n", -intTest, -intTest);
    fmyprintf(outPointer, "---HEX---\n\n");


    // Arrays
    myprintf("---Arrays---\n");
    // v = vector; d = for ints; 5 = the length
    myprintf("Array of ints: %vd\n", intArrayTest, 12);
    myprintf("An undeclared array of ints: %vd\n", (int[]){1 << 1, 1 << 2, 1 << 3, 1 << 4, 1 << 5}, 5);
    myprintf("---Arrays---\n\n");
    // print in file
    fmyprintf(outPointer, "---Arrays---\n");
    // v = vector; d = for ints; 5 = the length
    fmyprintf(outPointer, "Array of ints: %vd\n", intArrayTest, 12);
    fmyprintf(outPointer, "An undeclared array of ints: %vd\n", (int[]){1 << 1, 1 << 2, 1 << 3, 1 << 4, 1 << 5}, 5);
    fmyprintf(outPointer, "---Arrays---\n\n");


    // multiple parameters
    myprintf("---MULTIPLE PARAMETERS OF THE SAME TYPE---\n");
    myprintf("Current date of writing this code line: %d/%d/%d\n", 6, 3, 2020);
    myprintf("Fibonacci numbers: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 34 + 55, 34 + 55 * 2);
    myprintf("Printing arrays in one myprintf call:\nFirst array: %vd\nAnd now another one: %vd\nLet's also add a string: %s\nNow also printing a int array as hex numbers: %vX\nArrays printed!\n", intArrayTest, 12, (int[]){-1, 3, 1 << 16}, 3, "This works well!", anotherIntArrayTest, 3);
    myprintf("---MULTIPLE PARAMETERS OF THE SAME TYPE----\n\n");
    // print in file
    fmyprintf(outPointer, "---MULTIPLE PARAMETERS OF THE SAME TYPE---\n");
    fmyprintf(outPointer, "Current date of writing this code line: %d/%d/%d\n", 6, 3, 2020);
    fmyprintf(outPointer, "Fibonacci numbers: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 34 + 55, 34 + 55 * 2);
    fmyprintf(outPointer, "Printing arrays in one myprintf call:\nFirst array: %vd\nAnd now another one: %vd\nLet's also add a string: %s\nNow also printing a int array as hex numbers: %vX\nArrays printed!\n", intArrayTest, 12, (int[]){-1, 3, 1 << 16}, 3, "This works well!", anotherIntArrayTest, 3);
    fmyprintf(outPointer, "---MULTIPLE PARAMETERS OF THE SAME TYPE----\n\n");


    // mixed parameters
    myprintf("---MIXED PARAMETERS---\n");
    myprintf("A character: %c. A string: %s. Some ints: %d, %d, %d. Some hexas: %X, %X. One more character: %c\n", charTest, "String parameter", -1, -2, -3, 123125412, 1 << 31, 'z');
    myprintf("printf with the exact same parameters:\n");
    printf("A character: %c. A string: %s. Some ints: %d, %d, %d. Some hexas: %X, %X. One more character: %c\n", charTest, "String parameter", -1, -2, -3, 123125412, 1 << 31, 'z');
    myprintf("Printing a char: %c, a string: %s, an int: %d, an array: %vd\n", charTest, stringTest, intTest, anotherIntArrayTest, 3);
    myprintf("%d is the %dth value of this array: %vd and is the ASCII code for the letter %c, found in this string: \"%s\"\n", (int)'c', 3, (int[]){1, 2, (int)'c', 1 << 6, 1 << 7, 1 << 8, 10}, 5, 'c', "comment ca va?");
    myprintf("---MIXED PARAMETERS---\n\n");
    // print in file
    fmyprintf(outPointer, "---MIXED PARAMETERS---\n");
    fmyprintf(outPointer, "A character: %c. A string: %s. Some ints: %d, %d, %d. Some hexas: %X, %X. One more character: %c\n", charTest, "String parameter", -1, -2, -3, 123125412, 1 << 31, 'z');
    fmyprintf(outPointer, "fprintf with the exact same parameters:\n");
    fprintf(fout, "A character: %c. A string: %s. Some ints: %d, %d, %d. Some hexas: %X, %X. One more character: %c\n", charTest, "String parameter", -1, -2, -3, 123125412, 1 << 31, 'z');
    fflush(fout);
    fmyprintf(outPointer, "Printing a char: %c, a string: %s, an int: %d, an array: %vd\n", charTest, stringTest, intTest, anotherIntArrayTest, 3);
    fmyprintf(outPointer, "%d is the %dth value of this array: %vd and is the ASCII code for the letter %c, found in this string: \"%s\"\n", (int)'c', 3, (int[]){1, 2, (int)'c', 1 << 6, 1 << 7, 1 << 8, 10}, 5, 'c', "comment ca va?");
    fmyprintf(outPointer, "---MIXED PARAMETERS---\n\n");

    fclose(fout);
    return 0;
}
