# webcam
Just figuring out how to build a webcam using off the shelf components


To list devices:
v4l2-ctl --list-devices

To list device capabilities:
ffmpeg -f v4l2 -list_formats all -i /dev/video0

To capture an image and encode it using video4linux2:
ffmpeg -f video4linux2 -i /dev/video1 -vframes 1 test.jpeg

To capture a movie and encode it using video4linux2 at 25 frames per second at a sixe of 640 by 480
ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 output.mkv
