
cls

#Start-Transcript

#$cred = Get-Credential

'{0:d3}' -f [int]$i

$pswd = Read-Host -AsSecureString

Get-Content C:\batch\backend.txt | ForEach-Object{
$CDCNAME = $_
$CDCNAME
#Enter Poweshell Session on Remote server, add Citrix SnapIn
$s = New-PSSession -ComputerName $CDCNAME
 #-Credential $cred
for($i=0; $i -lt 51; $i++){

[string]$account = "Anon" +'{0:d3}' -f [int]$i
$account

#Invoke-Command -Session $s {$h = net user $account /add Allscripts1} -ErrorAction Continue
$account
$pswd
Invoke-Command -Session $s {New-LocalUser -Name $account -Password $pswd -PasswordNeverExpires $true} -ErrorAction Continue
#Invoke-Command -Session $s {Set-LocalUser -Name $account -Password Allscripts1 -Verbose} -ErrorAction Continue


#pause
}
}
