title NGENx86 update
cd C:\Windows\Microsoft.NET\Framework\v4.0.30319
NGEN update /force
NGEN eqi
cd C:\Windows\Microsoft.NET\Framework\v2.0.50727
NGEN update /force
NGEN eqi
EVENTCREATE /T Information  /so CitrixSealing /L APPLICATION /ID 201 /D "Citrix Sealing: NGEN x86 Execution (v4 and v2) completed"
EVENTCREATE /T Information  /L APPLICATION /ID 201 /D "Citrix Sealing: NGEN x86 Execution (v4 and v2) completed"
@ECHO NGEN completed for x86, you can close this window and go back to main batch file.
pause
exit