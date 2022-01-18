cls

$EveryoneAllowed = Get-Content -Path .\EveryoneAllowed.txt
$EveryoneNotAllowed = Get-Content -Path .\EveryoneNotAllowed.txt
$AllowedPrinters = Get-Content -Path .\Printers.txt
$AllPrinters = (Get-Printer).Name
$CurrentOU = Get-ADOrganizationalUnit -Identity $(($adComputer = Get-ADComputer -Identity $env:COMPUTERNAME).DistinguishedName.SubString($adComputer.DistinguishedName.IndexOf("OU=")))



$AllPrinters | ForEach-Object {
if ($AllowedPrinters -contains $_){
    Write-Host "Printer string [$_] found"
    Set-Printer $_ -PermissionSDDL $EveryoneAllowed
    }
    else{
    Write-Host "Printer string [$_] NOT found"
    Set-Printer $_ -PermissionSDDL $EveryoneNotAllowed
    }
    }

   