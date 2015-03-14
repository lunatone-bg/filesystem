#!/bin/sh

export DISPLAY=:0.0
#wait for root focus

while [ "$(expr "$(xdpyinfo | grep focus)" : '.*window*.')" = "0" ];	
do
#xsetroot -cursor /usr/mouse_ptr/emptycursor /usr/mouse_ptr/emptycursor
usleep 10000;
done 

#echo "hide cursor..."
if [ `ls -d /sys/class/input/mouse* | wc -l` -eq 1 ]; then
xsetroot -cursor /usr/mouse_ptr/emptycursor /usr/mouse_ptr/emptycursor
fi;





