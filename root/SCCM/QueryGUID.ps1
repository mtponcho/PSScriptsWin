 $computers = Get-Content -Path "C:\Users\rhernandez\Documents\servers.txt"

$( foreach ($Computer in $Computers) 
  {
      $Hostname = Get-WMIObject Win32_ComputerSystem -computername $Computer | Select-Object -ExpandProperty name
      $GUID =  Get-WMIObject -namespace root\ccm ccm_client clientid -ComputerName $Computer | Select-Object -ExpandProperty clientid

            
       [PSCustomObject]@{
           ComputerName = $Hostname
           GUID  = $GUID
        }
        
    } ) | Out-file -FilePath "c:\users\rhernandez\Documents\ResultGUIDSCCM.txt" # ft -auto