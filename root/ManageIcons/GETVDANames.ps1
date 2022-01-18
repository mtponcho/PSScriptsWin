asnp citrix*

Get-BrokerMachine -Property MachineName | Out-File "c:\VDAservers.txt" -Encoding default
(gc "c:\VDAservers.txt") | ? {$_.trim() -ne "" } | set-content "c:\VDAservers.txt"