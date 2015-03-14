#!/bin/sh
#export VARIABLE=0
LoaderVersion="v3.0"
FILEFIFO="/usr/loader/PUBLIC"
LOGFILE=/home/updateLog.txt
ERRORCODE="/a/b/c/d/e/f/g/h"
export ERRORCODE
export DISPLAY=:0.0
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/lib:/lib

#loaderPipeServer X1 X2 X3 X4
#X1 fifo file
#X2 app title
#X3 label text
#X4 jpeg to display

#loaderClient X1 X2y1y2y3
#X1 fifo file
#X2 text - last 3 letters are important
#y1 size of font 
#possible values 1 -arial 12
#2 -arial 14
#3 -arial 16
#y2 - color of fonts -r red, -b black
#y3 - progress bar type and stop
#p - progress bar -pulse
#n - progress-bar -fill 100%
#s - Exit from thread, close sockets

#test and quiet

exec 1>/dev/null 2>/dev/null

/usr/loader/loaderPipeServer $FILEFIFO "LAN Loader App "$LoaderVersion "Starting update." "/usr/loader/lan.jpg" &  #run server as background
#wait for loadPipeServer pid
while [ -z $(ps -ef |grep loaderPipeServer | grep -v grep) ];
do
echo "starting app..."
sleep 2
done

/usr/loader/loaderPipeClient $FILEFIFO "Unzipping. Please wait...2bp"
unzip /temp/*.zip -d /temp

sleep 2
sync
echo 3 > /proc/sys/vm/drop_caches

if [ -d /temp/AutoRun/ ] ; then	# if AutoRun/LTUpdate exists

[ ! -f "$LOGFILE" ] &&  > "$LOGFILE"
echo "*************************************************************************************"	>> "$LOGFILE"
echo "System update: `date +"%H:%M %d.%m.%Y"`" 	>> "$LOGFILE"


if [ -f /temp/AutoRun/updateNotice.txt ]; then	# if uImage
echo "Notice: "	>> "$LOGFILE"
while read myline
		do
  		echo $myline 	>> "$LOGFILE"
		done < "/temp/AutoRun/updateNotice.txt"
fi


if [ -f /temp/AutoRun/preUpdate.sh ] ; then
	chmod u+rwx /temp/AutoRun/preUpdate.sh 
	/temp/AutoRun/preUpdate.sh 
	RETCODE=$?
	ERRORCODE=${ERRORCODE/a/$RETCODE} 
	echo "preUpdate - Error code: "$RETCODE 	>> "$LOGFILE"
	if [ $RETCODE != 0 ]; then
		umount /mnt/nand
		exit;
		fi;
	
	fi
fi


#killall chrome-start 
#killall intelliCon3

#3000 port
#"USB Loader App" title
#" " label text
#"/usr/loader/usb1.jpg" - jpeg to display

if [ -d /temp/AutoRun/LTSystemUpdate ] ; then

	nfs_present=$(fw_printenv bootargs)
	nfs_present=${nfs_present#*root=}
	#nfs_present=${nfs_present%/dev/nfs*}


if [ -f /temp/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar.bz2 ]; then	#yaffs2 uImage
	#sync; echo 3 > /proc/sys/vm/drop_caches
	if [ "$nfs_present" = "/dev/nfs" ]; then 
	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2 (from NFS, erasing all flash). Please wait...2bp"
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2. Please wait...2bp"
		fi;
	mkdir /mnt/nand
	mount -t yaffs2 /dev/mtdblock4 /mnt/nand
	tar jxvf /temp/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar.bz2 -C /mnt/nand/
	RETCODE=$?
	ERRORCODE=${ERRORCODE/b/$RETCODE}
	echo "FS (tar.bz2) update - Error code: "$RETCODE 	>> "$LOGFILE"
    	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
	if [ $RETCODE == 0 ]; then
	    	sed -i "3cfile system (yaffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		umount /mnt/nand
		else
		 
		/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
		umount /mnt/nand
	
		exit
		fi
	fi

if [ -f /temp/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar ]; then	#yaffs2 uImage
	if [ "$nfs_present" = "/dev/nfs" ] ; then 
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2 (from NFS, erasing all flash). Please wait...2bp"
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2. Please wait...2bp"
		fi;
	
	mkdir /mnt/nand
	mount -t yaffs2 /dev/mtdblock4 /mnt/nand
	tar xvf /temp/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar -C /mnt/nand/
	RETCODE=$?
	ERRORCODE=${ERRORCODE/b/$RETCODE}
	echo "FS (tar) update - Error code: "$RETCODE 	>> "$LOGFILE"
	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
	if [ $RETCODE == 0 ]; then
	    	sed -i "3cfile system (yaffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		umount /mnt/nand
		else
		
		/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
		umount /mnt/nand
		
		exit
		fi
	fi


if [ -f /temp/AutoRun/LTSystemUpdate/uImage ]; then	# if uImage
			
		/usr/loader/loaderPipeClient $FILEFIFO "Updating kernel image. Please wait...2bp"
 		flash_eraseall /dev/mtd3
		nandwrite -p /dev/mtd3 /temp/AutoRun/LTSystemUpdate/uImage
		RETCODE=$?
		ERRORCODE=${ERRORCODE/c/$RETCODE}
		echo "kernel update - Error code: "$RETCODE 	>> "$LOGFILE"
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
		if [ $RETCODE != 0 ]; then
		
	    	/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
		exit
		fi
		sed -i "2ckernel updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

if [ -f /temp/AutoRun/LTSystemUpdate/u-boot.bin ]; then	# if uImage
			
		/usr/loader/loaderPipeClient $FILEFIFO "Updating uboot image. Please wait...2bp"
 		flash_eraseall /dev/mtd1
		nandwrite -p /dev/mtd1 /temp/AutoRun/LTSystemUpdate/u-boot.bin
		RETCODE=$?
		ERRORCODE=${ERRORCODE/d/$RETCODE}
		echo "uboot update - Error code: "$RETCODE 	>> "$LOGFILE"
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		if [ $RETCODE != 0 ]; then
	    	/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
		exit
		fi
		sed -i "5cuboot updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

if [ -f /temp/AutoRun/LTSystemUpdate/x-load.bin.ift ]; then	# if uImage
		/usr/loader/loaderPipeClient $FILEFIFO "Updating xload image. Please wait...2bp"
 		flash_eraseall /dev/mtd0
		nandwrite -p /dev/mtd0 /temp/AutoRun/LTSystemUpdate/x-load.bin.ift
		RETCODE=$?
		ERRORCODE=${ERRORCODE/e/$RETCODE}
		echo "xloader update - Error code: "$RETCODE	>> "$LOGFILE"
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
		if [ $RETCODE != 0 ]; then
	    	/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
		exit
		fi	
		sed -i "6cxload updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi


if [ -f /temp/AutoRun/LTSystemUpdate/env_variables ]; then	# if uImage
			
		/usr/loader/loaderPipeClient $FILEFIFO "Updating env. variables. Please wait...2bp"
		while read myline
		do
  		echo $myline
			fw_setenv $myline
			RETCODE=$?
				if [ $RETCODE != 0 ]; then
				ERRORCODE=${ERRORCODE/f/$RETCODE}
				echo "env update - Error code: "$RETCODE 	>> "$LOGFILE"
	    			/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
				exit
				fi
			done < "/temp/AutoRun/LTSystemUpdate/env_variables"
		ERRORCODE=${ERRORCODE/f/$RETCODE}
 		echo "env update - Error code: 0" 	>> "$LOGFILE"
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		sed -i "6cuboot env. updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

fi

if [ -d /temp/AutoRun/LTUpdate ]; then	# if AutoRun/LTUpdate exists
/usr/loader/loaderPipeClient $FILEFIFO "Coping files. Please wait...2bp"
cp -r  /temp/AutoRun/LTUpdate/* /
RETCODE=$?
ERRORCODE=${ERRORCODE/g/$RETCODE}
find -name '*~' -exec rm {} \;
sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
echo "copy files - Error code: "$RETCODE 	>> "$LOGFILE"
if [ $RETCODE != 0 ]; then
/usr/loader/loaderPipeClient $FILEFIFO "ERROR #"$ERRORCODE" ! Please remove the usb stick.3rn"
exit
fi	
sed -i "4cfiles copied at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
fi


if [ -d /temp/AutoRun/ ] ; then	# if AutoRun/LTUpdate exists
	if [ -f /temp/AutoRun/postUpdate.sh ] ; then
	chmod u+rwx /temp/AutoRun/postUpdate.sh
	/temp/AutoRun/postUpdate.sh 
	RETCODE=$?
	ERRORCODE=${ERRORCODE/h/$RETCODE}
	echo "postUpdate - Error code: "$RETCODE	>> "$LOGFILE"
	if [ $RETCODE != 0 ]; then
		umount /mnt/nand
		
		exit;
		fi;
	
	fi
fi


if [ -d /temp/AutoRun/LTSystemUpdate ] || [ -d /temp/AutoRun/LTUpdate ] ; then	# if AutoRun/LTUpdate exists
/usr/loader/loaderPipeClient $FILEFIFO "The system will be rebooted. Please remove the usb stick.3gn"
fi




