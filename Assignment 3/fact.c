#include <stdio.h>
#include <stdlib.h>

int fact(int n) 
{ 
   if (n==0)
      return 1;
   else
      return fact(n-1)*n; 
}

int main()
{
   int f = fact(4); 
   printf("%d\n",f);
   exit(0);
}

