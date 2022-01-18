# Toua vue
# September 14, 2016
# 

Clear-Host
#$ErrorActionPreference = 'Silentlycontinue'
Add-PSSnapin Citrix*
$csvfile = "C:\Tools\FarmHealthCHK\Reports\SessionsAndUsersCount.txt"
$DT = Get-Date -Format g | Out-File -Append $csvfile 
$Sessiontxt = "Total sessions count: "
$Usertxt = "Total users count: " 
$SessionCount = (Get-XaSession -farm | Where-Object {$_.Protocol -eq "Ica" -and $_.State -eq "Active"}).Count
$UserCount = (Get-XaSession -farm | Where-Object {$_.Protocol -eq "Ica" -and $_.State -eq "Active"} | Select AccountName -Unique).Count
$Sessiontxt + $SessionCount | Out-File -Append $csvfile
$Usertxt + $UserCount | Out-File -Append $csvfile
Write-Output `n | Out-File $csvfile -Append
