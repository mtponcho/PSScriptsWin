$File = dir d:\xenappcount\201404-NumberOfXenAppUsers.log
$file.fullname


 
$fromaddress = "no_reply@allscripts.com" 
$toaddress = "David.Hickman@allscripts.com" 
#$bccaddress = "marco.torres@allscripts.com" 
$CCaddress = "marco.torres@allscripts.com" 
$Subject = "LH: Hourly User count (automatically generated)" 
$body = "LH report attached"
$attachment = $file.fullname

$smtpserver = "172.30.4.18" 
 
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
$message.CC.Add($CCaddress) 
$message.Bcc.Add($bccaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach) 
$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message) 