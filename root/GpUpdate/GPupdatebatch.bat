echo off
\\172.30.16.7\SealingBatchFiles\Files\PsExec.exe
cls
echo Start gpupdate on servers listed at citrixservers.txt
pause
FOR /F "tokens=* delims=" %%x in (%userprofile%\desktop\vdaservers.txt) DO (
echo %%x >>gpupdateresult.txt
start \\172.30.16.7\SealingBatchFiles\Files\PsExec.exe \\%%x gpupdate /force
)

echo gpupdate executed
pause