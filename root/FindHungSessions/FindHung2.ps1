Add-PSSnapin Citrix.*
$Results = @()
 
$Date = (Get-Date -DisplayHint Date)
$save_date = $Date.ToString("MM-dd-yyyy-hh-mm-ss-tt")
$Results += Get-BrokerSession -AppState Prelogon -Filter { BrokeringTime -lt "-0:20" } | select DNSname, AgentVersion If (!$Results) { exit } Else { ##Restart the Citrix Desktop Service on stuck servers foreach ($vda in $Results) { Restart-Service -InputObject $(get-service -ComputerName $vda.DNSName -Name "Citrix Desktop Service") -Verbose $EmailBodyList += $vda.DNSName + "`t" + $vda.AgentVersion + "`r`n"
}
}
##Writes the result to a CSV file on your delivery controller for historical purposes $file_output = ('C:\Citrix_VDA_Restart\XA_VDA_' + $save_date + '.csv') $Results | Export-CSV -Path $file_output -NoTypeInformation
 
##Sends an email with the list of servers in the body as well as the CSV attachment $filename = $file_output $smtpServer = “SMTPSERVER.FQDN.ENTRY”
$msg = new-object Net.Mail.MailMessage
$att = new-object Net.Mail.Attachment($filename) $smtp = new-object Net.Mail.SmtpClient($smtpServer) $msg.From = “citrix@company.com”
$msg.To.Add(“username@company.com”)
$msg.Subject = “XenApp 7.x servers with sessions stuck Initializing”
$msg.Body = “The below XenApp 7.x servers have sessions stuck Initializing on the Delivery Controllers. This script is now attempting to restart the Citrix Desktop Service on the impacted servers and force the VDA to register.” + "`r`n" + "`r`n" + $EmailBodyList
$msg.Attachments.Add($att)
$smtp.Send($msg)
 
Start-Sleep -s 5

exit
