#This script creates an Administrator Role on multiple CDCs, initially intended to provide read only access to Director for TAMs
#Written by Marco Torres 08-11-2020 version 1.0


#For interactive session use:
#Enter-PSSession -ComputerName "CITRIX CONTROLLER NAME/IP"

#Permissions to set for View only to Director:
<#
Director_AlertPolicy_Read
Director_Alerts_Read
Director_ClientDetails_Read
Director_ClientHelpDesk_Read
Director_Dashboard_Read
Director_HelpDesk_Read
Director_MachineDetails_Read
Director_SCOM_Read
Director_SliceAndDice_Read
Director_Trends_Read
Director_UserDetails_Read

#>

#$ErrorActionPreference = "SilentlyContinue"

#Start-Transcript


$CDCNAME = $env:hostname

$CDCNAME
#Enter Poweshell Session on Remote server, add Citrix SnapIn

$s = New-PSSession -ComputerName $CDCNAME
Invoke-Command -Session $s {$h = Add-PSSnapin citrix*} -ErrorAction SilentlyContinue


#Create Administrator Role
Invoke-Command -Session $s {$h = New-AdminRole -Name "TAM-DirectorAccess" -Description "View Only Access for TAMs"} -ErrorAction SilentlyContinue


#permissions to set, add/remoe as needed


Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_AlertPolicy_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_Alerts_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_ClientDetails_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_ClientHelpDesk_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_Dashboard_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_HelpDesk_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_MachineDetails_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_SCOM_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_SliceAndDice_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_Trends_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Director_UserDetails_Read"} -ErrorAction SilentlyContinue


Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Admin_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "AppDisk_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "AppDNA_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "AppLib_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "ApplicationGroup_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Applications_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "AppV_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Catalog_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Configuration_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "DesktopGroup_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "EdgeServer_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Global_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Global_Write"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Hosts_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Licensing_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Logging_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Policies_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Storefront_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Tag_Read"} -ErrorAction SilentlyContinue
Invoke-Command -Session $s {$h = Add-AdminPermission -Role "TAM-DirectorAccess" -Permission "Zone_Read"} -ErrorAction SilentlyContinue






#Assign TAM group with new role
Invoke-Command -Session $s {$h = New-AdminAdministrator "ECLPTSC\TAM-ECLPTSC-Hosting-Prod-RO-SGG"} -ErrorAction Continue
Invoke-Command -Session $s {$h = Add-AdminRight -Administrator "ECLPTSC\TAM-ECLPTSC-Hosting-Prod-RO-SGG" -Role "Read Only Administrator" -Scope All} -ErrorAction Continue
Invoke-Command -Session $s {$h = Add-AdminRight -Administrator "ECLPTSC\TAM-ECLPTSC-Hosting-Prod-RO-SGG" -Role "TAM-DirectorAccess" -Scope All} -ErrorAction Continue



#Assign svc-SNOW-ITOM with Read Only role
Invoke-Command -Session $s {$h = New-AdminAdministrator "ECLPTSC\svc-SNOW-ITOM"} -ErrorAction Continue
Invoke-Command -Session $s {$h = Add-AdminRight -Administrator "ECLPTSC\svc-SNOW-ITOM" -Role "Read Only Administrator" -Scope All} -ErrorAction Continue
#pause
}