Change User /Install
Reg Import "\\172.30.16.7\software\WindowsUpdate\NewWSUS\WSUS_New.Reg"

Restart-Service -DisplayName 'Background Intelligent Transfer Service' -Force
Restart-Service -DisplayName 'Windows Update' -Force


#Install-Module PSWindowsUpdate
#Get-WindowsUpdate

\\172.30.16.7\software\WindowsUpdate\NewWSUS\WUInstall.exe /install /showprogress

#Install-WindowsUpdate
