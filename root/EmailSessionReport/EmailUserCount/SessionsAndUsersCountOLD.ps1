# Toua vue
# September 14, 2016
# 

Clear-Host
#$ErrorActionPreference = 'Silentlycontinue'
Add-PSSnapin Citrix*
$csvfile = "C:\batch\EmailUserCount\SessionsAndUsersCount.txt"
$DT = Get-Date -Format g | Out-File -Append $csvfile 
$Sessiontxt = "Total sessions count: "
$Usertxt = "Total users count: " 
$SessionCount = (Get-BrokerMachine | Where-Object {$_.WindowsConnectionSetting -eq "LogonEnabled" -and $_.RegistrationState -eq "Registered" -and $_.DNSName -like "CONTWX1*"}).Count
$UserCount = (Get-BrokerSession -MaxRecordCount 4000 | Where-Object {$_.Protocol -eq "HDX"}).count
$Sessiontxt + $SessionCount | Out-File -Append $csvfile
$Usertxt + $UserCount | Out-File -Append $csvfile
Write-Output `n | Out-File $csvfile -Append
