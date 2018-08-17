#!/bin/bash
# Script to change powered off VM Virtual Network.
# Authors: Magnus Andersson & Arthur Perkins @Nutanix
#
# Version 2.0 -  List Virtual Networksm Virtual Network name (including spaces) management, functionality to manage multiple NICs per VM
# Version 1.0 - Initial release
#
IFS=$'\n'
clear
echo "Enter the name of the VM(s) you want to change network for, regex is accepted."
echo "Important: Single entry only and the VM(s) name is case sensitive."
echo
read -ep "Enter VM Name Search Term:  " "vmname"
echo "-----------------------------------------------"
echo "Do you want to list available Virtual Networks?"
read -ep "Available options are Y or N:" "list"
if [ $list == "N" ] || [ $list == "n" ]
	then
		echo "Important: The Virtual Network name is case sensitive!"
		read -ep "Enter the Virtual Network name:" "vmnet"
	else
                echo "Available Virtual Networks:"
		/usr/local/nutanix/bin/acli net.list | awk  -F'[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]' '{print $1}' | sed -n '1!p'
		echo
		echo "Important: The Virtual Network name is case sensitive!"
		read -ep "Enter the Virtual Network name:" "vmnet"
	fi
echo
echo "The VM(s) will be connected to the following Virtual Network when the script is completed:" $vmnet
echo
echo "These VM(s) with their NIC(s) associated MAC address will be changed:"
vmn=`/usr/local/nutanix/bin/acli vm.list | awk '{print $1}' | grep -e $vmname`
for i in ${vmn[@]}; do
	echo -------------------------------------------------
    	echo $i
    	mac1=`/usr/local/nutanix/bin/acli vm.get $i | grep "mac_addr" | awk '{print $2}'`
    	echo $mac1
done
read -p "Press Enter to Continue or Ctrl-C to quit"
echo
for i in $vmn; do
echo
echo -------------------------------------------------
echo "Changing Virtual Network for VM $i"
vmstate=`/usr/local/nutanix/bin/acli vm.get $i | grep -i state | awk -F "\"" '{print $2}'`
	if [ $vmstate == "kOn" ] ; then
		echo "Cannot change Virtual Network for VM $i since it's powered on"
			else
    		mac2=`/usr/local/nutanix/bin/acli vm.get $i | grep "mac_addr" | awk '{print $2}'`
		for x in $mac2; do
			/usr/local/nutanix/bin/acli vm.nic_update $i $x network=$vmnet
		done
	fi
done