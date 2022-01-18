
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\Batch\BrokerAgentReboot\RebootCycleLog.txt -append

asnp citrix*


#$serviceVDA = "BrokerAgent"



Get-Content C:\Batch\BrokerAgentReboot\VDAservers.txt | ForEach-Object{
$VDA = $_
$VDA = $VDA.Replace(" ","")
if ($VDA -like "*\*"){
#$VDA
Echo ""
Echo "Restarting service on:" , $VDA.Substring(9)

$regstate = ""

Get-Service -ComputerName $VDA.Substring(9) -Name *BrokerAgent* | Stop-Service
Get-Service -ComputerName $VDA.Substring(9) -Name *BrokerAgent* | Start-Service

$regstate = (Get-BrokerMachine -MachineName $VDA).RegistrationState



while ($true){
    if ($regstate -eq "Registered"){
        echo ""
        echo $vda "is now registered, moving to next server in the list"
        $regstate = ""
        Break
        }
         else{
        Start-Sleep 10
        echo ""
        $regstate = (Get-BrokerMachine -MachineName $VDA).RegistrationState
        echo $vda $regstate "This server is not registered, please wait..."
                
        }
    }


}

}
echo "End of cycle"


Stop-Transcript