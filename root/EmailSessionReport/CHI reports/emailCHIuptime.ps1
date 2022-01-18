

#$secpasswd = ConvertTo-SecureString "Ekjhkjhk" -AsPlainText -Force
#$mycreds = New-Object System.Management.Automation.PSCredential ("VPRDSMGMT001\citrixreporting", $secpasswd)

Copy-Item "\\10.190.0.178\UptimeCHI\UptimeReport.txt" -Destination "c:\Batch"
Copy-Item "\\10.190.0.178\UptimeCHI\CHI_VDAs_NOT_ALLOWING_CONNECTIONS.txt" -Destination "c:\Batch" 


$File1 = dir "c:\Batch\CHI_VDAs_NOT_ALLOWING_CONNECTIONS.txt"
$File2 = dir "c:\Batch\UptimeReport.txt"

$file1.fullname
$file2.fullname

 
$fromaddress = "no_reply@allscripts.com" 
$toaddress = "tssclientdelivery@allscripts.com"
#$bccaddress = "marco.torres@allscripts.com" 
#$CCaddress = "marco.torres@allscripts.com" 
$Subject = "CHI uptime report attached: *******PLEASE READ*******" 
$body = "Please review attached files for any errors on reboots and/or server registration"
$attachment1 = $file1.fullname
$attachment2 = $file2.fullname

$smtpserver = "172.30.4.18" 
 
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
#$message.CC.Add($CCaddress) 
#$message.Bcc.Add($bccaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$message.Priority = [System.Net.Mail.MailPriority]::High
$attach = new-object Net.Mail.Attachment($attachment1) 
$attach2 = new-object net.mail.attachment($attachment2)
$message.Attachments.Add($attach) 
$message.Attachments.Add($attach2) 

$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message) 