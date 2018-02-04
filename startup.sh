#! /bin/bash

# configures the webcam to take HD images
# TODO determine max resolution and select it via v4l-utils
v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1

cd webcam
git pull
