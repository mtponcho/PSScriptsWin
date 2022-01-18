
 
$fromaddress = "CitrixMonitoring@allscripts.com"
$toaddress = "marco.torres@allscripts.com"


$VDA = Get-BrokerMachine -LastDeregistrationReason ContactLost -ControllerDNSName $IsNullOrEmpty -Property MachineName | Out-String
$VDA = $VDA.Replace("PE1ADCV1\","  , ")

#Get-Content c:\stuckservers.txt | ForEach-Object{
#$VDA = $_}

 
#################################### 
$DateTimeMark = Get-Date -format g
$Subject = "Alert server unregistered " + $DateTimeMark
$body = "test"
#$attachment = $file.fullname


$smtpserver = "172.30.4.18"  
#$attach = new-object Net.Mail.Attachment($attachment) 
#$message.Attachments.Add($attach) 
$message = new-object System.Net.Mail.MailMessage 
send-MailMessage -SmtpServer $smtpserver -To $toaddress -From $fromaddress -Subject $subject -Body $body -BodyAsHtml -Priority High