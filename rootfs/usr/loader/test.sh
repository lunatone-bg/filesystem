#!/bin/sh
export VARIABLE=0
mkdir /mnt/usb
i=1;
bb="sda"
for DEV in /dev/sda*
do

mount /dev/$bb /mnt/usb
export DISPLAY=:0.0

if [ -d /mnt/usb/LTSystemUpdate ]; then	# if LTUpdate exists

	nfs_present=$(fw_printenv bootargs)
	nfs_present=${nfs_present#*root=}
	nfs_present=${nfs_present%/dev/nfs*}


if [ -f /mnt/usb/LTSystemUpdate/uImage ]; then	# if uImage
		killall loader	
		/usr/loader/loader "USB Loader App" "Updating kernel image. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
 		flash_eraseall /dev/mtd3
		nandwrite -p /dev/mtd3 /mnt/usb/LTSystemUpdate/uImage
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		sed -i "2ckernel updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		
		fi

if [ -f /mnt/usb/LTSystemUpdate/u-boot.bin ]; then	# if uImage
		killall loader	
		/usr/loader/loader "USB Loader App" "Updating uboot image. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
 		flash_eraseall /dev/mtd1
		nandwrite -p /dev/mtd1 /mnt/usb/LTSystemUpdate/u-boot.bin
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		sed -i "5cuboot updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		
		fi

if [ -f /mnt/usb/LTSystemUpdate/env_variables ]; then	# if uImage
		killall loader	
		/usr/loader/loader "USB Loader App" "Updating env. variables. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		FILE=env_variables
		while read myline
		do
  		echo $myline
		done < "/mnt/usb/LTSystemUpdate/env_variables"
 		#sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		#sed -i "6cuboot env. updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		exit
		fi


if [ -f /mnt/usb/LTSystemUpdate/rootfs_jffs2.tar.bz2 ]; then	#jffs2 image
	killall loader	
	if [ $nfs_present="" ]; then 
		/usr/loader/loader "USB Loader App" "Updating rootfs - jffs2 (from NFS, erasing all flash). Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		flash_eraseall -j /dev/mtd4
		else 	
		/usr/loader/loader "USB Loader App" "Updating rootfs - jffs2. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		fi;
		
	mkdir /mnt/nand
	mount -t jffs2 /dev/mtdblock4 /mnt/nand
	tar jxvf /mnt/usb/LTSystemUpdate/rootfs_jffs2.tar.bz2 -C /mnt/nand/
	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
	sed -i "3cfile system (jffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
	umount /mnt/nand
	fi

if [ -f /mnt/usb/LTSystemUpdate/rootfs_yaffs2.tar.bz2 ]; then	#yaffs2 uImage
	killall loader
	if [ $nfs_present="" ]; then 
		/usr/loader/loader "USB Loader App" "Updating rootfs - yaffs2 (from NFS, erasing all flash) . Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loader "USB Loader App" "Updating rootfs - yaffs2. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		fi;
	mkdir /mnt/nand
	mount -t yaffs2 /dev/mtdblock4 /mnt/nand
	tar jxvf /mnt/usb/LTSystemUpdate/rootfs_yaffs2.tar.bz2 -C /mnt/nand/
	sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
	sed -i "3cfile system (yaffs2) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
	umount /mnt/nand
	fi

if [ -f /mnt/usb/LTSystemUpdate/rootfs_ubi.img ]; then
	killall loader
	if [ $nfs_present="" ]; then 
		/usr/loader/loader "USB Loader App" "Updating rootfs - ubifs (from NFS, erasing all flash) . Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		flash_eraseall /dev/mtd4
		else 	
		/usr/loader/loader "USB Loader App" "Updating rootfs - ubifs. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
		fi;
		nandwrite /dev/mtd4 /mnt/usb/LTSystemUpdate/rootfs_ubi.img 
		sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
		sed -i "3cfile system (ubufs) updated at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
		fi

killall loader
/usr/loader/loader "USB Loader App" "The system will be rebooted. Please remove the usb stick. " "/usr/loader/usb1.jpg" "Ready !" &
fi

if [ -d /mnt/usb/LTUpdate ]; then	# if LTUpdate exists
killall loader
/usr/loader/loader "USB Loader App" "Coping files. Please wait..." "/usr/loader/usb1.jpg" "pulse" &  #run as background
cp -r  /mnt/usb/LTUpdate/[!uImage!rootfs_yaffs2.tar.bz2!rootfs_jffs2.tar.bz2!rootfs_ubi.img]* /
sed -i 's/"reboot_required": false/"reboot_required": true/g' /usr/loader/.config/'last update'		
sed -i "4cfiles copied at: `date +"%H:%M %d.%m.%Y"`" /usr/loader/.config/'last update'
killall loader
/usr/loader/loader "USB Loader App" "The system will be rebooted. Please remove the usb stick. " "/usr/loader/usb1.jpg" "Ready !" &
fi

umount /mnt/usb

bb="sda"$i;
i=i+1;
done
