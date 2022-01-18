title NGENx86 update v2
cd C:\Windows\Microsoft.NET\Framework\v2.0.50727
NGEN update /force
NGEN eqi
EVENTCREATE /T Information  /so CitrixSealing /L APPLICATION /ID 101 /D "Citrix Sealing: NGEN x86 Execution v2 completed"
EVENTCREATE /T Information  /L APPLICATION /ID 101 /D "Citrix Sealing: NGEN x86 Execution v2 completed"
@ECHO NGEN completed for x86 v2, you can close this window and go back to main batch file.
pause
exit