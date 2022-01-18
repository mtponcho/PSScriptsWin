$t = gc "c:\users\mtorres\latest.txt"
$user ="eclptsc\_CitrixReporting"

$password1 = "Eclipsys1" | convertto-securestring -asplaintext -force
$cred = new-object -type System.Management.Automation.PSCredential ($user,$password1)
icm -jobname myj -computername $t -credential $cred{

 $os = gwmi -cl win32_operatingsystem
$fixid= gwmi -cl win32_quickfixengineering
 if($os.version -match "6.1") {
  #Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019264"} 

  if(Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019264"}) 
    { write-host "$($env:computername) operating system version: $($os.version)  has fix present " }
else 
   { write-host "$($env:computername) operating system version: $($os.version)  doesnt have fix"}

}
elseif ($os.version -match "6.3"){

if(Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019215"}) 
    { write-host "$($env:computername) operating system version: $($os.version) has fix present " }
else 
   { write-host "$($env:computername) operating system version: $($os.version)  doesnt have fix"}

}


}

get-job -name myj | wait-job | receive-job 2> errWanncry.txt

#remove-job -name myj
