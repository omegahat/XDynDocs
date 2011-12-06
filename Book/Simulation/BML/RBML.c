
#include "BML.h"

/* This is the routine that is called from R and takes the same parameters
   as the move() routine for the most part, but takes also does the looping for
   numSteps of time and specifies the values in slightly different form.

grid - an R _integer_ matrix which is of dimensions r x c (specified in the dims argument)
       and whose values are either 0 for no car, 1 for blue and 2 for red. (Or the other way round for 1 and 2?)

dims - an int array containing 2 elements and giving the number of rows and columns of grid.

redLocations - an integer matrix with as many rows as there are red cars and with 2 columns.
               Each row in the matrix gives the row and column of that red car

numReds - a single integer giving the number of red cars.

blueLocations -  same as redLocations, but for blue cars
numBlues  -  same as numReds, but for blue.

numSteps - an integer indicating how many time steps/iterations to  perform
verbose - a logical value (TRUE or FALSE) indicating whether to print out the iteration 
          number or not.

ans - an integer vector or matrix with 2 * numSteps elements into which the number
      of red and then blue cars are inserted.

speeds - an integer vector of length 2 giving the number of cells a red car and a blue
        car respectively moves in a single jump/time interval. This is c(1L, 1L) typically in R.
*/
void
R_BML(int *grid, int *dims, int *redLocations, int *numReds, 
      int *blueLocations, int *numBlues, int *numSteps,
      int *verbose, int *ans, int *speeds)
{
  unsigned int t = 0;
  for(t = 0 ; t < *numSteps ; t++) {
    if( *verbose && (t % 100) == 0)
        fprintf(stderr, "%d\n", (int) t);

    ans[t] = bml_move(grid, dims, redLocations, numReds, RED, speeds[0]);
    ans[t + *numSteps] = bml_move(grid, dims, blueLocations, numBlues, BLUE, speeds[1]);
  }
}
