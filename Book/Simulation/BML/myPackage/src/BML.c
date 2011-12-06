
#include "BML.h"

unsigned int
bml_move(int *grid, int *dims, int *locations, int *num, Direction dir, int speed)
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
