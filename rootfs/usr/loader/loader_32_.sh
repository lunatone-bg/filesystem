#!/bin/sh
#export VARIABLE=0
FILEFIFO="/usr/loader/PUBLIC"
mkdir /mnt/usb
for letters in a b c d e f
do

i=1;
bb="sd"$letters
for DEV in /dev/sd$letters*
do
mount /dev/$bb /mnt/usb
export DISPLAY=:0.0

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





if [ -d /mnt/usb/AutoRun/LTSystemUpdate ] || [ -d /mnt/usb/AutoRun/LTUpdate ] ; then	# if AutoRun/LTUpdate exists
/usr/loader/loaderPipeServer $FILEFIFO "USB Loader App" "Starting update ..." "/usr/loader/usb1.jpg" &  #run server as background
#wait for loadPipeServer pid
while [ -z $(ps -ef |grep loaderPipeServer | grep -v grep) ];
do
echo "starting app..."
sleep 2
done 
fi
#3000 port
#"USB Loader App" title
#" " label text
#"/usr/loader/usb1.jpg" - jpeg to display

if [ -d /mnt/usb/AutoRun/LTSystemUpdate ] ; then

	nfs_present=$(fw_printenv bootargs)
	nfs_present=${nfs_present#*root=}
	nfs_present=${nfs_present%/dev/nfs*}

if [ -f /mnt/usb/AutoRun/LTSystemUpdate/rootfs_jffs2.tar.bz2 ]; then	#jffs2 image
	
	if [ $nfs_present="" ]; then 
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs (from NFS, erasing all flash) - jffs2. Please wait...2bp"
		flash_eraseall -j /dev/mtd4
		
	else
#"localhost"		
#3000 port
#"USB Loader App" "Updating rootfs - jffs2. Please wait...2bp" label text
#Arial 14, black, pulse
		/usr/loader/loaderPipeClient $FILEFIFO "USB Loader App" "Updating rootfs - jffs2. Please wait...2bp"

		fi;
		
	mkdir /mnt/nand
	mount -t jffs2 /dev/mtdblock4 /mnt/nand
	tar jxvf /mnt/usb/AutoRun/LTSystemUpdate/rootfs_jffs2.tar.bz2 -C /mnt/nand/
	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
	sed -i "3cfile system (jffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
	umount /mnt/nand
	fi


if [ -f /mnt/usb/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar.bz2 ]; then	#yaffs2 uImage
	#sync; echo 3 > /proc/sys/vm/drop_caches
	if [ $nfs_present="" ]; then 
	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2 (from NFS, erasing all flash). Please wait...2bp"
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2. Please wait...2bp"
		flash_eraseall /dev/mtd4
		fi;
	mkdir /mnt/nand
	mount -t yaffs2 /dev/mtdblock4 /mnt/nand
	tar jxvf /mnt/usb/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar.bz2 -C /mnt/nand/
	RETCODE=$?
    	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
	if [ $RETCODE == 0 ]; then
	    	sed -i "3cfile system (yaffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		umount /mnt/nand
		else
		/usr/loader/loaderPipeClient $FILEFIFO "ERROR - #"$RETCODE" ! Please remove the usb stick.3rn"
		umount /mnt/nand
		umount /mnt/usb
		exit
		fi
	fi

if [ -f /mnt/usb/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar ]; then	#yaffs2 uImage
	if [ $nfs_present="" ]; then 
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2 (from NFS, erasing all flash). Please wait...2bp"
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - yaffs2. Please wait...2bp"
		flash_eraseall /dev/mtd4
		fi;
	mkdir /mnt/nand
	mount -t yaffs2 /dev/mtdblock4 /mnt/nand
	tar xvf /mnt/usb/AutoRun/LTSystemUpdate/rootfs_yaffs2.tar -C /mnt/nand/
	RETCODE=$?
	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
	if [ $RETCODE == 0 ]; then
	    	sed -i "3cfile system (yaffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		umount /mnt/nand
		else
		/usr/loader/loaderPipeClient $FILEFIFO "ERROR - #"$RETCODE" ! Please remove the usb stick.3rn"
		umount /mnt/nand
		umount /mnt/usb
		exit
		fi
	fi


if [ -f /mnt/usb/AutoRun/LTSystemUpdate/rootfs_ubi.img ]; then
	
	if [ $nfs_present="" ]; then 
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - ubifs (from NFS, erasing all flash) . Please wait...2bp"
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loaderPipeClient $FILEFIFO "Updating rootfs - ubifs. Please wait...2bp"
		fi;
		nandwrite /dev/mtd4 /mnt/usb/AutoRun/LTSystemUpdate/rootfs_ubi.img 
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		sed -i "3cfile system (ubufs) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi


if [ -f /mnt/usb/AutoRun/LTSystemUpdate/uImage ]; then	# if uImage
			
		/usr/loader/loaderPipeClient $FILEFIFO "Updating kernel image. Please wait...2bp"
 		flash_eraseall /dev/mtd3
		nandwrite -p /dev/mtd3 /mnt/usb/AutoRun/LTSystemUpdate/uImage
		RETCODE=$?
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
		if [ $RETCODE != 0 ]; then
	    	/usr/loader/loaderPipeClient $FILEFIFO "ERROR - #"$RETCODE" ! Please remove the usb stick.3rn"
		exit
		fi
		sed -i "2ckernel updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

if [ -f /mnt/usb/AutoRun/LTSystemUpdate/u-boot.bin ]; then	# if uImage
			
		/usr/loader/loaderPipeClient $FILEFIFO "Updating uboot image. Please wait...2bp"
 		flash_eraseall /dev/mtd1
		nandwrite -p /dev/mtd1 /mnt/usb/AutoRun/LTSystemUpdate/u-boot.bin
		RETCODE=$?
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		if [ $RETCODE != 0 ]; then
	    	/usr/loader/loaderPipeClient $FILEFIFO "ERROR - #"$RETCODE" ! Please remove the usb stick.3rn"
		exit
		fi
		sed -i "5cuboot updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

if [ -f /mnt/usb/AutoRun/LTSystemUpdate/x-load.bin.ift ]; then	# if uImage
		/usr/loader/loaderPipeClient $FILEFIFO "Updating xload image. Please wait...2bp"
 		flash_eraseall /dev/mtd0
		nandwrite -p /dev/mtd0 /mnt/usb/AutoRun/LTSystemUpdate/x-load.bin.ift
		RETCODE=$?
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'	
		if [ $RETCODE != 0 ]; then
	    	/usr/loader/loaderPipeClient $FILEFIFO "ERROR - #"$RETCODE" ! Please remove the usb stick.3rn"
		exit
		fi	
		sed -i "6cxload updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi


if [ -f /mnt/usb/AutoRun/LTSystemUpdate/env_variables ]; then	# if uImage
			
		/usr/loader/loaderPipeClient $FILEFIFO "Updating env. variables. Please wait...2bp"
		while read myline
		do
  		echo $myline
			fw_setenv $myline
			RETCODE=$?
				if [ $RETCODE != 0 ]; then
	    			/usr/loader/loaderPipeClient $FILEFIFO "ERROR - #"$RETCODE" ! Please remove the usb stick.3rn"
				exit
				fi
			done < "/mnt/usb/AutoRun/LTSystemUpdate/env_variables"
 		
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		sed -i "6cuboot env. updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

fi

if [ -d /mnt/usb/AutoRun/LTUpdate ]; then	# if AutoRun/LTUpdate exists
/usr/loader/loaderPipeClient $FILEFIFO "Coping files. Please wait...2bp"
cp -r  /mnt/usb/AutoRun/LTUpdate/* /
sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
sed -i "4cfiles copied at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'

fi

if [ -d /mnt/usb/AutoRun/LTSystemUpdate ] || [ -d /mnt/usb/AutoRun/LTUpdate ] ; then	# if AutoRun/LTUpdate exists
/usr/loader/loaderPipeClient $FILEFIFO "The system will be rebooted. Please remove the usb stick.3rn"
fi

umount /mnt/usb

#bb="sda"$i;
bb="sd"$letters$i
i=i+1;
done
done
