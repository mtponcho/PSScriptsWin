@Echo Off
Mode Con: Cols=80 Lines=20
Color 1f
Change User /Install
Reg Import "\\172.30.16.7\Software\Windowsupdate\Wsus.Reg"
REM Gpupdate /Force  ---- Temporarily Disabled till GPO is updated

Sc Query Wuauserv
Sc Config Wuauserv Start= Auto

Net Stop Bits
Net Start Bits

Net Stop Wuauserv
Net Start Wuauserv 

Sc Query Wuauserv
TIMEOUT /t 5 /NOBREAK
\\172.30.16.7\Software\WindowsUpdate\WUInstall.exe /install /showprogress

Pause
Cls
Color 4f

powershell -executionpolicy bypass "\\172.30.16.7\SealingBatchFiles\Files\SealingCompleted.ps1"

Echo Please Review The Event Logs And Restart The Server
Pause
