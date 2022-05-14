from PIL import Image 

def Julia(init, size, max_iteration):
    """View and save the filled-in Julia set for the complex number "init".
    size an int, making a size*size image
    max_iteration is the bound before assuming point tends towards infinity"""
    julia = Image.new("RGB", (size, size))
    for row in range(0, size):
        for col in range(0, size):
            c = init
            z = complex(((col - size/2)*4/size), ((row - size/2)*4/size))
            iteration = 0
            while (abs(z) <= 2) and (iteration < max_iteration):
                z = z**2 + c
                iteration +=1
            if iteration == max_iteration:
                colour = 255
            else:
                colour = iteration*10%255
            julia.putpixel((col,row),(colour,0,0))


    julia = julia.transpose(Image.FLIP_TOP_BOTTOM)
    julia.save('JuliaSet.png')
    julia.show()