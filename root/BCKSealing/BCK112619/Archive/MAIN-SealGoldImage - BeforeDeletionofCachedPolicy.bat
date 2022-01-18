@echo off
cls
title MAIN BATCH FILE FOR CITRIX PVS SERVERS

rem ***Check requites for sealing



wscript "\\172.30.16.7\SealingBatchFiles\Files\CheckSealingPrerequisites.vbs"

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

rem start /MIN \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\RebootDetailPerClient\queryreboots.bat

echo ATTENTION: If requisites passed (enough disk space, vdisk in edit mode, and no McAfee AV installed) then continue...
echo.
SET /P QSTARTSEAL=Start sealing process (Y/N)? 
if /i {%QSTARTSEAL%}=={y} (goto :StartSeal) 
if /i {%QSTARTSEAL%}=={Y} (goto :StartSeal)
exit
:StartSeal

rem ***STEP 1: Clear all event logs and delete GracePeriod registry key


start /MIN \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\DeleteGracePeriodKey.bat

EVENTCREATE /T Information  /L APPLICATION /ID 500 /D "CitrixSealing: Sealing initiated"

wscript "\\172.30.16.7\SealingBatchFiles\Files\TrackSealingStarted.vbs"

wevtutil cl System
wevtutil cl Application
wevtutil cl Security





rem ***STEP 2: Clear user profiles


SET /P QDELPROFILE=Do you want to DELETE user profiles stored on this server (Y/N)? 
if /i {%QDELPROFILE%}=={y} (goto :YESDELPROF) 
if /i {%QDELPROFILE%}=={Y} (goto :YESDELPROF) 

EVENTCREATE /T Information /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: User Profiles deletion skipped"
goto NODELPROF

:YESDELPROF


\\172.30.16.7\software\Citrix\SealingBatchFiles\Files\delprof /p

EVENTCREATE /T Information /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: User Profiles reviewed"

:NODELPROF



rem ***Look for SCM folder



cd C:\Program Files (x86)\Allscripts Sunrise\Helios
if %ERRORLEVEL% == 0 goto SCMSealingStart

SET /P QNOSCMIMAGE=No SCM folder found, is this EEHR/PM/Lab/SRM Gold server (Y/N)? 
if /i {%QNOSCMIMAGE%}=={y} (goto :EEHRstart) 
if /i {%QNOSCMIMAGE%}=={Y} (goto :EEHRstart) 

goto :ABORTSEAL


:SCMSealingStart
echo Starting sealing process for SCM servers


rem ***STEP 3: Set .NET services to Atumatic(delayed) start

:CALLBATCH
sc config clr_optimization_v4.0.30319_64 start= delayed-auto

if %ERRORLEVEL% == 0 goto SUCCESS1
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: Result for Net optimization x64 service set to delatey-auto: FAILED"
echo Service not found: clr_optimization_v4.0.30319_64
:SUCCESS1
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for Net optimization x64 service set to delatey-auto: SUCCEDED"  


sc config clr_optimization_v4.0.30319_32 start= delayed-auto

if %ERRORLEVEL% == 0 goto SUCCESS2
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: Result for Net optimization x86 service set to delatey-auto: FAILED"
echo Service not found: clr_optimization_v4.0.30319
:SUCCESS2
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 004 /D "CitrixSealing: Result for Net optimization x86 service set to delatey-auto: SUCCEDED"  





rem ***STEP 4: Run NGEN for both x86 and x84 and log execution results

Echo Stating NGEN update x86 and x64, don't close this window.

start /min \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\NGENx86.bat

if %ERRORLEVEL% == 0 goto SUCCESS5
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 004 /D "CitrixSealing: NGEN x86 Process initialization: FAILED"
echo NGENx86.bat could't be started, please start it manually.
:SUCCESS5
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 006 /D "CitrixSealing: NGEN x86 Process initialization: SUCCEDED"  


start /min \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\NGENx64.bat

if %ERRORLEVEL% == 0 goto SUCCESS6
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 005 /D "CitrixSealing: NGEN x64 Process initialization: FAILED"
echo NGENx64.bat could't be started, please start it manually.
:SUCCESS6
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 007 /D "CitrixSealing: NGEN x64 Process initialization: SUCCEDED"  



:NGENINPROGRESS
cls
@echo NGEN update in progress, you will be notified via email once this process is complete.
timeout 5
wscript "\\172.30.16.7\SealingBatchFiles\Files\CheckNGENCompletion.vbs"
if %ERRORLEVEL% NEQ 0 goto :NGENINPROGRESS


PowerShell.exe -nologo -command "&{\\172.30.16.7\SealingBatchFiles\Files\Remove_Sunrise_DLLs_from_NGEN.ps1}"

rem ***STEP 5: SET .NET Services to disable



sc config clr_optimization_v4.0.30319_64 start= disabled

if %ERRORLEVEL% == 0 goto SUCCESS7
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 006 /D "CitrixSealing: Result for Net optimization x86 service set to disabled: FAILED"
echo Service not found: clr_optimization_v4.0.30319_64
:SUCCESS7
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 008 /D "CitrixSealing: Result for Net optimization x86 service set to disabled: SUCCEDED" 

sc config clr_optimization_v4.0.30319_32 start= disabled

if %ERRORLEVEL% == 0 goto SUCCESS8
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 007 /D "CitrixSealing: Result for Net optimization x86 service set to disabled: FAILED"
echo Service not found: clr_optimization_v4.0.30319_32
:SUCCESS8
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 009 /D "CitrixSealing: Result for Net optimization x86 service set to disabled: SUCCEDED" 




:EEHRstart


rem ***STEP 6: ipconfig /flushdns
ipconfig /flushdns

if %ERRORLEVEL% == 0 goto SUCCESS9
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 008 /D "CitrixSealing: ipconfig /flushdns: FAILED"
echo flushdns couldn't complete
:SUCCESS9
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 010 /D "CitrixSealing: ipconfig /flushdns occurred" 



rem ***STEP 7: Set Windows Automatic Updates and Citrix Profile Management services to disable


sc config wuauserv start= disabled

if %ERRORLEVEL% == 0 goto SUCCESS4
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for windows Update Service to Disabled: FAILED"
echo windows update service set to disable failes
:SUCCESS4
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 005 /D "CitrixSealing: Result for windows Update Service to Disabled: SUCCEDED"  



sc config ctxProfile start= disabled

if %ERRORLEVEL% == 0 goto SUCCESS5
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for Citrix Profile Management to Disabled: FAILED"
echo windows update service set to disable failes
:SUCCESS5
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 005 /D "CitrixSealing: Result for Citrix Profile Management: SUCCEDED"  


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

rem Reset counters
lodctr /r

rem Track sealing process completion

wscript "\\172.30.16.7\SealingBatchFiles\Files\TrackSealingFinished.vbs"

EVENTCREATE /T Information  /L APPLICATION /ID 501 /D "CitrixSealing: Sealing completed"


rem ***STEP 9: Turn off the server


powershell -executionpolicy bypass "\\172.30.16.7\SealingBatchFiles\Files\SealingCompleted.ps1"
title MAIN BATCH FILE FOR CITRIX PVS SERVERS
cls
@echo Sealing completed, this server will turn off in 30 secs or press any key to shutdown immediatly.
shutdown -s -t 30
hostname
pause
shutdown -s -t 00
exit
