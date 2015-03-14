#!/bin/sh
export DISPLAY=:0.0
application=$(fw_printenv application)
if [[ -n "$application" ]] ; then
EnableCursor=$(fw_printenv EnableCursor)
if [ "$EnableCursor" = "EnableCursor=no" ]; then
if [ `ls -d /sys/class/input/mouse* | wc -l` -eq 1 ]; then
echo "hide cursor..."
xsetroot -cursor /usr/mouse_ptr/emptycursor /usr/mouse_ptr/emptycursor 
fi
fi
fi

