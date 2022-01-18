Get-Service -name "ccmexec" | Stop-Service -Force

Remove-Item -Path c:\windows\smscfg.ini -Force

Remove-Item -Path HKLM:\Software\Microsoft\SystemCertificates\SMS\Certificates\* -Force

Get-WmiObject -Namespace root/ccm/invagt -Query "Select * from InventoryActionStatus where inventoryactionid = '{00000000-0000-0000-0000-000000000001}'" | Remove-WmiObject
