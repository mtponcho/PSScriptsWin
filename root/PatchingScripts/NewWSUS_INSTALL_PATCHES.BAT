@Echo Off
Mode Con: Cols=80 Lines=20
Color 1f
Change User /Install
Reg Import "\\172.30.16.7\software\WindowsUpdate\NewWSUS\WSUS_New.Reg"
REM Gpupdate /Force  ---- Temporarily Disabled till GPO is updated

Sc Query Wuauserv
Sc Config Wuauserv Start= Auto

Net Stop Bits
Net Start Bits

Net Stop Wuauserv
Net Start Wuauserv 

Sc Query Wuauserv
TIMEOUT /t 5 /NOBREAK
\\172.30.16.7\software\WindowsUpdate\NewWSUS\WUInstall.exe /install /showprogress

Pause
Cls
Color 4f
Echo Please Review The Event Logs And Restart The Server
Pause
