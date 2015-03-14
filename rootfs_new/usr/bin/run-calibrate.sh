#! /bin/sh

if [ -e /dev/input/touchscreen0 ]; then
	if [ -x /usr/bin/ts_calibrate ]; then
	        exec /usr/bin/ts_calibrate
	fi
fi

