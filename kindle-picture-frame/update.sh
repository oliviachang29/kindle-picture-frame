#!/bin/sh
#
##############################################################################
#
# Fetch weather screensaver from a configurable URL.

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source /mnt/us/kindle-picture-frame/config.sh
fi

# enable wireless if it is currently off
if [ 0 -eq `lipc-get-prop com.lab126.cmd wirelessEnable` ]; then
	echo "WiFi is off, turning it on now"
	lipc-set-prop com.lab126.cmd wirelessEnable 1
	DISABLE_WIFI=1
fi

# wait for network to be up
TIMER=${NETWORK_TIMEOUT}     # number of seconds to attempt a connection
CONNECTED=0                  # whether we are currently connected
while [ 0 -eq $CONNECTED ]; do
	# test whether we can ping outside
	/bin/ping -c 1 $TEST_DOMAIN > /dev/null && CONNECTED=1

	# if we can't, checkout timeout or sleep for 1s
	if [ 0 -eq $CONNECTED ]; then
		TIMER=$(($TIMER-1))
		if [ 0 -eq $TIMER ]; then
			echo "No internet connection after ${NETWORK_TIMEOUT} seconds, aborting."
			break
		else
			sleep 1
		fi
	fi
done

if [ 1 -eq $CONNECTED ]; then
	python3 /mnt/us/kindle-picture-frame/getImage.py
  /mnt/us/kindle-picture-frame/writeImage.sh
  echo "Updated screen saver"
fi

# disable wireless if necessary
if [ 1 -eq $DISABLE_WIFI ]; then
	echo "Disabling WiFi"
	# lipc-set-prop com.lab126.cmd wirelessEnable 0
fi
