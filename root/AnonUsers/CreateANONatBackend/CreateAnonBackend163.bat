echo off

FOR /F "tokens=* delims=" %%x in (backendservers.txt) DO (
xcopy \\172.30.16.7\Software\Scripts\CREATE_ANON_000_500\ps_cusers.bat \\%%x\c$ >>createbackend.txt
start \\172.30.16.7\SealingBatchFiles\Files\PsExec.exe \\%%x -accepteula c:\ps_cusers.bat
)

pause