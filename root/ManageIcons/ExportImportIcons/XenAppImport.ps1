<#
#   File Name : XenAppImport.ps1
#   Description: Importing Application Data and Icons from exported xml file.
#
#       Notes : Getting Delivery Group from Arguments
#               I.e. .\XenAppImport.ps1 "<Delivery Group Name>" .\<AppExportedXMLFile>.xml
#>

# Adding Citrix Snapins
Add-PSSnapin Citrix*

# Setting start up location
$Location = $MyInvocation.MyCommand.Path -replace $MyInvocation.MyCommand.Name,""
set-location $Location

# Delivery Group for imported location
$dg = Get-BrokerDesktopGroup $args[0]

#Importing Application Data
$apps = Import-Clixml $args[1]

foreach ($app in $apps)
{
       #Resetting failure detection
        $failed = $false

       #Publishing Application
        Write-Host "Publishing APPLICATON:" $app.PublishedName
        
        if ($app.CommandLineArguments.Length -lt 2) {$app.CommandLineArguments = " "}

        #Display Application Settings
        write-host -ForegroundColor Cyan "BrowserName : " $app.BrowserName
        write-host -ForegroundColor Cyan "ComdLineExe : " $app.CommandLineExecutable
        write-host -ForegroundColor Cyan "Description : " $app.Description
        write-host -ForegroundColor Cyan "ComdLineArg : " $app.CommandLineArguments
        write-host -ForegroundColor Cyan "Enabled     : " $app.Enabled
        write-host -ForegroundColor Cyan "Name        : " $app.Name
        write-host -ForegroundColor Cyan "UserFiltEna : " $app.UserFilterEnabled
        write-host -ForegroundColor Cyan "WorkingDire : " $app.WorkingDirectory
        write-host -ForegroundColor Cyan "Published   : " $app.PublishedName
        write-host -ForegroundColor Cyan "ClientFolder: " $app.ClientFolder
       
        Try{

            #Prep for Application Import - Removing Null values
            #   * Not just some null value, any null values seems to crash this processes. 
            #   * Application folders screw this field up, had to use PublishedName for -Name property.

            $MakeApp = 'New-BrokerApplication -ApplicationType HostedOnDesktop'
            if($app.BrowserName -ne $null){$MakeApp += ' -BrowserName $app.BrowserName'}
            if($app.CommandLineExecutable -ne $null){$MakeApp += ' -CommandLineExecutable $app.CommandLineExecutable'}
            if($app.Description -ne $null){$MakeApp += ' -Description $app.Description'}
            if($app.ClientFolder -ne $null){$MakeApp += ' -ClientFolder $app.ClientFolder'}
            if($app.CommandLineArguments -ne $null){$MakeApp += ' -CommandLineArguments $app.CommandLineArguments'}
            if($app.PublishedName -ne $null){$MakeApp += ' -Name $app.PublishedName'} 
            if($app.UserFilterEnabled -ne $null){$MakeApp += ' -UserFilterEnabled $app.UserFilterEnabled'}
            if($app.Enabled -ne $null){$MakeApp += ' -Enabled $app.Enabled'}
            if($dg -ne $null){$MakeApp += ' -DesktopGroup $dg'}
            if($app.WorkingDirectory -ne $null){$MakeApp += ' -WorkingDirectory $app.WorkingDirectory'}
            if($app.PublishedName -ne $null){$MakeApp += ' -PublishedName $app.PublishedName'}
            
            #Creating Application
            Invoke-Expression $MakeApp | Out-Null

        }
        catch
        {
            write-host  -ForegroundColor Red $_.Exception.Message
            write-host  -ForegroundColor Red $_.Exception.ItemName
            write-host  -ForegroundColor Red "Error on "  $app.BrowserName
            write-host  -ForegroundColor Red "Error on "  $app.CommandLineExecutable
            write-host  -ForegroundColor Red "Error on "  $app.Description
            write-host  -ForegroundColor Red "Error on "  $app.CommandLineArguments
            write-host  -ForegroundColor Red "Error on "  $app.Enabled
            write-host  -ForegroundColor Red "Error on "  $app.Name
            write-host  -ForegroundColor Red "Error on "  $app.UserFilterEnabled
           $failed = $true
        }
            
        if($failed -ne $true)
        {
            #Importing Icon
            $IconUid = New-BrokerIcon -EncodedIconData $app.EncodedIconData
            
            #Setting applications icon
            Set-BrokerApplication $app.PublishedName -IconUid $IconUid.Uid
            write-host -ForegroundColor Green "Working on Icon" $IconUid.Uid "for application:" $app.PublishedName
 
            # Adding Users and Groups to application associations
            If($app.AssociatedUserNames -ne $null)
            {
                Try
                {
                    $users = $app.AssociatedUserNames
 
                    foreach($user in $users)
                    {
                        write-host -ForegroundColor Yellow "Adding User or Group:" $user "for application:" $app.PublishedName
                        Add-BrokerUser -Name "$user" -Application $app.PublishedName
                    }
                }
                catch
                {
                    write-host  -ForegroundColor Red $_.Exception.Message
                    write-host  -ForegroundColor Red $_.Exception.ItemName
                    write-host  -ForegroundColor Red "Error on User  "  $user "for application:" $app.PublishedName
                }
            }
        }
}