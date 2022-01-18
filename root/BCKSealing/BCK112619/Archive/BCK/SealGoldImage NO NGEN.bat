@echo off
cls
title MAIN BATCH FILE FOR CITRIX PVS SERVERS

rem ***Check requites for sealing


wscript "\\172.30.16.7\SealingBatchFiles\Files\SealingPrerequisites.vbs"

wscript "\\172.30.16.7\SealingBatchFiles\Files\CheckSealingInProgress.vbs"
if %ERRORLEVEL% == 0 goto NoOtherSealing
echo WARNING: Another sealing process started previously that didn't get finished or that is ongoing, check with this person for completion
SET /P QCONTSEAL=Continue (Y/N)? 
if /i {%QCONTSEAL%}=={y} (goto :NoOtherSealing) 
if /i {%QCONTSEAL%}=={Y} (goto :NoOtherSealing)
exit
:NoOtherSealing


wscript "\\172.30.16.7\SealingBatchFiles\Files\ChkVdiskMode.vbs"
if %ERRORLEVEL% NEQ 1 goto vDiskInEditMode
echo ERROR: This is not recognized as a Citrix vdisk in edit mode, sealing aborted.
echo ERROR: This is not recognized as a Citrix vdisk in edit mode, sealing aborted.
echo ERROR: This is not recognized as a Citrix vdisk in edit mode, sealing aborted.
echo ERROR: This is not recognized as a Citrix vdisk in edit mode, sealing aborted.
echo.
:ABORTSEAL
echo ERROR: Sealing cancelled
pause
exit
:vDiskInEditMode
echo.
echo MAIN SEALING BATCH FILE FOR CITRIX PVS SERVERS
echo.
echo.
echo You can use this file for sealing Citrix vdisks for SCM, LAB, EEHR/PM
echo.

rem ***Query Reboot Details

rem start /MIN \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\queryreboots.bat

echo ATTENTION: If requisites passed (enough disk space, vdisk in edit mode, and no McAfee AV installed) then continue...
echo.
SET /P QSTARTSEAL=Start sealing process (Y/N)? 
if /i {%QSTARTSEAL%}=={y} (goto :StartSeal) 
if /i {%QSTARTSEAL%}=={Y} (goto :StartSeal)
exit
:StartSeal

rem ***STEP 1: Clear all event logs

wevtutil cl System
wevtutil cl Application
wevtutil cl Security


EVENTCREATE /T Information  /L APPLICATION /ID 500 /D "CitrixSealing: Sealing initiated"

wscript "\\172.30.16.7\SealingBatchFiles\Files\TrackSealingStarted.vbs"



rem ***STEP 2: Clear user profiles











EVENTCREATE /T Information /so CitrixSealing /L Application /ID 009 /D "CitrixSealing: NO NGEN SCRIPT" 







rem ***STEP 6: ipconfig /flushdns
ipconfig /flushdns

if %ERRORLEVEL% == 0 goto SUCCESS9
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 008 /D "CitrixSealing: ipconfig /flushdns: FAILED"
echo flushdns couldn't complete
:SUCCESS9
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 010 /D "CitrixSealing: ipconfig /flushdns occurred" 



rem ***STEP 7: Set Windows Automatic Updates service to disable


sc config wuauserv start= disabled

if %ERRORLEVEL% == 0 goto SUCCESS4
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for windows Update Service to Disabled: FAILED"
echo windows update service set to disable failes
:SUCCESS4
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 005 /D "CitrixSealing: Result for windows Update Service to Disabled: SUCCEDED"  



rem wscript "\\172.30.16.7\SealingBatchFiles\Files\CheckIMA.vbs"
rem if %ERRORLEVEL% EQU 0 goto XA7X


rem ***STEP 8: Prepare image to seal XA65
cd C:\Program Files (x86)\Citrix\Independent Management Architecture
if %ERRORLEVEL% NEQ 0 goto XA7X

net stop IMAService

dsmaint recreatelhc
if %ERRORLEVEL% == 0 goto SUCCESS10
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 009 /D "CitrixSealing: LHC recreation: FAILED"
pause
:SUCCESS10
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 011 /D "CitrixSealing: LHC recreation completed without error" 

net start IMAService
if %ERRORLEVEL% == 0 goto SUCCESS11
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 010 /D "CitrixSealing: IMA Service restart: FAILED"
pause
:SUCCESS11
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 012 /D "CitrixSealing: IMA Service restart" 

cd C:\Program Files (x86)\Citrix\XenApp\ServerConfig\
XenAppConfigConsole.exe /ExecutionMode:ImagePrep /RemoveCurrentServer:False /PrepMsmq:True

if %ERRORLEVEL% == 0 goto SUCCESSa

rem ***STEP X: Break if error found during execution.
:BREAKEND
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 011 /D "CitrixSealing: XenAppConfigConsole.exe /ExecutionMode:ImagePrep /RemoveCurrentServer:False /PrepMsmq:True: FAILED"
@ECHO AN ERROR OCCURRED, restart imageprep from XenApp console.
@ECHO AN ERROR OCCURRED, restart imageprep from XenApp console.
@ECHO AN ERROR OCCURRED, restart imageprep from XenApp console.
pause

:SUCCESSa
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 013 /D "CitrixSealing: XenAppConfigConsole.exe /ExecutionMode:ImagePrep /RemoveCurrentServer:False /PrepMsmq:True: SUCCEDED" 

:XA7X

wscript "\\172.30.16.7\SealingBatchFiles\Files\TrackSealingFinished.vbs"

EVENTCREATE /T Information  /L APPLICATION /ID 501 /D "CitrixSealing: Sealing completed"


rem ***STEP 9: Turn off the server


powershell -executionpolicy bypass "\\172.30.16.7\SealingBatchFiles\Files\SealingCompleted.ps1"
title MAIN BATCH FILE FOR CITRIX PVS SERVERS
cls
@echo Sealing completed.
shutdown -s -f -t 10
hostname
pause

exit
