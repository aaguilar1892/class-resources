// Alexis Aguilar (aa1732)
// CSCE3600.208 Systems Programming
// Recitation Assignment 1 - ASCII Bits and Bytes

/*
PROGRAM DESCRIPTION:
In this recitation assignment, you will write a coplete C program that
will prompt the user to enter an ASCII printable character and then print
out its decimal (base 10), hexadecimal (base 16,), and all 8 binary digits
of its binary (base 2) representation.

You may assume that the user enters a valid ASCII printable character
when prompted. Examples o printable characters include A, B, C, #, $,
&, +, 0, 1, 2, <, a, b, c, and so forth, and they typically range in
decimal value from 33 to 126. You do not have to do any error checking
for non-printable characters.

For this recitation assignment, complete the following tasks.
    1.) Prompt the user to enter a printable ASCII character using 
    printf and then read in the user's response using scanf, storing 
    your character as an unsigned char. 

    2.) For the decimal and hexadecimal bases, simply take advantage 
    of the format specifiers in printf to print the decimal and 
    hexadecimal representations. See man 3 printf or any of the reference 
    or tutorial material provided on Canvas for help if you are having 
    trouble with this.

    3.) Although there are several ways to accomplish printing out the 
    binary representation, you are being asked to accomplish this 
    functionality using bitwise operators as described below:
        a.) Since a binary representation can only be 8 digits in length,
        use a for loop that decrements the control variable from 7 down
        to 0, inclusively.
        b.) The right shift operator (>>) is used to shift bits to the 
        right. Use this operator to right shift the printable character 
        by the amount in the control variable (i.e., the number being
        decremented in each iteration of the for loop) and store in a
        temporary integer variable.
        c.) Next, the bitwise AND operator (&) will set a bit to 1 if 
        and only if both of the corresponding bits in the operands are 1. 
        For example, if x=0110 and y=1011, then x&y=0010. Now, if the 
        bitwise AND of the temporary integer variable from (b) above and 
        the integral literal value 1 is true, simply print "1" (with no 
        newline) to the terminal; otherwise, print "0" (with no newline).
        After all 8 binary digits are printed (including leading 0s), then 
        print a newline to the terminal.

REQUIREMENTS:
    * No additional comments are required for this recitation assignment, 
    although you should ensure that your name and EUID is included in your
    code as comments.
    * Your program should be named "rec01.c", without the quotes.
    * Your program will be graded based largely on whether it works 
    corrctly on the CSE machines (e.g., cse01, cse02, ..., cse06), so 
    you should make sure that your program compiles and runs on one of
    the CSE machines before submitting it.
    
EXAMPLE OUTPUT:
$ ./a.out
Enter an ASCII character: A
The ASCII value of A is:
dec -- 65
hex -- 41
bin -- 01000001
$ ./a.out
Enter an ASCII character: a
The ASCII value of a is:
dec -- 97
hex -- 61
bin -- 01100001
*/

#include <stdio.h>

int main(){
    unsigned char ch;

    // Prompt user for an ASCII character
    printf("Enter an ASCII character: ");
    scanf("%c", &ch);

    // Print char in decimal
    printf("Decimal: %d\n", ch);

    // Print char in hexadecimal
    printf("Hexadecimal: %x\n", ch);

    // Print char in binary, using bitwise operators
    printf("Binary: ");
    for(int i = 7; i >= 0; i--){
        printf("%d", (ch >> i) & 1);
    }
    printf("\n");

    return 0;

}