#! /bin/bash

#need to source environmental variables since cron runs this in a different shell context
. $HOME/.bashrc

# capture the image
# ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y ~/default.jpeg &&
fswebcam -r 1920x1080 --jpeg 85 -D 5 -S 13 default.jpg &&


# convert to base 64 in valid JSON-format
echo "{\"base64String\": \"$(base64 ~/default.jpeg)\"}" > ~/temp-base64-data.json &&

printenv &> where.json

# curl the REST endpoint
curl -H "Content-Type: application/json" -d @/home/pi/temp-base64-data.json  $IMAGE_ENDPOINT
