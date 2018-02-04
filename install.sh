#! /bin/bash

# Setup environmental variables
  # checks if the environmental variable is at least 20 characters long
if [ "${#IMAGE_ENDPOINT}" -lt "20" ]; then 
	echo -e "\n🙅 Your IMAGE_ENDPOINT environmental variable is not set 🌎\n" && 
	echo "Please enter then end point of your image capturing funtion: " &&
	read endpoint
	echo "export IMAGE_ENDPOINT=$endpoint" >> ~/.bashrc &&
	echo " please run 'source ~/.bashrc' to update this shell" &&
	exit 1
fi

# Setup the crontabs
	# tests if any crontabs exist
export EDITOR="tee"
	printf "*/1 * * * * ~/webcam/image-capture-n-upload.sh" | crontab -e
unset EDITOR


# Setup daily reboot to prevent unexpected behavior
export EDITOR="tee"
printf "@daily /sbin/shutdown -r now \n$(crontab -l root)\n" | sudo crontab -u root -e
unset EDITOR
