title NGENx86 update v4
cd C:\Windows\Microsoft.NET\Framework\v4.0.30319
NGEN update /force
NGEN eqi
EVENTCREATE /T Information  /so CitrixSealing /L APPLICATION /ID 201 /D "Citrix Sealing: NGEN x86 Execution v4 completed"
EVENTCREATE /T Information  /L APPLICATION /ID 201 /D "Citrix Sealing: NGEN x86 Execution v4 completed"
@ECHO NGEN completed for x86 v4, you can close this window and go back to main batch file.
pause
exit