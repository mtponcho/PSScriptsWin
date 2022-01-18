﻿


#Get-BrokerController to list the information about all the Delivery Controllers in the site. Ensure that the status of all the Delivery Controllers is "Active".
#To check the service status of all the Citrix Services, run the following command:

Get-Command Get-*ServiceStatus | Get-Unique | Select Name

#Copy all the values in 'Name' and paste it in the next command line
#OUTPUT: Service status should come up as OK

Get-ConfigRegisteredServiceInstance | Measure 

#to measure the number of service instances registered for Delivery Controller. OUTPUT: Will give the consolidated number. (With every version we have few new services and instances which get added, i.e, with 7.6 we have 49 instances. If you have 2 controllers in the environment then the value will come up to be 49*2=98).
#For environment where we have separate databases for Logging and Monitor service, the following commands helps to check Database Connection strings . (In case you have a single database for Site, Monitoring and Logging, the database connection string value will be same. For environment with different databases, the database connection string value will be different for Logging and Monitor).

Get-LogDatastore
Get-MonitorDatastore

#To check presence of database connection string for all Citrix Services, run the following command:

Get-Command Get-*DBConnection | Get-Unique | Select Name

#Copy all the values in 'Name' and paste it in the next command line
#OUTPUT: Database Connection String
#Run the following command to verify the installed DB schema version for all the services. 

Get-Command Get-*InstalledDBVersion | Get-Unique | Select Name

#Copy all the values in 'Name' and paste it in the next command line
#OUTPUT: Database schema version
#To check the Database Connection strings in the registry, browse to the following location and check the value of the ConnectionString:
#HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\DesktopServer\DataStore\Connections\Controller

#This can as well be checked for all the services installed:

#Browse to the following location and verify the value for the Connection String:

#HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\<Servie Bane>\DataStore\Connections
#Run the following command to verify the Database connectivity for Citrix Services.

Get-Command Test-*DBConnection | Get-Unique | Select Name

#Copy all the values in 'Name' and paste it in the next command line along with -DBConnection <Connection String>
#OUTPUT: DB Connectivity status should come up as OK
#e.g. Test-BrokerDBConnection -DBConnection  "<DB Connection String>"