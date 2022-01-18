asnp citrix*

New-PSDrive -Name CitrixGPO -PSProvider CitrixGroupPolicy -Root \ -Controller localhost

cd .\User

New-Item SessionPrinterPolicy #Citrix policy name

set-itemproperty CitrixGPO:\User\SessionPrinterPolicy\Settings\ICA\Printing\SessionPrinters -name values "\\TA0SCM1APRNS001\udmrmctest","\\TA0SCM1APRNS001\rxudmrmc_satellite" #I used concatenate excel formula to set the whole list in one line of command, as this instruction removes any existing entry in the policy and sets only what you have typed here.
