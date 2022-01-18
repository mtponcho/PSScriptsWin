echo off
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe
cls
echo Start execution
pause
FOR /F "tokens=* delims=" %%x in (%userprofile%\desktop\eventsearchresult.txt) DO (


taskkill /s %%x /f /fi "IMAGENAME eq ssomanhost*"
sc \\%%x start ssomanhost
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe \\%%x wevtutil cl System
)

echo gpupdate executed
pause