#include<stdio.h>
#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"


int main(int argc, char const *argv[])
{
    if (atoi[argv[1]]<0 || atoi(argv[1])>100)
    {
        printf("Invalid Priorty\n");
        exit(1);
    }
    printf("OLD priorty:%d\n",(atoi(argv[1]),atoi(argv[2])));
    exit(1);
    return 0;
}
