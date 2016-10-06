# Eventlog 

Get-EventLog Application | Select-Object -First 4


# I'll talk about native filtering in a bit but you 
# will find this to be way slower than it should be.

Get-EventLog Application -Newest 4


# We do have a better command for pulling the 
# eventlog that supports processing of the advanced logs 

Get-WinEvent -LogName Application -MaxEvents 4
Get-WinEvent -LogName 'Microsoft-Windows-Dhcp-Client/Admin' -MaxEvents 4


# List all the available logs
Get-WinEvent -ListLog * | Out-GridView -PassThru


# Get-WinEvent can read binary logs
$path = 'C:\Windows\System32\winevt\Logs\system.evtx'
Get-WinEvent -Path $Path -MaxEvents 4 

