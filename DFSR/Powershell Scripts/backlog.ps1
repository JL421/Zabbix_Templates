<#
.SYNOPSIS
	Sends updated DFSR backlogs to Zabbix Server for processing

.NOTES
	File Name	: Backlog.ps1
	Author		: Jason Lorsung
	Last Update	: 2015-06-12
.Example
	backlog.ps1 -Zabbixserver "zabbixserver.example.com"
#>

$DFSRShares = Get-Content "C:\Zabbix\DFSR\discovery.conf"

Param([Parameter(Mandatory=$True)][string]$Zabbixserver)

$Hostname = hostname
$Hostname = $Hostname.ToUpper()

ForEach ($Share in $DFSRShares)
{
	$Share = Invoke-Expression $Share
	$RGName = $Share[0]
	$RFName = $Share[1]
	$SMem = $Share[2]
	$SMem = nslookup $Smem
	$SMem = $SMem[3].TrimStart("Name:").Trim()
	$RMem = $Share[3]
	$RMem = nslookup $RMem
	$RMem = $RMem[3].TrimStart("Name:").Trim()

	$BLCommand = "dfsrdiag Backlog /RGName:'" + $RGName + "' /RFName:'" + $RFName + "' /SendingMember:" + $SMem + " /ReceivingMember:" + $RMem
	$Backlog = Invoke-Expression -Command $BLCommand
	$BackLogFilecount = 0
	foreach ($item in $Backlog)
	{
		if ($item -ilike "*Backlog File count*")
		{
			$BacklogFileCount = [int]$Item.Split(":")[1].Trim()
		}
	}
	$ZabbixSend = "& 'C:\Program Files\Zabbix Agent\zabbix_sender.exe' -z " + $Zabbixserver + ' -s ' + $Hostname + ' -k dfsr-[' + $RFName + '-' + $Share[2] + '-' + $Share[3] + '] -o ' + $BacklogFileCount
	Invoke-Expression $ZabbixSend
}