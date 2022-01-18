@echo off
cls
title MAIN BATCH FILE FOR CITRIX PVS SERVERS



rem ***
rem ***
rem ***Check prequites for sealing, no modifications at this point
rem ***
rem ***

wscript "\\172.30.16.7\SealingBatchFiles\Files\CheckSealingPrerequisites.vbs"


rem *** Check if somebody else is trying to seal this vdisk


wscript "\\172.30.16.7\SealingBatchFiles\Files\CheckSealingInProgress.vbs"
if %ERRORLEVEL% == 0 goto NoOtherSealing
echo WARNING: Another sealing process started previously that didn't get finished or that is ongoing, check with this person for completion
SET /P QCONTSEAL=Continue (Y/N)? 
if /i {%QCONTSEAL%}=={y} (goto :NoOtherSealing) 
if /i {%QCONTSEAL%}=={Y} (goto :NoOtherSealing)
exit


:NoOtherSealing


rem *** Check vdisk is in edit mode

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




rem ***
rem ***
rem *** Prerequisites passed, start of sealing steps.
rem ***
rem ***


echo.
echo MAIN SEALING BATCH FILE FOR CITRIX PVS SERVERS
echo.
echo.
echo You can use this file for sealing Citrix vdisks for SCM, LAB, EEHR/PM
echo.

rem ***Query Reboot Details from txt file

rem start /MIN \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\RebootDetailPerClient\queryreboots.bat

echo ATTENTION: If requisites passed then continue...
echo.
SET /P QSTARTSEAL=Start sealing process (Y/N)? 
if /i {%QSTARTSEAL%}=={y} (goto :StartSeal) 
if /i {%QSTARTSEAL%}=={Y} (goto :StartSeal)
exit
:StartSeal

rem ***STEP 1: Save, Clear all event logs and delete GracePeriod registry key

powershell -executionpolicy bypass "\\172.30.16.7\SealingBatchFiles\Files\Eventlogs_copy.ps1"

wevtutil cl System
wevtutil cl Application
wevtutil cl Security

start /MIN \\172.30.16.7\software\Citrix\SealingBatchFiles\Files\DeleteGracePeriodKey.bat

EVENTCREATE /T Information  /L APPLICATION /ID 500 /D "CitrixSealing: Sealing initiated"

wscript "\\172.30.16.7\SealingBatchFiles\Files\TrackSealingStarted.vbs"







rem ***STEP 2: Deletion of user profiles.
rem ***if deletion is selected, it can be specified which profiles to delete or delete them all at once
rem ***

SET /P QDELPROFILE=Do you want to DELETE user profiles stored on this server (Y/N)? 
if /i {%QDELPROFILE%}=={y} (goto :YESDELPROF) 
if /i {%QDELPROFILE%}=={Y} (goto :YESDELPROF) 

EVENTCREATE /T Information /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: User Profiles deletion skipped"
goto NODELPROF

:YESDELPROF

\\172.30.16.7\software\Citrix\SealingBatchFiles\Files\delprof /p

EVENTCREATE /T Information /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: User Profiles reviewed"

:NODELPROF



***Look for SCM folder
***this section below will apply only if SCM folder is found on the server
***


cd C:\Program Files (x86)\Allscripts Sunrise\Helios
if %ERRORLEVEL% == 0 goto SCMSealingStart

SET /P QNOSCMIMAGE=No SCM folder found, is this EEHR/PM/Lab/SRM Gold server (Y/N)? 
if /i {%QNOSCMIMAGE%}=={y} (goto :EEHRstart) 
if /i {%QNOSCMIMAGE%}=={Y} (goto :EEHRstart) 

goto :ABORTSEAL


:SCMSealingStart
echo Starting sealing process for SCM servers

rem ***
rem ***Steps exclusive for Citrix/SCM servers


rem ***STEP 3: Set .NET services to Atumatic(delayed) start

:CALLBATCH


rem *** Microsoft .NET Framework NGEN v2.0.50727_X86

sc config clr_optimization_v2.0.50727_32 start= delayed-auto

if %ERRORLEVEL% == 0 goto :SUCCESSNET2X86
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v2.0.50727_X86 service set to delayed-auto: FAILED"
echo Service not found: Microsoft .NET Framework NGEN v2.0.50727_X86
:SUCCESSNET2X86
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for Microsoft .NET Microsoft .NET Framework NGEN v2.0.50727_X86 service set to delayed-auto: SUCCEDED"  



rem *** Microsoft .NET Framework NGEN v2.0.50727_X64

sc config clr_optimization_v2.0.50727_64 start= delayed-auto

if %ERRORLEVEL% == 0 goto :SUCCESSNET2X64
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v2.0.50727_X64 service set to delayed-auto: FAILED"
echo Service not found: Microsoft .NET Framework NGEN v2.0.50727_X64
:SUCCESSNET2X64
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 004 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v2.0.50727_X64 service set to delayed-auto: SUCCEDED"  



rem *** Microsoft .NET Framework NGEN v4.0.30319_X86


sc config clr_optimization_v4.0.30319_32 start= delayed-auto

if %ERRORLEVEL% == 0 goto :SUCCESSNET4X86
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X86 service set to delayed-auto: FAILED"
echo Service not found: Microsoft .NET Framework NGEN v4.0.30319_X86
:SUCCESSNET4X86
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X86 service set to delayed-auto: SUCCEDED"  



rem *** Microsoft .NET Framework NGEN v4.0.30319_X64

sc config clr_optimization_v4.0.30319_64 start= delayed-auto

if %ERRORLEVEL% == 0 goto :SUCCESSNET4X64
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X64 service set to delayed-auto: FAILED"
echo Service not found: clr_optimization_v4.0.30319_64
:SUCCESSNET4X64
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 004 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X64 service set to delayed-auto: SUCCEDED"  

echo .NET v2 and v4 are applicable for windows 2008 images ONLY


rem ***STEP 4: Run NGEN for both x86 and x84 and log execution results

rem NGEN NO LONGER NEEDED



rem *** Microsoft .NET Framework NGEN v2.0.50727_X86

sc config clr_optimization_v2.0.50727_32 start= disabled

if %ERRORLEVEL% == 0 goto :SUCCESSNET2X86DIS
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v2.0.50727_X86 service set to disabled: FAILED"
echo Service not found: Microsoft .NET Framework NGEN v2.0.50727_X86

:SUCCESSNET2X86DIS
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for Microsoft .NET Microsoft .NET Framework NGEN v2.0.50727_X86 service set to disabled: SUCCEDED"  



rem *** Microsoft .NET Framework NGEN v2.0.50727_X64

sc config clr_optimization_v2.0.50727_64 start= disabled

if %ERRORLEVEL% == 0 goto :SUCCESSNET2X64DIS
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v2.0.50727_X64 service set to disabled: FAILED"
echo Service not found: Microsoft .NET Framework NGEN v2.0.50727_X64

:SUCCESSNET2X64DIS
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 004 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v2.0.50727_X64 service set to disabled: SUCCEDED"  



rem *** Microsoft .NET Framework NGEN v4.0.30319_X86


sc config clr_optimization_v4.0.30319_32 start= disabled

if %ERRORLEVEL% == 0 goto :SUCCESSNET4X86DIS
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 001 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X86 service set to disabled: FAILED"
echo Service not found: Microsoft .NET Framework NGEN v4.0.30319_X86

:SUCCESSNET4X86DIS
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 003 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X86 service set to disabled: SUCCEDED"  



rem *** Microsoft .NET Framework NGEN v4.0.30319_X64

sc config clr_optimization_v4.0.30319_64 start= disabled

if %ERRORLEVEL% == 0 goto :SUCCESSNET4X64DIS
EVENTCREATE /T ERROR /so CitrixSealing /L Application /ID 002 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X64 service set to disabled: FAILED"
echo Service not found: clr_optimization_v4.0.30319_64

:SUCCESSNET4X64DIS
EVENTCREATE /T Information /so CitrixSealing /L Application /ID 004 /D "CitrixSealing: Result for Microsoft .NET Framework NGEN v4.0.30319_X64 service set to disabled: SUCCEDED"  

rem ***
rem ***End of section exclusive for Citrix/SCM servers, belows steps apply to all servers.
rem ***
rem ***



:EEHRstart

rem ***
rem *** Delete Citrix cached policies 
rem ***
rem ***

rmdir "C:\ProgramData\Citrix\GroupPolicy\" /s /q




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

rem *** Reset counters
cd c:\windows\system32
lodctr /R
lodctr /R
cd c:\windows\sysWOW64
lodctr /R
lodctr /R

rem *** Registry Hacks

powershell -executionpolicy bypass "\\172.30.16.7\SealingBatchFiles\Files\RegHacksEndOfSeal.ps1"



rem ***Track sealing process completion

wscript "\\172.30.16.7\SealingBatchFiles\Files\TrackSealingFinished.vbs"

EVENTCREATE /T Information  /L APPLICATION /ID 501 /D "CitrixSealing: Sealing completed"

del /s /q %systemdrive%\$Recycle.bin

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
