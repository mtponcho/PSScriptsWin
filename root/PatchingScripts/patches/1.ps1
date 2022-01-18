$t = gc c:\users\mtorres\desktop\1.txt

icm -jobname one -computername $t -credential $cred{

 $os = gwmi -cl win32_operatingsystem
$fixid= gwmi -cl win32_quickfixengineering
 if($os.version -match "6.1") {
  #Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019264"} 

  if(Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019264"}) 
      { write-host "$($env:computername) OSv: $($os.version) is patched " }
else 
   { write-host "$($env:computername) OSv: $($os.version)  patch missing"}

}
elseif ($os.version -match "6.3"){

if(Get-WmiObject -Class Win32_QuickFixEngineering -Filter{HotFixID = "kb4019215"}) 
     { write-host "$($env:computername) OSv: $($os.version) is patched " }
else 
   { write-host "$($env:computername) OSv: $($os.version)  patch missing"}

}


}

get-job -name one | wait-job | receive-job 2> one_err.txt

remove-job -name one