#!/bin/sh

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source /mnt/us/kindle-picture-frame/config.sh
fi

# load utils
if [ -e "utils.sh" ]; then
	source /mnt/us/kindle-picture-frame/utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi

if [ -e /etc/upstart ]; then
	logger "Enabling online screensaver auto-update"

	mntroot rw
	cp pictureframe.conf /etc/upstart/
	mntroot ro

	start pictureframe
else
	logger "Upstart folder not found. upstart file not copied - should implement classic startup script for this kindle"
	lipc-get-prop com.lab126.powerd status | grep "Screen Saver" 
	if [ $? -eq 1 ]
	then
		powerd_test -p
		# simulate power button to go into screensaver mode
	fi
	
	sleep 5
	/bin/sh /mnt/base-us/kindle-picture-frame/scheduler.sh &
	touch /mnt/us/kindle-picture-frame/enabled
fi
