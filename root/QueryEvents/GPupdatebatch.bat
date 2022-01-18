echo off
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe
cls
echo Start gpupdate on servers listed at citrixservers.txt
pause
FOR /F "tokens=* delims=" %%x in (%userprofile%\desktop\citrixservers.txt) DO (

start \\172.30.16.7\SealingBatchFiles\Files\PsExec.exe \\%%x wevtutil cl System
)

echo gpupdate executed
pause