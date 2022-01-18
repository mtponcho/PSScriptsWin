asnp citrix*

#send based on user name
#Get-BrokerSession -BrokeringUserName * | Send-BrokerSessionMessage -MessageStyle "Critical" -Title "Scheduled downtime" -Text "ATTENTION: Scheduled downtime will start today at 08:00 pm PT, please save your work and log off prior to this time." -ErrorAction SilentlyContinue
#send based on machinename
#Get-BrokerSession -MachineName "TA1ADCV1\TA0SCM1*" | Send-BrokerSessionMessage -MessageStyle "Critical" -Title "Scheduled downtime" -Text "ATTENTION: Scheduled downtime will start today at 08:00 pm PT, please save your work and log off prior to this time." -ErrorAction SilentlyContinue

Get-BrokerSession -MachineName "TA1ADCV1\TA0SCM1*" | Send-BrokerSessionMessage -MessageStyle "Critical" -Title "Scheduled downtime" -Text "ATTENTION: Scheduled downtime will start today at 08:00 pm PT, please save your work and log off prior to this time." -ErrorAction SilentlyContinue
sleep -Seconds 900
Get-BrokerSession -MachineName "TA1ADCV1\TA0SCM1*" | Send-BrokerSessionMessage -MessageStyle "Critical" -Title "Scheduled downtime" -Text "ATTENTION: Scheduled downtime will start today at 08:00 pm PT, please save your work and log off prior to this time." -ErrorAction SilentlyContinue
sleep -Seconds 600
Get-BrokerSession -MachineName "TA1ADCV1\TA0SCM1*" | Send-BrokerSessionMessage -MessageStyle "Critical" -Title "Scheduled downtime" -Text "ATTENTION: Scheduled downtime will start today at 08:00 pm PT, please save your work and log off prior to this time." -ErrorAction SilentlyContinue

#Get-BrokerSession -MachineName "TA1ADCV1\TA0SCM1*" | stop-brokersession