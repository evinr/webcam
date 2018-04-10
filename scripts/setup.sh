#!/bin/bash

# This script is used to setup the webcam for the first run

# To list devices:
v4l2-ctl --list-devices


## TODO: Transform these into a dynamic call, where the max width and height is tokenized and used in the next call
# To show all of the different capture modes: 
v4l2-ctl -d /dev/video0 --list-formats-ext

# To change the capture mode: 
v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1


## TODO: Add to the cron jobs 
# Need to reboot every two weeks