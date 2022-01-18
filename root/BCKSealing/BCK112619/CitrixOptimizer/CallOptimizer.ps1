$winversion= Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption
$winversion

if ($winversion -contains "2008") {

$winversion

}
