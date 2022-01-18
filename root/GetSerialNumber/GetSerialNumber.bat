echo off
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe
cls

FOR /F "tokens=* delims=" %%x in (%userprofile%\desktop\vdaservers.txt) DO (
echo %%x >>getserialnumber.txt
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe \\%%x WMIC BIOS GET SERIALNUMBER >>getserialnumber.txt
)

echo gpupdate executed
pause