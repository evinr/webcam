# Webcam
Just figuring out how to build a webcam using off the shelf components


To list devices:
v4l2-ctl --list-devices

To list device capabilities:
ffmpeg -f v4l2 -list_formats all -i /dev/video0

To list a device settings: 
v4l2-ctl -d /dev/video1 --list-ctrls

To modify a device image settings: 
v4l2-ctl -d /dev/video1 -c exposure_auto=1 

To determine what the webcam is set to:
v4l2-ctl -d /dev/video0 -V

To show all of the different capture modes: 
v4l2-ctl -d /dev/video0 --list-formats-ext

To change the capture mode: 
 v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1

To capture an image and encode it using video4linux2:
ffmpeg -f video4linux2 -i /dev/video1 -vframes 1 test.jpeg

To capture an image after waiting 5 seconds with overwrite and applying the filter turning it 90 degrees clockwise:
ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" test.jpeg

To capture a movie and encode it using video4linux2 at 25 frames per second at a sixe of 640 by 480
ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 output.mkv

Easiest way to upload image to a webserver: 
aws s3 cp ./image4144.png s3://photobad.com/image.png

And all together:
ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" test.jpeg && aws s3 cp ./test.jpeg s3://photobad.com/a.jpeg

And with a dash of persistance:
*/1 * * * * ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" default.jpeg && aws s3 cp ./default.jpeg s3://photobad.com/default.jpeg && cp -a ./default.jpeg "$(date +"%H%M").jpeg" 

Then burn it all down and start with a new approach:
ffmpeg -ar 44100 -ac 2 -f alsa -i hw:1,0 -f v4l2 -codec:v h264 -framerate 30 -video_size 1920x1080 -itsoffset 0.5 -i /dev/video0 -copyinkf -codec:v copy -codec:a aac -ab 128k -g 10 -f flv rtmp://a.rtmp.youtube.com/live2/(Your Stream Key Here)

Then realize that the internet is not that stable and a RPi is a RPi...




##TODO:
	###Setup Script

	2. Edit crontab in Batch Mode

You can edit the crontab in batch mode using various methods (for example, using sed).

Example: Change output redirection from write to append for all cron jobs.

$ crontab -l
* * * * * /bin/date > /tmp/date-out
* * * * * /bin/ls > /tmp/ls-out

$ crontab -l | sed 's/>/>>/' | crontab -

$ crontab -l
* * * * * /bin/date >> /tmp/date-out
* * * * * /bin/ls >> /tmp/ls-out


		Video Device Listing
		Max Video Resolution Supported
		Local Network Setup
		Remote SSH Setup

	###