#! /bin/bash

# install apps needed to configure webcam
sudo apt-get install v4l-utils -y
# configures the webcam to take HD images
# TODO determine max resolution and select it via v4l-utils
v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1

# Setup environmental variables
  # checks if the environmental variable is at least 20 characters long
if [ "${#IMAGE_ENDPOINT}" -lt "20" ]; then 
	echo -e "\n🙅 Your IMAGE_ENDPOINT environmental variable is not set 🌎\n" && 
	echo "Please enter then end point of your image capturing funtion: " &&
	read endpoint
	# verify that a POST request can be made via the same function that is making the POST
	# TODO
	# verify that the ~/.bash* is available what is being used on the system
	# TODO
	# adds what was entered on the command line to the bash config file
	echo $endpoint >> ~/.bashrc
	echo " please run 'source ~/.bashrc' to update this shell"
fi

# Setup the crontabs
	# TODO check if the script is already a cron job
	(crontab -l 2>/dev/null; echo -e "IMAGE_ENDPOINT='$IMAGE_ENDPOINT'\n*/1 * * * * ~/webcam/image-capture-n-upload.sh") | crontab -

# Setup daily reboot to prevent unexpected behavior
	# printf "@daily /sbin/shutdown -r now \n$(crontab -l root)\n" | sudo crontab -u root -e
	# test this with root
	# TODO
	(sudo crontab -u root -l 2>/dev/null; echo "*/5 * * * * /path/to/job -with args") | sudo crontab - -u root
