# DFSR (Microsoft Dynamic File System Replication)
## Description
This script allows zabbix to discover and monitor dfsr replication groups automatically. please read the installation instructions 
for futher information, there are a number of scripts and manual configuration settings that must be set for this to work

## Installation
                                                              
* create the directory c:\zabbix\dfsr
                                                             
* create the directory c:\zabbix\dfsr\powershell               

* copy the dfsr_discovery.ps1 file to the powershell directory 

* create a scheduled task to run every 6 hours with the command
  powershell -ExecutionPolicy Bypass -File "c:\zabbix\dfsr\powershell\dfsr_discovery.ps1"

* copy the backlog.ps1 file to the powershell directory

* import the template

* create a scheduled task to run whenever you want new datapoints with the command
  powershell.exe -ExecutionPolicy Bypass -File "C:\zabbix\dfsr\powershell\backlog.ps1"

* if the zabbix agent is running as a service, set it to login as an administrative user, otherwise the powershell
   scripts will not run correctly, and will always return 0


## Going Forward

This template is very much in the Alpha stages.. I'm not very farmiliar with powershell scripting,
the scripts could use alot of work. The directory handling is pretty rudementary but it works, and I'd like to see
zabbix be able to run the discovery itself in the future.



