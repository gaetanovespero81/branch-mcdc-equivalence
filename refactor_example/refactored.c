// refactor_example/refactored.c
#include <stdbool.h>
#include <stdlib.h>

/*
 * Refactored decision:
 *
 *   core = (speed > 0) && (brake == 0);   // AND-only chain
 *   decision = emergency || core;         // OR-only chain
 *
 * main has NO extra logic: pure measurement.
 */

static bool enable_core(int speed, int brake)
{
    return (speed > 0) && (brake == 0);
}

int main(int argc, char **argv)
{
    int speed     = atoi(argv[1]);
    int brake     = atoi(argv[2]);
    int emergency = atoi(argv[3]);

    bool core     = enable_core(speed, brake);
    bool decision = (emergency != 0) || core;

    if (decision) 
    { 
        (void)0; 
    }
    else 
    { 
        (void)0; 
    }

    return 0;
}