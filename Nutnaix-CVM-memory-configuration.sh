#!/bin/bash
# Script to change CVM RAM
# Author: Magnus Andersson Staff Solutions Architect at Nutanix
# Date 2018-12-18
# Version 1.0
#
# Define amount of RAM needed for the CVM
RAM=96
#
# Do not change anything below this line
# --------------------------------------
echo Start CVM reconfiguration process
echo ""
# Find CVM
cvm=`/usr/bin/virsh list --all | grep CVM | awk '{print $2}'`
# Shutdown CVM
if /usr/bin/virsh list --all | grep CVM | awk '{print $3}' | grep -i run; then
echo Shutting down CVM: $cvm
/usr/bin/virsh shutdown $cvm
else
echo CVM not running, proceeding without trying to shut down the CVM
fi
sleep 60
# Get current configuration
if /usr/bin/virsh list --all | grep CVM | awk '{print $3}' | grep -i run; then
echo "The CVM, $cvm, could not be shut down, manual investigation required"
echo "Exiting the script........"
exit 1
else
echo "Current $cvm RAM (maxmem & mem) configuration in KiB is:"
/usr/bin/virsh dumpxml $cvm | egrep -i "KiB" | awk -F"<" '{print $2}' | awk -F">" '{print $2}'
fi
#echo ""
# Set new configuration
echo Setting new RAM configuration for $cvm
sleep 4
/usr/bin/virsh setmaxmem $cvm --config --size "${RAM}GiB"
/usr/bin/virsh setmem $cvm --config --size "${RAM}GiB"
# Get new configuration
echo "New $cvm RAM (maxmem & mem) configuration in KiB is:"
sleep 10
/usr/bin/virsh dumpxml $cvm | egrep -i "KiB" | awk -F"<" '{print $2}' | awk -F">" '{print $2}'
#echo ""
# Start CVM
echo Starting CVM: $cvm
/usr/bin/virsh start $cvm
# Verify CVM is running
echo Verifying if the CVM is running
sleep 8
if /usr/bin/virsh list --all | grep CVM | awk '{print $3}' | grep -i run;then
echo ""
echo "CVM $cvm is running"
echo "Configuration process finished"
else
echo "The CVM $cvm is not running! Manual investigation is required...."
fi