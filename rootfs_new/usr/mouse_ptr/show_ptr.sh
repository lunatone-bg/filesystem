#!/bin/sh
export DISPLAY=:0.0
application=$(fw_printenv application)
if [[ -n "$application" ]] ; then
EnableCursor=$(fw_printenv EnableCursor)
if [ "$EnableCursor" = "EnableCursor=no" ]; then
if [ `ls -d /sys/class/input/mouse* | wc -l` -gt 1 ]; then
echo "show cursor..."
xsetroot -cursor_name left_ptr
fi
fi
fi

