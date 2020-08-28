#!/bin/sh
#
##############################################################################
#
# Fetch weather screensaver from a configurable URL at configurable intervals.
#
# Features:
#   - updates even when device is suspended
#   - refreshes screensaver image if active
#   - turns WiFi on and back off if necessary
#   - tries to use as little CPU as possible
#
##############################################################################

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
  source /mnt/us/kpf/config.sh
else
  # set default values
  INTERVAL=240
  RTC=0
fi

# load utils
if [ -e "utils.sh" ]; then
  source /mnt/us/kpf/utils.sh
else
  echo "Could not find utils.sh in $(pwd)"
  exit
fi

UNSPLASH=true

# runs when the system displays the screensaver
do_ScreenSaver() {
  logger "display screensaver with unsplash: $UNSPLASH"
  sh /mnt/us/kpf/update.sh $UNSPLASH
  if [ "$UNSPLASH" = true ]; then
    UNSPLASH=false
  else
    UNSPLASH=true
  fi
}

# runs when the RTC wakes the system up
wake_up_rtc() {
  logger "wakeup alarm RTC"
}

# runs when the system wakes up
# this can be for many reasons (rtc, power button)
wake_up() {
  # lipc-set-prop com.lab126.wifid enable 1
  logger "wakeup alarm"
  POWERD_STATES=$(lipc-get-prop -s com.lab126.powerd state)
  logger "PowerD state: $POWERD_STATES"
  if [ "$POWERD_STATES" == "screenSaver" ] || [ "POWERD_STATES" == "suspended" ]; then
    wake_up_rtc
  fi
}

# runs when in the readyToSuspend state;
# sets the rtc to wake up
# delta = amount of seconds to wake up in
ready_suspend() {
  logger 'ready suspend'
  # lipc-set-prop com.lab126.wifid enable 0
  # delta="10"
  # lipc-set-prop -i com.lab126.powerd rtcWakeup $delta
  # lipc-set-prop com.lab126.powerd deferSuspend 30000000
}

# main loop, waits for powerd events
lipc-wait-event -m com.lab126.powerd goingToScreenSaver,wakeupFromSuspend,readyToSuspend | while read event; do
  state=${event%% *}
  if [ "$state" == "goingToScreenSaver" ]; then
    do_ScreenSaver
  elif [ "$state" == "wakeupFromSuspend" ]; then
    wake_up
  elif [ "$state" == "readyToSuspend" ]; then
    ready_suspend
  fi
done
