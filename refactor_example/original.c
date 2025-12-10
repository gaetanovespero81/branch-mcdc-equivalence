// refactor_example/original.c
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
/*
 * Original decision:
 *   (speed > 0 && brake == 0) || emergency
 *
 * The main has NO checks, NO extra branches.
 * Coverage is clean: only the decision under test.
 */

int main(int argc, char **argv)
{
    int speed     = atoi(argv[1]);
    int brake     = atoi(argv[2]);
    int emergency = atoi(argv[3]);

    bool decision = ((speed > 0 && brake == 0) || (emergency != 0));

    if (decision) { 
        (void)0; 
    }
    else          
    { 
        (void)0; 
    }

    return 0;   // always 0 so the script never stops
}