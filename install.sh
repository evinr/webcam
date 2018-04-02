#! /bin/bash

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
	echo " please run 'source ~/.bashrc' to update this shell" &&
fi

# Setup the crontabs
	(crontab -l 2>/dev/null; echo "*/1 * * * * ~/webcam/image-capture-n-upload.sh") | crontab -

# Setup daily reboot to prevent unexpected behavior
	# printf "@daily /sbin/shutdown -r now \n$(crontab -l root)\n" | sudo crontab -u root -e
	# test this with root
	# TODO
	(crontab -u root -l 2>/dev/null; echo "*/5 * * * * /path/to/job -with args") | crontab -
