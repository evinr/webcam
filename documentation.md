# Webcam Notes
These were the commands that evolved throughout this project with my related thoughts

## Random Notes
##### To list devices:
	v4l2-ctl --list-devices

##### To list device capabilities:
	ffmpeg -f v4l2 -list_formats all -i /dev/video0

##### To list a device settings: 
	v4l2-ctl -d /dev/video1 --list-ctrls

##### To modify a device image settings: 
	v4l2-ctl -d /dev/video1 -c exposure_auto=1 

##### To determine what the webcam is set to:
	v4l2-ctl -d /dev/video0 -V

##### To show all of the different capture modes: 
	v4l2-ctl -d /dev/video0 --list-formats-ext

##### To change the capture mode: 
 	v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1

##### To capture an image and encode it using video4linux2:
	ffmpeg -f video4linux2 -i /dev/video1 -vframes 1 test.jpeg

##### To capture an image after waiting 5 seconds with overwrite and applying the filter turning it 90 degrees clockwise:
	ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" test.jpeg

##### To capture a movie and encode it using video4linux2 at 25 frames per second at a sixe of 640 by 480
	ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 output.mkv

##### Easiest way to upload image to a webserver: 
	aws s3 cp ./image4144.png s3://photobad.com/image.png

##### And all together:
	ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" test.jpeg && aws s3 cp ./test.jpeg s3://photobad.com/a.jpeg

##### And with a dash of persistance:
	*/1 * * * * ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" default.jpeg && aws s3 cp ./default.jpeg s3://photobad.com/default.jpeg && cp -a ./default.jpeg "$(date +"%H%M").jpeg" 

##### With this to take that persistance and make a 60-second timelapse video of the last 24-hours (this fails after the RPi runs out of memory):
	ffmpeg -y -framerate 24 -i %04d.jpeg output.mp4

##### Then burn it all down and start with a new approach:
	ffmpeg -ar 44100 -ac 2 -f alsa -i hw:1,0 -f v4l2 -codec:v h264 -framerate 30 -video_size 1920x1080 -itsoffset 0.5 -i /dev/video0 -copyinkf -codec:v copy -codec:a aac -ab 128k -g 10 -f flv rtmp://a.rtmp.youtube.com/live2/(Your Stream Key Here)

##### Then realize that the internet is not that stable and a RPi is a RPi and that long polling with no persistance aint so bad:
	ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" test.jpeg && aws s3 cp ./test.jpeg s3://photobad.com/a.jpeg
		
##### And really a webcam does not have the highest quality CCD, so we use an old DSLR
	gphoto2 --capture-image-and-download --filename "locationOfFile"

##### And since the aws s3 app is not robust enough to bypass the SG Proxy in some places, we dumb down the transmiting to a simple POST...
	curl -H "Content-Type: application/json" -d '{'$(openssl base64 -A -in jenkins.png)' }'  http://example.com

##### But a big image exceeds the argument size limits of curl, so the image needs to be JSON'd first
	echo "{\"base64String\": \"$(base64 default.jpeg)\"}" > b64.txt
	curl -H "Content-Type: application/json" -d @b64.txt http://example.com
	


## Cron Scheduling 
### Generic Crontab Insertion
#### This is to insert an additional cron job without having to directly edit the file.
		export EDITOR="tee"
		printf "0 * * * * /bin/echo 'Hello World <3<3<3<3<3' \n$(crontab -l)\n" | crontab -e
		unset EDITOR
### Specific Crontab Jobs
#### These are the jobs that need to be ran at regular intervals.
		# Runs at startup
		@reboot connectToInternet
		# Runs evey minute
		*/1 * * * * takePicture
### Su without Entering a Password
#### This will update the cron job for the root user
		sudo crontab -u root -e
#### Then add this line to the cron file
		@daily /sbin/shutdown -r now
		
### Reset USB from Command Line
#### Download the Script
		wget -c --no-check-certificate https://gist.githubusercontent.com/x2q/5124616/raw/3f6e5f144efab2bc8e9d02b95b8301e1e0eab669/usbreset.c -O usbreset.c
#### Compile and Build
		cc usbreset.c -o usbreset
#### Mark as Executable
		chmod +x usbreset
#### Determine Your Devices
		lsusb -t
#### Add to the Root Cron Job
		sleep 30 && /home/pi3/usbreset /dev/bus/usb/001/004



## Localized Wifi Network Setup
### Autoconnect to Open Networks
Make sure to bypass login/acceptance screens

### Remote SSH Setup
Need to determine the best and secure way of doing this

## Image Storage
### S3 Bucket
Holds the image
### Lambda Function
#### This catches the image being transmitted via POST
		exports.handler = function(event, context, callback) {
			var AWS = require('aws-sdk');
			    AWS.config.update({accessKeyId: process.env.accessKeyId, secretAccessKey: process.env.secretAccessKey});
			var s3 = new AWS.S3();
			var now = new Date().getTime();
			var bod = event.body;
			var params = {
					Bucket: 'photobad.com',
					// assumes it will always be jpeg
					Key: 'default.jpeg',
					Body: new Buffer(event.base64String, 'base64')
				};

			s3.putObject(params, function(err, data) {
				if (err) {
				    callback(null, 'an error occured ' + err);
				}
				// if the file object is uploaded successfully to s3 then you get your full url back
				callback(null, 'all good ' + params.Key);

			})
		}

## Video Features
### Express Server
This is needed for a ws stream. 
		
	
