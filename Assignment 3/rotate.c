#include <stdio.h>
#include <string.h>

int rotStr(char *str, int n);

#define MAXSTR 100

void printHex(char *s)
{
    char *p;
    for (p=s; *p; p++) printf("0x%02X ",(unsigned char)*p);
}

int main()
{
    char s1[MAXSTR];
    char s2[MAXSTR];
    char s3[MAXSTR];
    char s4[MAXSTR];
    char s5[MAXSTR];

    int r1, r2, r3, r4, r5;

    strncpy(s1,"Hi",MAXSTR);
    s1[MAXSTR-1]=0;

    strncpy(s2,"covid",MAXSTR);
    s2[MAXSTR-1]=0;

    strncpy(s3,"",MAXSTR);
    s3[MAXSTR-1]=0;

    strncpy(s4,"",MAXSTR);
    s4[MAXSTR-1]=0;

    strncpy(s5,"madam",MAXSTR);
    s5[MAXSTR-1]=0;

    r1 = rotStr(s1,2);
    r2 = rotStr(s2,-1);
    r3 = rotStr(s3,-40000000);
    r4 = rotStr(s4,50000000);
    r5 = rotStr(s5,0);

    printf("Example 1: rotStr() returned %d the rotated string is: '%s' = ",r1,s1);
    printHex(s1);
    putchar('\n');

    printf("Example 2: rotStr() returned %d the rotated string is: '%s' = ",r2,s2);
    printHex(s2);
    putchar('\n');

    printf("Example 3: rotStr() returned %d the rotated string is: '%s' = ",r3,s3);
    printHex(s3);
    putchar('\n');

    printf("Example 4: rotStr() returned %d the rotated string is: '%s' = ",r4,s4);
    printHex(s4);
    putchar('\n');

    printf("Example 5: rotStr() returned %d the rotated string is: '%s' = ",r5,s5);
    printHex(s5);
    putchar('\n');



    return 0;
}
