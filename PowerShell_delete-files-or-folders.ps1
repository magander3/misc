# PowerShell Script to delete files and or folders in specific Windows Server folders.
# Created by: Magnus Andersson 
# Version 1.0
#
# ---------------------
# User input section starts here
#
# Define scfript log file
$logfile="D:\scripts\deletefiles_folders.log"
#
# Define direcroty where the vCenter Server and NSX Manager backups are located
$dir1="D:\applixcation-1\logsfiles"
$dir2="D:\applixcation-2\logsfiles"
#
# Define how old backups you want to remove by typing a number which corresponds to days
$deletefilesolderthan="7"
#
# User input section end here - Do not change anything below this line
# --------------------------------------------------------------------
#
# Delete logfile 
Remove-Item $logfile
# Start delete files and or folders script
$d1=date
echo "----------------------------------------" >> $logfile
echo "Start deleting old backups at:" $d1 >> $logfile
Get-ChildItem -Path "$dir1" -Recurse | Where CreationTime -lt  (Get-Date).AddDays(-$deletebackupsolderthan) | Remove-Item -Force -Recurse *>&1 >> $logfile
Get-ChildItem -Path "$dir2" -Recurse | Where CreationTime -lt  (Get-Date).AddDays(-$deletebackupsolderthan) | Remove-Item -Force -Recurse *>&1 >> $logfile
$d2=date
echo "Finished deleting old files and or folders at:" $d2 >> $logfile
