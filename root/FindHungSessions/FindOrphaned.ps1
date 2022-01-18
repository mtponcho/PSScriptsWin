Add-PSSnapin Citrix.*
$Results = @()

$listvda = "C:\Batch\XAHung.txt"
$Date = (Get-Date -DisplayHint Date)
$save_date = $Date.ToString("MM-dd-yyyy-hh-mm-ss-tt")
$Results += Get-BrokerSession -SessionState Disconnected -filter { username -eq $null } | select machineName | Out-File 'C:\Batch\XAHung.txt'


<#

Get-Content C:\Batch\XAHung.txt | ForEach-Object{
$VDA = $_
$VDA = $VDA.Replace(" ","")
if ($VDA -like "*\*"){
#$VDA
Echo ""
Echo "Restarting service on:" , $VDA.Substring(9)

$regstate = ""

Get-Service -ComputerName $VDA.Substring(9) -Name *BrokerAgent* | Stop-Service
Get-Service -ComputerName $VDA.Substring(9) -Name *BrokerAgent* | Start-Service

$regstate = (Get-BrokerMachine -MachineName $VDA).RegistrationState



while ($true){
    if ($regstate -eq "Registered"){
        echo ""
        echo $vda "is now registered, moving to next server in the list"
        $regstate = ""
        Break
        }
         else{
        Start-Sleep 10
        echo ""
        $regstate = (Get-BrokerMachine -MachineName $VDA).RegistrationState
        echo $vda $regstate "This server is not registered, please wait..."
                
        }
    }


}

}
echo "End of cycle"


#>

#Email send
$fromaddress = "PW_CitrixAlert@allscripts.com"
$toaddress = "marco.torres@allscripts.com"
 
$Subject = “PW: XenApp 7.x servers with orphaned sessions”
$body = “The below XenApp 7.x servers have orphaned sessions” # + "`r`n" + "`r`n" + $EmailBodyList
#$body = $Results

$smtpserver = "172.30.4.18"  
$message = new-object System.Net.Mail.MailMessage 
send-MailMessage -SmtpServer $smtpserver -To $toaddress -From $fromaddress -Subject $subject -Body $body -BodyAsHtml -Priority High -Attachments $listvda

<#

If ((Get-Content $listvda) -neq $Null) {
"File is blank"
}


Start-Sleep -s 5

#>

exit
