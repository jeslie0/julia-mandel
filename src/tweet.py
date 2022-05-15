#!/usr/bin/env python3

import os
import sys
import tweepy
import time
import random
from PIL import Image
from PIL import ImageEnhance
from subprocess import call

def randy():
    z = random.uniform(-1, 1)
    return z

def tweetimg(api, path):
    z_re = randy()
    z_im = randy()
    
    call(["{0}/julia.out".format(path), str(z_re), str(z_re)])

    im = Image.open('{0}/julia.ppm'.format(path))
    enhancer = ImageEnhance.Brightness(im)
    im = enhancer.enhance(1.5)
    im = im.convert('RGBA')

    pix = im.getpixel((0,0))
    newpix = (pix[0], pix[1], pix[2], 254)
    im. putpixel((0,0), newpix)

    im.save('{0}/julia.png'.format(path))

    if z_im >= 0:
        api.update_status_with_media('The filled-in Julia Set for c={0:.4f} + {1:.4f}i #fractals'.format(z_re, z_im), '{0}/julia.png'.format(path))
    else:
         api.update_status_with_media('The filled-in Julia Set for c={0:.4f} - {1:.4f}i #fractals'.format(z_re, -z_im), '{0}/julia.png'.format(path))

random.seed()

keyfile = sys.argv[1]
with open(keyfile) as file:
    lines = file.readlines()
    lines = [line.rstrip() for line in lines]
    CONSUMER_KEY = lines[0]
    CONSUMER_SECRET = lines[1]
    ACCESS_KEY = lines[2]
    ACCESS_SECRET = lines[3]



auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
api = tweepy.API(auth)

path = os.getcwd()

if os.path.isfile("{0}/julia.out".format(path)) == True:
    tweetimg(api, path)
else:
    call(["gcc", "-O", "-lm", "{0}/julia.c".format(path), "-o", "{0}/julia.out".format(path)])
    tweetimg(api, path)
    
