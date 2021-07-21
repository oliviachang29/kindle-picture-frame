#!/bin/sh

/etc/init.d/framework stop
/etc/init.d/powerd stop
sh /mnt/us/kpf/displayWeather.sh
