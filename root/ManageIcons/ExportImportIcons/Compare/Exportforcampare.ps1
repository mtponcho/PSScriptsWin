<#
#         File Name : XenAppExport.ps1
#         Description:
#        
#         Exporting Application Data and Icons to XML format. This will allow
#         users to import applications and the applications settings in another
#         site for testing or site replication.
#>

# Adding Citrix Snapins
Add-PSSnapin Citrix*

# Setting start up location
$Location = $MyInvocation.MyCommand.Path -replace $MyInvocation.MyCommand.Name,"";
set-location $Location;

# Grabs applications
$apps = Get-BrokerApplication -MaxRecordCount 2147483647

$Results = @()

#use next line to filter based on Admin folder
#foreach($app in $apps | where-object {$_.AdminFolderName -match "*" } ) 

foreach($app in $apps) 

{
    # Building Properties for each application
    
    $Properties = @{
    #AdminFolderName = $app.AdminFolderName
    #AdminFolderUid = $app.AdminFolderUid
    ApplicationName = $app.ApplicationName
    #ApplicationType = $app.ApplicationType
    #AssociatedDesktopGroupPriorities = $app.AssociatedDesktopGroupPriorities
    #AssociatedDesktopGroupUUIDs = $app.AssociatedDesktopGroupUUIDs
    #AssociatedDesktopGroupUids = $app.AssociatedDesktopGroupUids
    #AssociatedUserFullNames = $app.AssociatedUserFullNames
    AssociatedUserNames = $app.AssociatedUserNames
    #AssociatedUserUPNs = $app.AssociatedUserUPNs
    #BrowserName = $app.BrowserName
    #ClientFolder = $app.ClientFolder
    #CommandLineExecutable = $app.CommandLineExecutable
    #CommandLineArguments = $app.CommandLineArguments
    #CpuPriorityLevel = $app.CpuPriorityLevel
    #Description = $app.Description
    #Enabled = $app.Enabled
    #IconFromClient = $app.IconFromClient
    #EncodedIconData = (Get-Brokericon -Uid $app.IconUid).EncodedIconData # Grabs Icon Image
    #MetadataKeys = $app.MetadataKeys
    #MetadataMap = $app.MetadataMap
    #Name = $app.Name
    #PublishedName = $app.PublishedName
    #SecureCmdLineArgumentsEnabled = $app.SecureCmdLineArgumentsEnabled
    #ShortcutAddedToDesktop = $app.ShortcutAddedToDesktop
    #ShortcutAddedToStartMenu = $app.ShortcutAddedToStartMenu
    #StartMenuFolder = $app.StartMenuFolder
    #UUID = $app.UUID
    #Uid = $app.Uid
    UserFilterEnabled = $app.UserFilterEnabled
    #Visible = $app.Visible
    #WaitForPrinterCreation = $app.WaitForPrinterCreation
    #WorkingDirectory = $app.WorkingDirectory
    }

    # Stores each Application setting for export
    $Results += New-Object psobject -Property $properties
}
# Setting File name with time stamp
$Date = Get-Date
$FileName = $Date.ToShortDateString() + $Date.ToLongTimeString()
$FileName = (($FileName -replace ":","") -replace " ","") -replace "/",""
$FileName = "Apps" + $FileName + ".xml"

# Exporting results
$Results | export-clixml .\$FileName