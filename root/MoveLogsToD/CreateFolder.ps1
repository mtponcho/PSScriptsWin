Get-Content C:\citrixservers.txt | ForEach-Object{
$CDCNAME = $_

$CDCNAME
#Enter Poweshell Session on Remote server, add Citrix SnapIn

$s = New-PSSession -ComputerName $CDCNAME
#Invoke-Command -Session $s {$h = $ExecutionContext.InvokeCommand.NewScriptBlock("mkdir D:\EventLogs")} -ErrorAction Continue
Invoke-Command -Session $s {$h = New-Item -Path "D:\" -Name "Eventlogs" -ItemType "directory"} -ErrorAction Continue


#pause
}