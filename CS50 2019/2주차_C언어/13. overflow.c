#include <stdio.h>
#include <unistd.h>

int main(void)
{
    for (int i = 0; ; i *= 2)
    {
        printf("%i\n", i);
        sleep(1);
    }
}
