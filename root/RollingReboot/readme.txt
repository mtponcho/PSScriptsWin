<#
 Script Purpose: Rolling Reboot
 Written by: Rajeshkanna Ganesan

 Below steps to configure the script in  taskscheduler for auto rolling reboot
 1) Copy the RollingReboot folder to the local "D drive"
 2) Fill the "ServerList.txt" with the list of servers
 3) Configure the script in task scheduler
    In Edit Action: 
      Program/script    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
      Add arguments (optional) ./RollingReboot.ps1
      Start in (optional) D:\RollingReboot
###############################################################
 Below are the Script Activity Explanation
 1) Test the server reachability.
 2) Take the server out of rotation, if the server is already out of rotation it will proceed with the step 3
 3) Logoff the users who are all idle for 10 minutes or greater, and you would find a "D:\RollingReboot\Logoff.log" 
    which record all the activity for future reference.
 4) If there were no users on the given server then it will reboot and the server name will get removed from the 
    "D:\RollingReboot\serverList.txt" file and the server name will be added to the D:\RollingReboot\ServersRestarted.log"
 5) After the "D:\RollingReboot\ServerList.txt" becomes empty the script will do no action. then you need to fill second set 
    of servers to perform rolling reboot.

Note: "D:\RollingReboot\Serversrestarted.log" contains the list of servers rebooted. 
      "D:\RollingReboot\ServerList.txt" contains the list of servers to do rollingreboot

#>