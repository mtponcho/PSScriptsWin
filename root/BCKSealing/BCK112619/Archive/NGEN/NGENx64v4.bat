title NGENx64 update v4
cd C:\Windows\Microsoft.NET\Framework64\v4.0.30319
NGEN update /force
NGEN eqi
EVENTCREATE /T Information  /so CitrixSealing /L APPLICATION /ID 401 /D "Citrix Sealing: NGEN x64 Execution (v4 and v2) completed"
EVENTCREATE /T Information  /L APPLICATION /ID 401 /D "Citrix Sealing: NGEN x64 Execution v4 completed"
@ECHO NGEN completed for x64 v4, you can close this window and go back to main batch file.
pause
exit