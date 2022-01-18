[CmdletBinding(DefaultParametersetName="HostList")]            
 Param             
   (            
    [Parameter(Mandatory=$true,            
               ParameterSetName="HostFile")]            
    [Alias("computers")]            
    [String]$HostFile,            
    [Parameter(Mandatory=$true,            
               ParameterSetName="HostList",               
               ValueFromPipeline=$true,            
               ValueFromPipelineByPropertyName=$true)]            
    [Array]$HostList,            
    [Switch]$Mail,
    #[String[]]$TO = @("marco.torres@allscripts.com"),         
    [String[]]$TO = @("Eric.Hart@allscripts.com"),
    [String]$CC = "TSSClientDelivery@allscripts.com",
    [String]$FROM = "HY_Uptime@allscripts.com",            
    [String]$SMTP = "172.30.4.18",            
    [String]$Subject = "HY Uptime report $(get-date)",
    [string]$attach= "C:\Batch\HY_Uptime\uptimeReport.txt"                
   )#End Param             
            
Begin            
{            
 Write-Host "Retrieving Computer Info . . ." -nonewline            
}            
Process            
{            
switch ($PsCmdlet.ParameterSetName)             
    {             
    "HostFile"  {$Servers = (Get-Content $HostFile)}             
    "HostList"  {$Servers = $HostList}             
    } 
               
$UptimeReport = $Servers | ForEach-Object {            
$ErrorActionPreference = 0            
$wmi=Get-WmiObject -class Win32_OperatingSystem -computer $_            
$ErrorActionPreference = 1            
if ($wmi -ne $Null)            
{            
$LBTime=$wmi.ConvertToDateTime($wmi.Lastbootuptime)            
[TimeSpan]$uptime=New-TimeSpan $LBTime $(get-date)            
New-Object PSObject -Property @{             
Server=$_            
Uptime="----->"            
Days=$uptime.days.tostring()            
Hours=$uptime.hours.tostring()            
Minutes=$uptime.minutes.tostring()            
Seconds=$uptime.seconds.tostring()}            
$wmi=$null            
}            
}            
$Report = $UptimeReport |            
Select-Object Server,Uptime,Days,hours,minutes,seconds |            
Sort-Object -Property Server | ft -AutoSize            
$textreport = $report | Out-file -FilePath "C:\Batch\HY_Uptime\uptimeReport.txt"
$textreport = $report | Out-String            
get-date  
$zzz= hostname          
$textreport            
if ($Mail)            
{            
Send-MailMessage -Body "$textreport Script is configured on $zzz" -to $TO -Cc $CC -from $FROM `
-Subject $Subject -SmtpServer $SMTP -Attachments $attach            
}            
}            
End            
{            
$Hostlist = $Null            
$Hostname = $Null            
}