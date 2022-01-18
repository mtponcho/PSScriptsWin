
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("eventsearchresult.txt", True)
Set objServerlist = objFSO.OpenTextFile("c:\users\mtorres1\desktop\citrixservers.txt", 1)


Do Until objServerList.AtEndOfStream
strComputer = objServerList.ReadLine
objFile.WriteLine "Server: " & strComputer



Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" _
    & strComputer & "\root\cimv2")

objFile.WriteLine ""
objFile.WriteLine "EVENTS review"
objFile.WriteLine ""

Set colLoggedEvents = objWMIService.ExecQuery _
    ("Select * from Win32_NTLogEvent " _
        & "Where Logfile = 'System'")
For Each objEvent in colLoggedEvents
    if objEvent.EventCode = 7011 Then
    objFile.WriteLine ""
    objFile.WriteLine  "Category: " & objEvent.Category & VBNewLine _
    & "Computer Name: " & objEvent.ComputerName & VBNewLine _
    & "Event Code: " & objEvent.EventCode & VBNewLine _
    & "Message: " & objEvent.Message & VBNewLine _
    & "Record Number: " & objEvent.RecordNumber & VBNewLine _
    & "Source Name: " & objEvent.SourceName & VBNewLine _
    & "Time Written: " & objEvent.TimeWritten & VBNewLine _
    & "Event Type: " & objEvent.Type & VBNewLine _
    & "User: " & objEvent.User
    End If
Next
objFile.WriteLine  "---------------------------"
objFile.WriteLine  ""
rem Wscript.echo "Event query completed for server: " & strComputer

Loop

wscript.echo "Event query completed"


