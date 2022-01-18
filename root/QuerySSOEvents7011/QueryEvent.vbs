
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("eventsearchresult.txt", True)
Set objServerlist = objFSO.OpenTextFile("c:\users\mtorres2\desktop\citrixservers.txt", 1)


Do Until objServerList.AtEndOfStream
strComputer = objServerList.ReadLine




Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" _
    & strComputer & "\root\cimv2")


Set colLoggedEvents = objWMIService.ExecQuery _
    ("Select * from Win32_NTLogEvent " _
        & "Where Logfile = 'System'")
For Each objEvent in colLoggedEvents
    if objEvent.EventCode = 7011 Then

   objFile.WriteLine   "Computer Name: " & objEvent.ComputerName & " Event Code: " & objEvent.EventCode

    Exit For
    End If
Next

rem Wscript.echo "Event query completed for server: " & strComputer

Loop

wscript.echo "Event query completed"


