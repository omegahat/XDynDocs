
  /* These are symbolic constants for specifying the direction. */
typedef enum {RED = 1, BLUE = 2} Direction;

  /* This is the function that does the actual moving of the cars for a given
     time step. */  
unsigned int bml_move(int *grid, int *dims, int *locations, int *num, Direction dir, int speed);

#include <stdio.h>
