#!/bin/bash
#
# Script that constantly create files, 1 GB each) from /dev/urandom using 8K block size
# -- you need to kill the script to stop it from continue creating files
# 
# Author: Magnus Andersson - Sr Staff Solution Architect at Nutanix
# Date: 2018-08-24
#
# This section contains user defined variables
# Define logfile
logfile=/data/createdata8K.log
#
# Define the fixed part of the name of files to be created from /dev/urandom
fixedname=urandom8-
#
#Define number of files to be created
numfiles=250
#
# Define file size, actually number of 8K writes to the file to reach the desired 1 GB file size.
times=125000
# End of user defined variables section
#
# Creating files via /dev/urandom
while true ; do
	for x in $(seq 1 $numfiles);do
    	echo > /data/$fixedname$x.dat
        /bin/dd if=/dev/urandom of=/data/$fixedname$x.dat bs=8K count=$times &> /dev/null
	done
done
