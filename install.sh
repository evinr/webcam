#! /bin/bash

# Setup environmental variables
  # checks if the environmental variable is at least 20 characters long
if [ "${#IMAGE_ENDPOINT}" -lt "20" ]; then 
		echo -e "\n🙅 Your IMAGE_ENDPOINT environmental variable is not set 🌎\n" && 
    echo "Please enter then end point of your image capturing funtion: " &&
    read endpoint
    # verify that the ~/.bash_profile is available and correct on Linux
    echo $endpoint >> ~/.bash_profile
fi

# Setup the crontabs
# ffmpeg -f v4l2 -i /devvideo0 -vframes 1 -ss 0:0:5 -y -vf "transpose=2" default.jpeg
export EDITOR="tee"
	printf "*/1 * * * * ~/webcam/image-capture-n-upload.sh \n$(crontab -l)\n" | crontab -e
unset EDITOR


# Setup daily reboot to prevent unexpected behavior
export EDITOR="tee"
printf "@daily /sbin/shutdown -r now \n$(crontab -l root)\n" | sudo crontab -u root -e
unset EDITOR
