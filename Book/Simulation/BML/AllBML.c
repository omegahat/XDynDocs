
typedef enum {RED = 1, BLUE = 2} Direction;
static unsigned int move(int *grid, int *dims, int *locations, int *num, Direction dir, int speed);

#include <stdio.h>

#include "BML.h"

void
R_BML(int *grid, int *dims, int *redLocations, int *numReds, 
      int *blueLocations, int *numBlues, int *numSteps,
      int *verbose, int *ans, int *speeds)
{
  unsigned int t = 0;
  for(t = 0 ; t < *numSteps ; t++) {
    if( *verbose && (t % 100) == 0)
        fprintf(stderr, "%d\n", (int) t);

    ans[t] = move(grid, dims, redLocations, numReds, RED, speeds[0]);
    ans[t + *numSteps] = move(grid, dims, blueLocations, numBlues, BLUE, speeds[1]);
  }
}

#include "BML.h"

static unsigned int
move(int *grid, int *dims, int *locations, int *num, Direction dir, int speed)
{
   int i;
   int r, c, rprime, cprime;
   unsigned int numMoved = 0;

   for(i = 0; i < *num; i++) {
      r = locations[i] - 1;
      c = locations[i + *num] - 1;
    
      if(dir == RED) {
         rprime = r;
         cprime = c + speed > dims[1] - 1 ?  c + speed - dims[1] : c + speed;  /* (c + speed) % dims[1]; */ 
      } else {
         rprime =  r - speed < 0 ? dims[0] + r - speed : r - speed;  /*  (r - speed) % dims[0]; */ 
         cprime = c;
      }
      if(grid[rprime + dims[0] * cprime] == 0) {
          grid[r + dims[0] * c] =  0;
          grid[rprime + dims[0] * cprime] =  dir;
          if(dir == RED)
             locations[i + *num] = cprime + 1;
          else
             locations[i] = rprime + 1;
          numMoved++;
      }
   }

   return(numMoved);
}
