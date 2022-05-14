from PIL import Image 

def Mandel(size, max_iteration):
    """View and save the Mandelbrot set.
    size an int, making a size*size image
    max_iteration is the bound before assuming point tends towards infinity"""
    mandel = Image.new("RGB", (size, size))
    for row in range(0, size):
        for col in range(0, size):
            z = 0
            c = complex(((col - size/2)*4/size), ((row - size/2)*4/size))
            iteration = 0
            while (abs(z) <= 2) and (iteration < max_iteration):
                z = z**2 + c
                iteration +=1
            if iteration == max_iteration:
                colour = 255
            else:
                colour = iteration*10%255
            mandel.putpixel((col,row),(colour,0,0))


    mandel = mandel.transpose(Image.FLIP_TOP_BOTTOM)
    mandel.save('MandelbrotSet.png')
    mandel.show()
    
