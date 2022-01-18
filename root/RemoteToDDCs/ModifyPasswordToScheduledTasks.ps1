#This script updates credentials to scheduled tasks on multiple CDCs.
#Written by Marco Torres 08-11-2020 version 1.0


#For interactive session use:
#Enter-PSSession -ComputerName "CITRIX CONTROLLER NAME/IP"

#$ErrorActionPreference = "SilentlyContinue"

Start-Transcript

#$TaskCredential = Get-Credential


Get-Content C:\batch\vdastoupdate.txt | ForEach-Object{
$CDCNAME = $_

$CDCNAME
#Enter Poweshell Session on Remote server, add Citrix SnapIn

$s = New-PSSession -ComputerName $CDCNAME



Invoke-Command -Session $s {$list = (Get-ScheduledTask | Where-Object { $_.Principal.UserId -eq "eclptsc\_citrixreporting" }).TaskName}
Invoke-Command -Session $s {$list | ForEach-Object {Set-ScheduledTask -User "eclptsc\_citrixreporting" -Password ok -taskname $PSItem}}



}