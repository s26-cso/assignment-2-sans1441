#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() 
{

    char operation[32];
    int x, y;

    while(1) 
    {

        int invalid = scanf("%31s %d %d", operation, &x, &y);
        if(invalid!=3)break;

        char soName[32];
        snprintf(soName, sizeof(soName), "lib%s.so", operation);

        void *hdlPtr = dlopen(soName, RTLD_LAZY);

        int (*func)(int, int);
        func = (int (*)(int, int)) dlsym(hdlPtr, operation);

        int res = func(x, y);
        printf("%d\n", res);

        dlclose(hdlPtr);
    }

    return 0;
}