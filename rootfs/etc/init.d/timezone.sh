#
# timezone.sh	Miscellaneous things to be done during bootup.
#

TZ1=`cat /etc/timezone`
ln -sf /usr/share/zoneinfo/$TZ1 /etc/localtime 

