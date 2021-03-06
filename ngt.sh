#/bin/bash
# Script to enable Nutanix Guest Tools for cloned VMs.
# Author: Magnus Andersson - Sr Staff Solutions Architect @Nutanix
#
# ----Script Edit section starts here----
# Specify the VM prefix for the VMs you will enable NGT
vmprefix="ngt"
#
# ----Script Edit section ends here----
#
ngtvms=`ncli vm list |  grep -B 1 $vmprefix | grep -v Name | awk -F ":" '{print $2}' | awk -F "[[:space:]]*" '{print $0}'`
for i in $ngtvms ; do
echo Enable NGT on VM with Uuid $i
ncli ngt mount vm-id=$i
done