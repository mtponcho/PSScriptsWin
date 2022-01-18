asnp citrix*

#Get-BrokerMachine -Property DnsName -MaxRecordCount 500 | out-file C:\Uptime\VDAList.txt -Encoding default

#Get-BrokerMachine -MaxRecordCount 500 | select -ExpandProperty DnsName | out-file C:\Uptime\VDAList.txt -Encoding default
 

Get-BrokerMachine -filter {InMaintenanceMode -eq "True" -or RegistrationState -eq "Unregistered" -or WindowsConnectionSetting -ne "LogonEnabled" } -Property MachineName,InMaintenanceMode,RegistrationState,SessionCount,WindowsConnectionSetting -MaxRecordCount 500 | out-file c:\batch\VDAs_NOT_ALLOWING_CONNECTIONS.txt