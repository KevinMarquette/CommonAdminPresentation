<#
Powershell Remoting
#>

Enable-PSRemoting

# Non-Domain joined machines may fail if the network type is public
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-NetConnectionProfile -NetworkCategory Private

# Connecting cross domain or to workgroup machines requires you to
# add that system to the trusted hosts (on the client machine)
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "Server1,Server2"
Set-Item wsman:\localhost\Client\TrustedHosts -Value "*.contoso.com,10.*"
Set-Item wsman:\localhost\Client\TrustedHosts -Value '*'

Get-ChildItem wsman:\localhost\Client\TrustedHosts


# Test-WSMan for diagnotic testing

Test-WSMan localhost


# WinRM 2.0:  The default HTTP port is 5985, and the default HTTPS port is 5986.
# https://msdn.microsoft.com/en-us/library/aa384372%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396
Get-Service winrm


# new remote session

Enter-PSSession -ComputerName localhost

Enter-PSSession -ComputerName localhost -Credential (Get-Credential)


#Invoke just a command on computer(s)
Invoke-Command -ComputerName localhost -ScriptBlock {hostname}
Invoke-Command -ComputerName localhost,localhost -ScriptBlock {hostname}

'localhost','localhost'  | %{Invoke-Command -computername $_ -ScriptBlock {hostname} }