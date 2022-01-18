
#Add-PSSnapin Citrix.*

if ($env:COMPUTERNAME -eq "HY1Dctpvaa"){

$countofsessions = Get-XASession | Where-Object {$_.BrowserName -like 'PROD*'} | measure

$htmlmessage = "Total number of session is " +  $countofsessions.count

#Send email of the report
#Send-MailMessage -To "joshua.green@allscripts.com" -Subject "Concentra Citrix User Count Report - $date" -From "NoReply@allscriptscloud.com" -SmtpServer "kcmailrelay.hs.prod" -BodyAsHtml -Body $HTMLMessage
#Send-MailMessage -To 'marco.torres@allscripts.com','marco.carcamo@atos.net' -Subject "Concentra Citrix User Count Report - $date" -From "NoReply@allscriptscloud.com" -SmtpServer "TS14RE1.eclptsc.eclipsnet.com" -BodyAsHtml -Body $HTMLMessage
Send-MailMessage -To 'eric.hart@allscripts.com' -Subject "HY Citrix User Count Report - $date" -From "No_Reply@allscripts.com" -SmtpServer "TS14RE1.eclptsc.eclipsnet.com" -BodyAsHtml -Body $HTMLMessage
}