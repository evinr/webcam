#! /bin/bash

# capture the image
ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" default.jpeg

# convert to base 64 in valid JSON-format
echo "{\"base64String\": \"$(base64 default.jpeg)\"}" > temp-base64-data.json

# curl the REST endpoint
curl -H "Content-Type: application/json" -d @temp-base64-data.json  $IMAGE_ENDPOINT
