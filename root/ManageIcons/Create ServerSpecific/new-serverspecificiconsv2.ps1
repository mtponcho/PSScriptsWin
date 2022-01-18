#__________________________________________________________________________________________________________#
#..Written by Manu Panicker(manu.panicker@atos.net)
#..Please read instructions on how to use this.............................................................
#..Copy this as .ps1 file to a delivery controller.........................................................
#..Make sure the "Citrix folder" for Server specific is created for the environment you intent to run this.
#..run it like shown below--
#..Example PS C:\script> .\script.ps1 -domain uh1adcv1 -vdalist c:\servers.txt -userlist c:\users.txt -dg AG_PROD1 -envid "DEV" -Clientfolder "Inpatient\outpatient\support\unsupport\server specific"
#..userlist - has to like below
#  eclptsc\mpanicker
#  eclptsc\vchandel
#  eclptsc\mtorres
#  mm1adcv1\dev-server specific
#  mon_NT\jared 
#
#
#..serverlist has to be like below
#  ag1actpvaa
#  ag1bctpvaa
#  ag1bctpvac
#  ag1bctpvcc
#..dg is where you specify the Delivery group name
#..domain,vdalist,userlist,dg,envid,clientfolder are mandatory parameters
#___________________________________________________________________________________________________________#

$logpath ="\\tscmgr\Software\_USER HOME FOLDERS\mpanicker\Citrixsev-12assistlogs7x"
$username=$env:USERNAME
$time=get-date
$ss = $username + "-->" +$time
$ss | Out-File -Append "$logpath\serverspecificiconmaker.txt"
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 250
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 55
$newsize.width = 170
$pswindow.windowsize = $newsize
#$pswindow.buffersize = "9000"
$pswindow.foregroundcolor = "Cyan"
$pswindow.windowtitle ="::Server specific Icon maker:: V_2::"

#param($domain,$vdalist,$userlist,$dg,$envid,$clientfolder
#)

$domain = Read-Host "1.Client Domain Name"
$vdalist = Read-Host "2.XenApp VDAs (path to servers.txt)"
$userlist = Read-Host "3.Accounts & Groups (path to user.txt)"
$dg = read-host "4.Delivery Group name"
$envid = Read-host "5.Application folder"
$clientfolder = Read-host "6.Storefront folder"
$commandlineagrs= Read-Host "7.Any commandline arguments(optional)"

asnp citrix*
$vdas= Get-Content $vdalist
$users =Get-Content $userlist


foreach($vda in $vdas)
{
    #makeing machinetags if they dont already exist
  Try{

    New-BrokerTag -Name $vda -Description $vda
    
     }
  Catch{

    Write-host $vda "machine tag already exists, but no issues, script will continue to make other things!"

    sleep -Seconds 2
    }
  
  Try{
    
     Add-BrokerTag -Name $vda -Machine "$domain\$vda"
    }
  Catch{ 
  
    Write-host $vda "application group exixts, but no issues, script will continue to make other things!"
       }
    #makeing applicationgroups if they dont already exist
  Try{
  New-BrokerApplicationGroup -Name $vda -Description $vda -Enabled $true -UserFilterEnabled $true
  }
  Catch {
    Write-Host $vda "application group exixts, but no issues, script will continue to make other things!"
        }
  
  Finally{
    foreach($user in $users)
        {
        add-brokeruser -Name $user -ApplicationGroup $vda
        }
Set-BrokerApplicationGroup -Name $vda -Enabled $true -RestrictToTag $vda -UserFilterEnabled $true
Add-BrokerApplicationGroup -Name $vda -DesktopGroup $dg -Priority 0
}
}

$vd = gc $vdalist

#getting the list of application groups for specific servers
$applicationgroups = foreach($v in $vd){Get-BrokerApplicationGroup -name $v | select -ExpandProperty name}

#finding the iconuid for uishell
$iconuid = Get-BrokerApplication | Where{$_.CommandLineExecutable -like "*uishell*"} | select iconuid | select -First 1 | select -ExpandProperty iconuid

#making the icons for all servers
foreach($applicationgroup in $applicationgroups)
{
New-BrokerApplication -AdminFolder "$envid\server specific" -ApplicationGroup $applicationgroup `
-BrowserName "$envid - Enterprise Gateway - $applicationgroup" `
-PublishedName "$envid - Enterprise Gateway - $applicationgroup" `
-ApplicationType HostedOnDesktop -ClientFolder $clientfolder `
-CommandLineExecutable "C:\Program Files (x86)\Allscripts Sunrise\Helios\8.2\Gateway\UIShell.exe" `
-commandlinearguments $commandlineagrs `
-WorkingDirectory "C:\Program Files (x86)\Allscripts Sunrise\Helios\8.2\Gateway" `
-Enabled $true -Name "$envid - Enterprise Gateway - $applicationgroup" `
-IconUid $iconuid
}
