asnp citrix*

Get-BrokerMachine -Property MachineName -MaxRecordCount 5000 | Out-File "c:\VDAservers.txt" -Encoding default
(gc "c:\VDAservers.txt") | ? {$_.trim() -ne "" } | set-content "c:\VDAservers.txt"