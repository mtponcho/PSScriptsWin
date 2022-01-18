
#Powershell Script for Crowdstrike

$Destination = "c:\windows\Temp"
Copy-Item "\\atsscc1aapps301.eclptsc.eclipsnet.com\e$\SMSPKGE$\Security Packaging_Crowdstrike\ALSC_5.23.10504_Sensor.exe" $Destination
$Command = "C:\windows\TEMP\ALSC_5.23.10504_Sensor.exe" 
$Parms = "/install /quiet /norestart CID=C5B11BF8BA924D7EAFC0E43D46F1EC6B-42"

$prms = $Parms.Split(" ")
& "$Command" $prms


#Powershell for McAfee Agent :

$Destination = "c:\windows\Temp"
Copy-Item "\\atsscc1aapps301.eclptsc.eclipsnet.com\e$\SMSPKGE$\Security Packaging_McAfee\Agent - 1st Install\FramePkg551.exe" $Destination
$Command = "C:\windows\Temp\FramePkg551.exe"

& "$Command"

#Powershell for Nessus Agent:

$Destination = "C:\windows\TEMP"
Copy-Item "\\atsscc1aapps301.eclptsc.eclipsnet.com\E$\SMSPKGE$\Security Packaging_Nessus742\NessusAgent-7.4.2-x64.msi" $Destination
Invoke-Command -ScriptBlock { msiexec /i c:\windows\temp\NessusAgent-7.4.2-x64.msi NESSUS_SERVER="cloud.tenable.com:443" NESSUS_KEY="ea3abd91788e1b3341b3202d40cf9c0c5910498eab2a14e8c4c1a2101d8a060e" /norestart /q }

#Powershell for SIEM Collector:

$Destination = "c:\windows\Temp"
Copy-Item "\\atsscc1aapps301.eclptsc.eclipsnet.com\e$\SMSPKGE$\Security Packaging_Siem\SIEMCollectorInstaller.msi" $Destination
$Command = "C:\windows\Temp\SIEMCollectorInstaller.msi"
& "$Command"

#SCCM Installation

\\172.30.16.7\SealingBatchFiles\Files\SCCM\SCCM_Install.bat

#Local Admin pass change

\\172.30.16.7\software\citrix\changelocaladminpw.bat