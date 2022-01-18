$sourceServer = $env:COMPUTERNAME
$targetServer = "PW1ECP4"
$LetterdriveToSync = "E"
$FolderToSync = "PROD"

$DiskSource = $LetterdriveToSync + ":\" + $FolderToSync
$DiskTarget = "\\" + $targetServer + "\" + $LetterdriveToSync + "$\" + $FolderToSync


$LocalFiles = @(Get-ChildItem $DiskSource -Filter *.vhdx | % {$_.BaseName} )
$RemoteFiles = @(Get-ChildItem $DiskTarget -Filter *.vhdx | % {$_.BaseName} )


#Next array contains all file names that were not found on target server that exist on source

$DeltaBetweenServers = @($LocalFiles | where {$RemoteFiles -notcontains $_})




Import-Module "C:\Program Files\Citrix\Provisioning Services Console\citrix.pvs.snapin.dll"
asnp citrix*


#Next array contains all properties for vdisks that are in PVS console

$PVSDiskList =  Get-PvsDiskInfo
cls
#$DeltaBetweenServers
#$PVSDiskList | % {$_.Name}



$Results = @()
Import-Module BitsTransfer

foreach ($DeltaDisk in $DeltaBetweenServers) {
$DeltaDisk
foreach($Disk in $PVSDiskList) {
    # Building Properties for each disk

if($Disk.Name -match $Deltadisk -and $Disk.WriteCacheType -eq "9"){
    #$DeltaDisk + " vs " + $Disk.Name
    $argsPVP = $DiskSource + "\" + $DeltaDisk + ".pvp "
    $argsVHD = $DiskSource + "\" + $DeltaDisk + ".vhdx "

Start-BitsTransfer -Source $argsPVP -Destination $DiskTarget -Description $DeltaDisk -DisplayName "Copy"
Start-BitsTransfer -Source $argsVHD -Destination $DiskTarget -Description $DeltaDisk -DisplayName "Copy"

    $Properties = @{
        DiskName = $Disk.Name
        ServerName = $Disk.ServerName
        DiskStore = $Disk.StoreName
        DiskMode = $Disk.WriteCacheType
        IsHAEnabled = $Disk.HAEnabled
        WriteCacheAmount = $Disk.WriteCacheSize
        DiskDescription = $Disk.Description
    } #close Properties
           
    # Stores each Application setting for export
    $Results += New-Object psobject -Property $properties
    }
    }
    }

# Setting File name with time stamp
$Date = Get-Date
#$FileName = $Date.ToShortDateString() + $Date.ToLongTimeString()
#$FileName = (($FileName -replace ":","") -replace " ","") -replace "/",""
#$FileName = "ListOfDisksOnSource" + $FileName + ".xml"
$FileName = "ListOfDisksOnSource" + ".xml"
# Exporting results
$Results | export-clixml .\$FileName
  

<# End of query on sorce server, below code is to initiate copy of files not found at target#>




