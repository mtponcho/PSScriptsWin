on error resume next
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("eventsearchresult.txt", True)
Set objServerlist = objFSO.OpenTextFile("c:\citrixservers.txt", 1)

objFile.WriteLine  "Event Found at:"

Do Until objServerList.AtEndOfStream
strComputer = objServerList.ReadLine




Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" _
    & strComputer & "\root\cimv2")




Set colLoggedEvents = objWMIService.ExecQuery _
    ("Select * from Win32_NTLogEvent " _
        & "Where Logfile = 'System'")
For Each objEvent in colLoggedEvents
    if inStr (1,objEvent.Message,"SSOManHost") Then
    
    objFile.WriteLine  strComputer
    Exit For
    End If
Next


rem Wscript.echo "Event query completed for server: " & strComputer

Loop

wscript.echo "Event query completed"


