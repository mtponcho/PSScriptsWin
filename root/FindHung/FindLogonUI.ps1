asnp citrix*

cls
$counter = 0
$Title = "CT report" | Out-File "c:\LogonUICT.txt"
Get-Content c:\VDAservers.txt | ForEach-Object{
$VDA = $_
$VDA = $VDA.Replace(" ","")
    if ($VDA -like "*\*"){
    $VDA = $VDA.Substring(9)
    $VDA = $VDA + ".ct1adcv1.eclptsc.eclipsnet.com"
    $VDA #| Out-File -Append "c:\LogonUICT.txt"
    Get-Process -ComputerName $VDA -Name LogonUI
    if (Get-Process -ComputerName $VDA -Name LogonUI) {
        $counter = $counter + 1
        }

    if ($counter > 1) {
        $fromaddress = "no_reply@allscripts.com" 
        $toaddress = "marco.torres@allscripts.com" 
        #$bccaddress = "marco.torres@allscripts.com" 
        #$CCaddress = "marco.torres@allscripts.com" 
        $Subject = "CT: LogonUI more than one on" + $VDA
        $body = "CT: LogonUI more than one on" + $VDA
        #$attachment = $file.fullname

        $smtpserver = "172.30.4.18"
 
        #################################### 
 
        $message = new-object System.Net.Mail.MailMessage 
        $message.From = $fromaddress 
        $message.To.Add($toaddress) 
        #$message.CC.Add($CCaddress) 
        #$message.Bcc.Add($bccaddress) 
        $message.IsBodyHtml = $True 
        $message.Subject = $Subject 
        #$attach = new-object Net.Mail.Attachment($attachment) 
        #$message.Attachments.Add($attach) 
        $message.body = $body 
        $smtp = new-object Net.Mail.SmtpClient($smtpserver) 
        $smtp.Send($message)
        }



$counter
$counter = 0
}
}

<#
$File = dir c:\LogonUICT.txt
$file.fullname


 
$fromaddress = "no_reply@allscripts.com" 
$toaddress = "marco.torres@allscripts.com" 
#$bccaddress = "marco.torres@allscripts.com" 
#$CCaddress = "marco.torres@allscripts.com" 
$Subject = "CT: LogonUI report" 
$body = "report attached"
$attachment = $file.fullname

$smtpserver = "172.30.4.18"
 
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
#$message.CC.Add($CCaddress) 
#$message.Bcc.Add($bccaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach) 
$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message) 

#>