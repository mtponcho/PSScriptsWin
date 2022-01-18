$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    #Filter = 'Documents (*.docx)|*.docx|SpreadSheet (*.xlsx)|*.xlsx'
    Filter = 'Text Files (*.txt)|*.txt'
}
$null = $FileBrowser.ShowDialog()



$LogNamesToModify = Get-Content -Path $FileBrowser.FileName
$LogNamesToModify



$NewLogFolder = $NewLogDrive + $newlog

if(!(Test-Path $NewLogFolder -PathType Container)) { 
    write-host "-- Path not found"
    New-Item -Path $NewLogDrive -Name $NewLogPath -ItemType "directory"
    $acl = Get-Acl $NewLogFolder
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT SERVICE\EventLog","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($accessRule)
    Set-Acl $NewLogFolder $acl
}



#Stop-Service EventLog
#Copy-Item -Recurse "C:\Windows\System32\winevt\Logs" -Destination "D:\winevt\" -Force


<#

foreach ($FullNameLog in $LogNamesToModify){

$FullNameLog
$FullPathLog = $FullNameLog.Replace("/","%4")
$FullPathLog
wevtutil sl $FullNameLog /lfn:"D:\winevt\Logs\$FullPathLog.evtx"
#pause
}

#Start-Service EventLog
#>