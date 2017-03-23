#!/bin/bash

# This script is used to decrement the file names in a directory

for totalFiles in *.jpeg; do 
	# set the value of the images curent ordering
	let rootFileOrder=$(basename $totalFiles .jpeg)
	if [ $rootFileOrder = 1 ]; then
		# Discard the first file
	else
		# Lower the sequential file order by one
		$(cp -a $totalFiles "$(($rootFileOrder - 1))".jpeg)
	fi
done;
