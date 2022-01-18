if(!(Get-HotFix -ID "KB4019264")){
Set-Service wuauserv -startuptype "Automatic"
Start-Service wuauserv

echo "Install patch KB4019264 from \\TSCMGRCLT\microsoft\Hotfixes\MS17-010 , reboot then restart sealing"
pause
}
