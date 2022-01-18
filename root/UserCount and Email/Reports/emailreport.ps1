# Written by Dave Laroche
# Heavily Edited by Joshua Green to add HTML formatting for report
# Create an array to store the output
# Add-PSSnapin Citrix
Add-PSSnapin Citrix*
$HTMLMessage = @"

"@
$HTMLMiddle = @"

"@
$HTMLHeader = @"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"[]><html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
<style>
body {
  font-family: "Helvetica Neue", Helvetica, Arial;
  font-size: 12px;
  font-weight: 400;
  color: #3b3b3b;
  -webkit-font-smoothing: antialiased;
  font-smoothing: antialiased;
  background-color: #fff;
}
table { 
	width: 750px; 
	border-collapse: collapse;
	}
th { 
	background-color: #2980b9; 
	color: #fff;
    font-size:14px;
	}
td, th { 
	padding: 8px; 
	border: 1px solid #ccc; 
	text-align: left; 
	font-size: 12px;
	}
</style>
</head>
<body>
<table>
	<tbody>

"@
$HTMLFooter = @"		
	</tbody>
</table>
</body>
</html>
"@
$HTMLSummaryTable = @"
    <thead>
      <tr>
        <th>Total Servers</th>
        <th>Total Sessions</th>
        <th>Average Sessions</th>
      </tr>
    </thead>
    <tbody>
"@
$date = Get-Date -Format "yyyy/MM/dd"
$reportdate = Get-Date -Format G

$servers = Get-XAServer | where-object {$_.Logonsenabled -eq "True"} | Select @{Name="Clustername";Expression={$_."MachineName"}}, ServerName, @{Name="NumberOfSessions";expression={(Get-XASession -ServerName $_.Servername | where {$_.Protocol -eq "Ica" -and $_.State -eq "Active"}).count}} | Sort-Object ServerName

$HtmlTableHeader = @"
		<thead>
			<tr>
				<th colspan="3">Concentra Citrix Servers Report</td>
			</tr>
		</thead>
    </tbody>
    <tbody>
			<tr>
				<td width="55%">Server</td>
				<td width="22%">Sessions</td>
                <td>Uptime</td>
			</tr>

"@
foreach ($server in $servers){
    $c += 1
    Write-Host $server.ServerName - $c / $servers.count
    $sessions = $Server.NumberOfSessions
    $servername = $Server.ServerName
    $b1 = Get-WmiObject -Class Win32_operatingsystem -ComputerName $servername
    $b2 = $b1.ConvertToDateTime($b1.LocalDateTime) – $b1.ConvertToDateTime($b1.LastBootUpTime)
    $bd = $b2.days 
    $bh = $b2.Hours
    $serverrows = @"
    <tr>
        <td>$servername</td>
        <td>$sessions</td>
        <td>$bd Days $bh Hours</td>
    </tr>

"@
        $tablerows += $serverrows
}

$Count = ($servers).count
$total = (Get-XaSession -farm | Where-Object {$_.Protocol -eq "Ica" -and $_.State -eq "Active"}).Count
$ServerAvg = [math]::Round($total/$count)
If ($ServerAvg -gt 35) {
  $HtmlSummaryTable += @"
    <tr style="background:red; color:#fff;">
       <td>$count</td>
       <td>$total</td>
       <td>$serverAvg</td>
    </tr>

"@

  }  Else {

  $HtmlSummaryTable += @"
    <tr>
       <td>$count</td>
       <td>$total</td>
       <td>$serverAvg</td>
    </tr>

"@

} 

$HTMLMiddle += $HtmlTableHeader + $tablerows

$HTMLSummaryTable += @"
    </tbody>
  </tbody>
</table>
<p>Time of Report: $reportdate </p>
<br />
<table>
    <tbody>

"@
#Build the report
$HTMLMessage = $HTMLHeader + $HTMLSummaryTable + $HTMLMiddle + $HTMLFooter

#Send email of the report
Send-MailMessage -To "Marco.Torres@tideworks.com"-Subject "Citrix User Count Report - $date" -From "NoReply@allscriptscloud.com" -SmtpServer "relay1.tideworks.com" -BodyAsHtml -Body $HTMLMessage