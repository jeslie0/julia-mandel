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
int i;
int j;
int colour;
int iteration;
int row;
int col;

int main(int argc, char *argv[]) {
    int test;
    srand(time(NULL));
   
    test = rand() % 6;
    for(row=0; row<size; row++) {
        for(col=0; col<size; col++) {
            c = atof(argv[1])+atof(argv[2])*I;
            z = (((float)col - (float)size/2)*4/size) + (((float)row - (float)size/2)*4/size)*I;
            iteration = 0;
            while(sqrt(creal(z)*creal(z) + cimag(z)*cimag(z)) < 2 && (iteration < max_iteration)) {
                z = z*z + c;
                iteration++;
            }
            if(iteration == max_iteration) {
                colour = 255;
            } else {
                colour = iteration*10%255;
            }

            image[row][col] = colour;
        }
    }

    FILE *f = fopen("/home/pi/Programming/Twitter/julia.ppm", "wb");
    fprintf(f, "P6\n%i %i 255\n", size, size);

    if (test == 0) {
        for(i=0; i<size; i++) {
            for(j=0; j<size; j++) {
                fputc(image[i][j],f);
                fputc(0,f);
                fputc(0,f);
            }
        }
    } else if (test == 1) {
        for(i=0; i<size; i++) {
            for(j=0; j<size; j++) {
                fputc(0,f);
                fputc(image[i][j],f);
                fputc(0,f);
           }
        }
    } else if (test == 2) {
        for(i=0; i<size; i++) {
            for(j=0; j<size; j++) {
                fputc(0,f);
                fputc(0,f);
                fputc(image[i][j],f);
           }
        }
    } else if (test == 3) {
        for(i=0; i<size; i++) {
            for(j=0; j<size; j++) {
                fputc(image[i][j],f);
                fputc(image[i][j],f);
                fputc(0,f);
            }
        }
    } else if (test == 3) {
        for(i=0; i<size; i++) {
            for(j=0; j<size; j++) {
                fputc(image[i][j],f);
                fputc(0,f);
                fputc(image[i][j],f);
            }
        }
    } else {
        for(i=0; i<size; i++) {
            for(j=0; j<size; j++) {
                fputc(0,f);
                fputc(image[i][j],f);
                fputc(image[i][j],f);
           }
        }
    };


    fclose(f);
    return 0;
}
