#include <stdio.h>
/*
 A program that prints the bit representation of a
 real number
*/

void showIntegerBits(int value);
void showFloatingPointBits(double value, int *bits);
void showWords();

void showBits(int *bits, int num);
void getBits(char *value, int nbytes, int *bits);

int
main(int argc, char *argv[])
{

  double value;
  int ivalue;
  int bits[64];

  if(argc < 2) {
    fscanf(stdin, "%lf", &value); 
  } else
    sscanf(argv[1], "%lf", &value);

  fprintf(stderr, "%lf\n", value);

  ivalue = (int) value;
//  getBits((char *) &ivalue, sizeof(int), bits);
  getBits((char *) &value, sizeof(double), bits);
  showBits(bits, sizeof(double));

  return(0);
}

void
showBits(int *bits, int num)
{
  int i;
  for(i = 0; i < num * 8; i++)
    fprintf(stderr, "%d", bits[i]);
  fprintf(stderr, "\n");
}

int word[] = {1, 2, 4, 8, 16, 32, 64, 128};

void
showWords()
{
  int i;
  for(i = 0; i < sizeof(word)/sizeof(word[1]); i++)
    fprintf(stderr, "%d %d\n", word[i], word[i] >> i);
  fprintf(stderr, "\n");
}

void
R_getBits(double *value, int *nbytes, int *bits)
{
	getBits((char *) value, *nbytes, bits);
}

void
getBits(char *value, int nbytes, int *bits)
{
   char *ptr;
   int on, i, j, ctr = 0;
   ptr = (char*) value;

   for(i = 0; i < nbytes; i++, ptr++) {
      for(j = 0; j < 8; j++) {
	  on = (*ptr & word[j]) >> j;
          bits[ctr++] = on;
      }
   }
}

void
showFloatingPointBits(double value, int *bits)
{
  getBits((char *) &value, sizeof(double), bits);
}
