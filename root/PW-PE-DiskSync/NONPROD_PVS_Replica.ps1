#Variables
$DestServer="BL0CTX1APVSS003.BL1ADCV1.ECLPTSC.ECLIPSNET.COM"
$Env="NONPROD"

Import-Module “C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll”

Get-PvsDiskLocator -SiteName Site -StoreName $Env | Foreach{
    #Getting older version
    Get-PvsDiskVersion -SiteName $_.SiteName -DisklocatorName $_.DiskLocatorName -StoreName $_.StoreName | Foreach {$OldervDiskVersion=$_.Version}
    #Exporting Manifest with oldest available version
    Export-PVSDisk -DiskLocatorName $_.DiskLocatorName -SiteName $_.SiteName -StoreName $_.StoreName -Version $OldervDiskVersion
}
#Mirroring stores
Robocopy "E:\$Env\" "\\$DestServer\E$\$Env" /MIR /xf *.lok DEV* TRN* /R:3 /W:3 /LOG:"C:\Batch\DiskSync\Prod_Sync.log"

Get-PvsDiskLocator -SiteName Site -StoreName $Env | Foreach{
    #Getting production version
    Get-PvsDiskVersion -SiteName $_.SiteName -DisklocatorName $_.DiskLocatorName -StoreName $_.StoreName | Foreach {
        If($_.CanRevertTest){$ProdVersion=$_.Version}
    }
    #Detecting any overridden version
    $Override=Get-PvsDiskVersion -Name $_.DiskLocatorName -Type 3 -SiteName $_.SiteName -StoreName $_.StoreName

    #Commands to run on Replica PVS Server
    $scriptBlock = {
        param($Disk,$ProdVersion,$Override)
        Import-Module “C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll”
        #Update vDisks versions information
        Add-PVSDiskVersion -DiskLocatorName $Disk.DiskLocatorName -SiteName $Disk.SiteName -StoreName $Disk.StoreName
        #Promote prod version on PVS003
        Invoke-PvsPromoteDiskVersion -Name $Disk.DiskLocatorName -SiteName $Disk.SiteName -StoreName $Disk.StoreName -TestVersion $ProdVersion
        #Replicate any overriden version
        If(!$Override.Version) {
            Set-PvsOverrideVersion -Name $Disk.DiskLocatorName -SiteName $Disk.SiteName -StoreName $Disk.StoreName
		} else {
            Set-PvsOverrideVersion -Name $Disk.DiskLocatorName -SiteName $Disk.SiteName -StoreName $Disk.StoreName -Version $Override.Version
		}
    }    
    #Running comans on replica PVS Server
    Invoke-Command -ComputerName $DestServer -ScriptBlock $scriptBlock -ArgumentList $_,$ProdVersion,$Override
}

#notify
#################################### 


$targetServer = "bl0ctx1apvss003"
$fromaddress = "no_reply@allscripts.com"
$toaddress = "Ed.Morano@allscripts.com","Christopher.Yorke@allscripts.com"
$DateTimeMark = Get-Date -format g
$Subject = $env:computername + " vdisk SYNC to " +$targetServer + " status at: " + $DateTimeMark

$smtpserver = "172.30.4.18"  
$message = new-object System.Net.Mail.MailMessage
$body = "NON PROD vdisk SYNC taks completed" 
send-MailMessage -SmtpServer $smtpserver -To $toaddress -From $fromaddress -Cc $ccAddress -Subject $subject -Body $body -BodyAsHtml -Priority Normal