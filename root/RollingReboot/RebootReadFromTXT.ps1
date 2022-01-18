
$txtfile = $env:userprofile
$txtfile = $txtfile + "\Desktop\citrixservers.txt"
$srvlist= Get-Content $txtfile
$srvlist


foreach($srv in $srvlist)
{
Get-WmiObject win32_computersystem -ComputerName $srv | Restart-Computer -Force
}


<#
$fromaddress = "CitrixAutomatedTasks@allscripts.com"
$toaddress = "marco.torres@allscripts.com"
#$bccaddress2 = "TSSClientDelivery@allscripts.com"
 
#################################### 
$DateTimeMark = Get-Date -format g
$Subject = "Citrix servers reboot " + $DateTimeMark
$body = "<br><br><br>"

#$body = "***ED Board servers for UH being rebooted, please notify client when they are back online*** <br><br>"
#$body += "Call: 216-844-3327 (preferred)<br><br>"


#$body2 = "<br><br><br>"
#$body2 = "***Please be aware of Citrix servers for ED Board being rebooted, we will notify you when they are back online fo reconnection*** <br><br>"

$smtpserver = "172.30.4.18"  
$message = new-object System.Net.Mail.MailMessage 
send-MailMessage -SmtpServer $smtpserver -To $toaddress -From $fromaddress -Subject $subject -Body $body -BodyAsHtml -Priority High
send-MailMessage -SmtpServer $smtpserver -To $toaddress2 -bcc $bccaddress2 -From $fromaddress -Subject $subject -Body $body2 -BodyAsHtml -Priority High
#>