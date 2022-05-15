#include <stdio.h>
#include <complex.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <png.h>

#define size 2000
#define max_iteration 40

int image[size][size];

double _Complex c;
double _Complex z;

int main(int argc, char *argv[]) {
  srand(time(NULL));
    
  for (int row=0; row<size; row++) {
    for (int col=0; col<size; col++) {
      c = atof(argv[1])+atof(argv[2])*I;
      z = (((float)col - (float)size/2)*4/size) + (((float)row - (float)size/2)*4/size)*I;
      int iteration = 0;
      while(sqrt(creal(z)*creal(z) + cimag(z)*cimag(z)) < 2 && (iteration < max_iteration)) {
        z = z*z + c;
        iteration++;
      }
      int colour;
      if(iteration == max_iteration) {
        colour = 255;
      } else {
        colour = iteration*10%255;
      }

      image[row][col] = colour;
    }
  }

  FILE* f = fopen("julia.ppm", "wb");
  fprintf(f, "P6\n%i %i 255\n", size, size);

  int random = (rand() % 6) + 1; // random number between 1 and 6 inclusive

  for (int i=0; i<size; i++) {
    for (int j=0; j<size; j++) {
      // makes the colour one of r,g,b,rg,gb,rb
      for (int bit=0; bit<3; bit++) {
        fputc((((random >> bit) ^ 1) ? image[i][j] : 0), f);
      }
    }
  }
    
  fclose(f);
  return 0;
}
