title NGENx64 update
cd C:\Windows\Microsoft.NET\Framework64\v4.0.30319
NGEN update /force
NGEN eqi
cd C:\Windows\Microsoft.NET\Framework64\v2.0.50727
NGEN update /force
NGEN eqi
EVENTCREATE /T Information  /so CitrixSealing /L APPLICATION /ID 101 /D "Citrix Sealing: NGEN x64 Execution (v4 and v2) completed"
EVENTCREATE /T Information  /L APPLICATION /ID 101 /D "Citrix Sealing: NGEN x64 Execution (v4 and v2) completed"
@ECHO NGEN completed for x64, you can close this window and go back to main batch file.
pause
exit