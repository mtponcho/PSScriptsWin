$key = 'HKLM:\SYSTEM\CurrentControlSet\services\bnistack\PvsAgent'
$vdiskname = (Get-ItemProperty -Path $key).DiskName


 
$fromaddress = "CitrixSealing@allscripts.com"
$toaddress = "TSSClientDelivery@allscripts.com"


if ( $env:USERNAME -eq "VChandel"){$toaddress = "Vibhvesh.Chandel@allscripts.com"}
if ( $env:USERNAME -eq "DEasterd"){$toaddress = "Diane.Easterday@allscripts.com"}
if ( $env:USERNAME -eq "AKadri"){$toaddress = "Asrar.Kadri@allscripts.com"}
if ( $env:USERNAME -eq "aKhan"){$toaddress = "Ray.Khan@allscripts.com"}
if ( $env:USERNAME -eq "jMoore1"){$toaddress = "Gerald.Moore@allscripts.com"}
if ( $env:USERNAME -eq "snazirmulla"){$toaddress = "Sarfaraz.NazirMulla@allscripts.com"}
if ( $env:USERNAME -eq "MPanicker1"){$toaddress = "Manu.Panicker@allscripts.com"}
if ( $env:USERNAME -eq "VPeters"){$toaddress = "Vanessa.Peters@allscripts.com"}
if ( $env:USERNAME -eq "CSmetters"){$toaddress = "Craig.Smetters@allscripts.com"}
if ( $env:USERNAME -eq "RSolanki"){$toaddress = "Rohan.Solanki@allscripts.com"}
if ( $env:USERNAME -eq "DStewart"){$toaddress = "Darryl.Stewart@allscripts.com"}
if ( $env:USERNAME -eq "MTorres"){$toaddress = "Marco.Torres@allscripts.com"}
if ( $env:USERNAME -eq "KTyther"){$toaddress = "Keith.Tyther@allscripts.com"}
if ( $env:USERNAME -eq "dzorola"){$toaddress = "Daniel.CuetoZorola@allscripts.com"}
if ( $env:USERNAME -eq "kmistry"){$toaddress = "Kaushal.Mistry@allscripts.com"}
if ( $env:USERNAME -eq "jpatel"){$toaddress = "Jigneshkumar.Patel@allscripts.com"}


$toaddress

#$bccaddress = "somebody@allscripts.com" 
#$CCaddress = "somebody@allscripts.com" 
$Subject = $env:computername + " sealing progress"
$body = "NGEN x86 process completed on vdisk: " +  $vdiskname + " check if NGEN x64 is also completed on GLD server"
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