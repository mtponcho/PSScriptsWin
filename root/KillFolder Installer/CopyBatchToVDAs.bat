echo off
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe
cls
echo Start gpupdate on servers listed at citrixservers.txt
pause
rem FOR /F "tokens=* delims=" %%x in (%userprofile%\desktop\citrixservers.txt) DO (
rem xcopy %userprofile%\desktop\delfolder.bat \\%%x\c$ /y
rem xcopy %userprofile%\desktop\delprof.exe \\%%x\c$ /y
rem )

FOR /F "tokens=* delims=" %%x in (%userprofile%\desktop\citrixservers.txt) DO (
start \\172.30.16.7\SealingBatchFiles\Files\PsExec.exe \\%%x c:\delfolder.bat
)

echo COMPLETED
pause