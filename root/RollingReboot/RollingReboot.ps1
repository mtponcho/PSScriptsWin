####################################################################################
<#
 Script Purpose: Rolling Reboot
 Written by: Rajeshkanna Ganesan

 Below steps to configure the script in  taskscheduler for auto rolling reboot
 1) Copy the RollingReboot folder to the local "D drive"
 2) Fill the "ServerList.txt" with the list of servers
 3) Configure the script in task scheduler
    In Edit Action: 
      Program/script    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
      Add arguments (optional) ./RollingReboot.ps1
      Start in (optional) D:\Rolling Reboot

 Below are the Script Activity Explanation
 1) Test the server reachability.
 2) Take the server out of rotation, if the server is already out of rotation it will proceed with the step 3
 3) Logoff the users who are all idle for 10 minutes or greater, and you would find a "D:\RollingReboot\Logoff.log" 
    which record all the activity for future reference.
 4) If there were no users on the given server then it will reboot and the server name will get removed from the 
    "D:\RollingReboot\serverList.txt" file and the server name will be added to the D:\RollingReboot\ServersRestarted.log"
 5) After the "D:\RollingReboot\ServerList.txt" becomes empty the script will do no action. then you need to fill second set 
    of servers to perform rolling reboot.

Note: "D:\RollingReboot\Serversrestarted.log" contains the list of servers rebooted. 
      "D:\RollingReboot\ServerList.txt" contains the list of servers to do rollingreboot
       After Completed with your rolling reboot Please delete the Task scheduler which you have created for this. 

#>
###################################################################################
$srvlistPath = "D:\RollingReboot\ServerList.txt"
$srvlist = cat $srvlistPath
$LogFilePath="D:\RollingReboot\Logoff.log"
$RestartedList= "D:\RollingReboot\ServersRestarted.log"
$Time= Get-Date -Format "MMM-dd-yyyy_hh:mm tt"
##############################################################################################

function loadsnapin
{
  if (Get-PSSnapin Citrix.Common.Commands -ea 0)
     {  Write-Host "Citrix.Common.Commands snapin already loaded" -ForegroundColor Yellow   }
  else
    {
          Write-Host "Loading Citrix.Common.Commands snapin..." -ForegroundColor Yellow
          Add-PSSnapIn Citrix.*
    }
}

##################################################################################################
function serverlogon
{
param($servername) 
$status=(Get-XAServer -ServerName $servername).LogonMode
# write-Host " $servername is in $status mode"
if ( $status -match "AllowLogOns")
 { 
  Set-XAServerLogOnMode -LogOnMode ProhibitNewLogOnsUntilRestart -ServerName $servername
  Write-Host "$Time : $servername is in $status mode,Hence placed it in prohibitLogonUntillRestart Mode" >> $LogFilePath
 }
else { echo "$Time : $servername Remote Logins are already disabled" >> $LogFilePath }
}
################################################################################################
function logoffidleuser($servername)
{

$ErrorActionPreference = "SilentlyContinue";
$icacount= (quser /server:$servername) -replace '\s{2,}', ',' | ConvertFrom-Csv | ?{($_.SessionName -like "ica-tcp*")} | select -ExpandProperty SessionName | Measure-Object | select count   
    if($icacount.count -ne 0)
    {
        $SessionName=(quser /server:"$servername") -replace '\s{2,}', ',' | ConvertFrom-Csv  | ?{($_.SessionName -like "ica-tcp*")} | Select USERNAME, SessionName,"LogOn Time"
        #"$SessionName on $servername" >> $LogFilePath

        $sessionid=(quser /server:"$servername") -replace '\s{2,}', ',' | ConvertFrom-Csv  | ?{($_.SessionName -like "ica-tcp*") -and ($_."IDLE TIME" -ge 5)} | select -ExpandProperty ID
       if("$sessionid")
	    { 
		foreach($session in $sessionid)
        	{
          	  
          	  logoff $session /Server:"$servername"
          	  "$Time : $servername - Session ID:$session logged off successfully" >> $LogFilePath
        	}
	    }
       else { echo "$Time : $servername All users are Active, Hence Logoff idle sessions cannot perform" >> $LogFilePath }
    }
    $ErrorActionPreference = "Continue";
  }
###########################################################################################
function sessioncount($servername)
{
$totalActiveSessions = @(Get-XASession -ServerName $servername | ? { $_.Protocol -eq "Ica" -and $_.State -eq "Active"}).count

return $totalActiveSessions

}
###########################################################################################
 loadsnapin
  foreach ($srv in $srvlist)
  {
    if(Test-Connection -ComputerName $srv -ea 0 -quiet)
     {
        echo "$Time : $srv is Reachable,So proceeding further.." >> $LogFilePath
        serverlogon($srv)
        logoffidleuser($srv)
        $count = sessioncount($srv)    
        if($count -eq 0)   
          {
            echo "$Time : Restarting $srv due to No Users on it...." >> $LogFilePath
	        # restart-computer -computername $srv -Force
            Get-WmiObject win32_computersystem -ComputerName $srv | Restart-Computer -Force
            echo "$Time : $srv Restarted...." >> $LogFilePath

            $srvlist = $srvlist -notlike "$srv";
            $srv >> $RestartedList
           }
       }
    else 
     { 
      echo "$Time : $srv is not reachable, So Logingoff ICA idle users and Rebooting server is not possible." >> $LogFilePath
     }
   
  }
  $srvlist > $srvlistPath;