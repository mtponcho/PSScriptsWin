$t = gc servers.txt
$user ="eclptsc\mtorres1"

$password1 = "Marquito1." | convertto-securestring -asplaintext -force
$cred = new-object -type System.Management.Automation.PSCredential ($user,$password1)
icm -jobname one -computername $t -credential $cred{

 $os = gwmi -cl win32_operatingsystem
$fixid= gwmi -cl win32_quickfixengineering
 if($os.version -match "6.1") {
  #Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019264"} 

  if(Get-HotFix -ID "KB4019264") 
    { write-host "$($env:computername) operating system version: $($os.version)  has fix present " }
else 
   { write-host "$($env:computername) operating system version: $($os.version)  doesnt have fix"}

}
elseif ($os.version -match "6.3"){

if(Get-HotFix -ID "KB4019264") 
    { write-host "$($env:computername) operating system version: $($os.version) has fix present " }
else 
   { write-host "$($env:computername) operating system version: $($os.version)  doesnt have fix"}

}


}

get-job -name one | wait-job | receive-job 2> servers_err.txt

remove-job -name one