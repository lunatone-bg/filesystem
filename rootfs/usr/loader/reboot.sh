#!/bin/sh
FILEFIFO="/usr/loader/PUBLIC"
if [ `grep -c '"reboot_required": true' /usr/loader/.config/'last update'` = 1 ]; then 
export DISPLAY=:0.0
echo "Rebooting..."
sed -i 's/"reboot_required": true/"reboot_required": false/g' /usr/loader/.config/'last update'	
#stop thread, close sockets ...	
/usr/loader/loaderPipeClient $FILEFIFO "Rebooting...2bn"
/etc/init.d/save-rtc.sh
reboot
else
killall loaderPipeServer
fi
