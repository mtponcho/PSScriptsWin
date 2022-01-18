<#
Name : Reboot schedule script
for : Xenapp 7.x
Purpose : as the name indicates, it's a reboot schedule script, Citrix couldn't even build this piece properly in the GUI so the need for this.
Written by : Manu Panicker (manu.panicker@atos.net)

Usage -
    Make a sceduled task & point it to a bat file which contains below.
    Mote - create the scheduled task in your DDC1 c:\rebootschedule\
    ---------------------------------------------------------------------------------------------------
    powershell "c:\rebootschedule\rebootschedule.ps1 -rebootset1 "c:\rebootsschdule\firstsetsevers.txt"
    Save as Bat file-----------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
    Make another Bat file and point it to another set of servers by making a second server txt file
    1 Bat file & servers.txt will work for only 1 set of reboots
#>

param(
$rebootset1
)
$xaserver=gc $rebootset1
#$ser="st1adcv1\st3dctpv03","st1adcv1\st3dctpv04"
Set-BrokerMachineMaintenanceMode -InputObject $xaserver -MaintenanceMode $true
$desktop = Get-BrokerSession -InMaintenanceMode $true
Send-BrokerSessionMessage -InputObject $desktop.Uid -MessageStyle "Critical" -Title `
 "Scheduled reboots tonight" -Text "Please logoff from this server in 60 mins, `
 after logoff you can open the application again to get redirected to a different server"

sleep -Seconds 1800
Send-BrokerSessionMessage -InputObject $desktop.Uid -MessageStyle "Critical" -Title `
 "Scheduled reboots tonight" -Text "Please logoff from this server in 30 mins, `
 after logoff you can open the application again to get redirected to a different server"

sleep -Seconds 1200
Send-BrokerSessionMessage -InputObject $desktop.Uid -MessageStyle "Critical" -Title `
 "Scheduled reboots tonight" -Text "Please logoff from this server in 10 mins, after `
 logoff you can open the application again to get redirected to a different server"

sleep -Seconds 600
Set-BrokerMachineMaintenanceMode -InputObject $xaserver -MaintenanceMode $false
Restart-Computer -AsJob $xaserver