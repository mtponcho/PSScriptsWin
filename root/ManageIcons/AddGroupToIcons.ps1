asnp citrix*




foreach($application in Get-XAApplication -BrowserName "TEST 163 - Enterprise Gateway*") {
Add-XAApplicationAccount $application.DisplayName "MISAG\MISAGSunTESTEnterpriseGateway-G"
}

# XA hide all apps when disabled
#set-xaapplication * -hidewhendisabled $true