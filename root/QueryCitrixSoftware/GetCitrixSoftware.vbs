'----------------------------------------------------------------------------------------------------------- 
'----------------------------------------------------------------------------------------------------------- 
'       Author          : Syed Abdul Khader 
'       Last Modified   : 09 April 2014 
'       Description     : This script will generate the list of softwares installed in the Servers 
'       Prerequsite     : ServerList.txt needs to be populated with targeted server names 
'                         ServerList.txt files should be in location "C:\temp" 
'       Version         : 1.0 
'----------------------------------------------------------------------------------------------------------- 
'----------------------------------------------------------------------------------------------------------- 
Const ForReading = 1 
const ForAppending = 8 
Set objFSO = CreateObject("Scripting.FileSystemObject") 
Set SrvList = objFSO.OpenTextFile("C:\Users\mtorres.ECLPTSC.000\Desktop\ServerList1.txt", ForReading) 
Set Reportfile = objFSO.OpenTextFile ("C:\Users\mtorres.ECLPTSC.000\Desktop\report1.csv", ForAppending, True) 
Set objNetwork = CreateObject("Wscript.Network") 
reportfile.writeline "Report Generated by : " & objNetwork.UserName 
reportfile.WriteLine "Report generated on : " & Now 
reportfile.writeline "HostName" & ","  & "Software" & "," & "Installation Date" & "," & "Version" & "," & "Size" 
wscript.echo "Please wait until script is completed..." 
on error resume next
Do Until SrvList.AtEndOfStream 
            strComputer = ucase(srvlist.readline) 
            REM if checkserverResponse(strComputer) then 
                        srvIP = checkSoftware(strComputer) 
                        srvHostName = strcomputer 
            REM else 
            REM             reportfile.write strComputer & "," & "Server is unreachable." 
            reportfile.writeline 
            REM end if 
Loop 
 
Wscript.echo "Script completed" 


REM Set ExcelSheet = CreateObject("Excel.Application") 
REM ExcelSheet.Application.Visible = True 
REM ExcelSheet.Workbooks.Open ("C:\temp\report.csv") 


Function checksoftware(strcomputer) 
    Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE 
    strComputer = strcomputer 
    strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" 
    strEntry1a = "DisplayName" 
    strEntry1b = "QuietDisplayName" 
    strEntry2 = "InstallDate" 
    strEntry3 = "VersionMajor" 
    strEntry4 = "VersionMinor" 
    strEntry5 = "EstimatedSize" 
    Set objReg = GetObject("winmgmts://" & strComputer & "/root/default:StdRegProv") 
    objReg.EnumKey HKLM, strKey, arrSubkeys 
     
    For Each strSubkey In arrSubkeys 
        intRet1 = objReg.GetStringValue(HKLM, strKey & strSubkey, strEntry1a, strValue1) 


REM If InStr(intRet1, "Citrix") Then 
                
            


        If strValue1 <> "" Then 
            objReg.GetStringValue HKLM, strKey & strSubkey, strEntry2, strValue2 
              If strValue2 <> "" Then 
                d=CStr (strvalue2) 
               End If 
              objReg.GetDWORDValue HKLM, strKey & strSubkey, strEntry3, intValue3 
              objReg.GetDWORDValue HKLM, strKey & strSubkey, strEntry4, intValue4 
              objReg.GetDWORDValue HKLM, strKey & strSubkey, strEntry5, intValue5 
            If strvalue2 > 0 then 
                strvalue2=Cstr(strvalue2) 
                dd=Mid(strvalue2,7,2) 
                mm=mid(strvalue2,5,2) 
                yy=mid(strvalue2,1,4) 
            End if 
            intvalue5 = intValue5/1024

If InStr(strValue1, "Citrix") Then 
            If intvalue5 <> "" Then 
                If intvalue3 >=0 then  
                    If intvalue4 >=0 then 
			 
                        reportfile.writeline strcomputer & "," & strValue1 & "," & dd &"/" & mm & "/" & yy & "," & intValue3 & "." & intValue4 & "," & Round(intvalue5, 2) & " MB" 

                    End If 
                Else 
                    reportfile.writeline strcomputer & "," & strValue1 & "," & dd &"/" & mm & "/" & yy  & "," & " " & "," & Round(intvalue5, 2) & " MB" 
                End If 
            Else 
                reportfile.writeline strcomputer & "," & strValue1 & "," & dd &"/" & mm & "/" & yy  & "," & intValue3 & "." & intValue4 & "," & " " 
            End If 
End If
        End If 
REM End If
    Next 
End Function 
 
Function checkServerResponse(serverName) 
            strTarget = serverName 
            Set objShell = CreateObject("WScript.Shell") 
            Set objExec = objShell.Exec("ping -n 1 -w 1000 " & strTarget) 
            strPingResults = LCase(objExec.StdOut.ReadAll) 
            If InStr(strPingResults, "reply from") Then 
                checkServerResponse = true 
            Else 
                checkServerResponse = false 
            End If 
End Function 