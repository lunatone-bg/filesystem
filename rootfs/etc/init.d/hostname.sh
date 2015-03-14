#!/bin/sh
#
# hostname.sh	Set hostname.
#
# Version:	@(#)hostname.sh  1.10  26-Feb-2001  miquels@cistron.nl
#




ethaddr=$(fw_printenv ethaddr)
ethaddr=${ethaddr##ethaddr=}
if  [ -e /etc/hostname ] ;  then 
echo "hostname..."
else
echo "Setting up hostname..."
touch /etc/hostname
echo LT_${ethaddr:0:2}${ethaddr:3:2}${ethaddr:6:2}${ethaddr:9:2}${ethaddr:12:2}${ethaddr:15:2} | tr '[:lower:]' '[:upper:]' > /etc/hostname
#tr "[:lower:]" "[:upper:]" < /etc/hostname
fi

if test -f /etc/hostname
then
	hostname -F /etc/hostname
fi
