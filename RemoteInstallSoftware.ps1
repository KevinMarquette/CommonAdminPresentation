<#
Remote install software
#>

<#
Now that we can silently install a MSI, the next thing we 
try to do is install it on a remote system. That is the logical 
next step. To keep these samples cleaner, I am going to use 
a different imaginary installer. Using Enter-PSSession or 
Invoke-Command allows us to run commands on the remote system 
so that is what we will use.
#>
Invoke-Command -ComputerName server01 -ScriptBlock { 
	\\fileserver\share\installer.exe /silent 
}
<#
At first glance, this looks like it should work and it can be 
the source of a lot of headaches. Ideally you want to run the 
installer from the network, but you find that does not work. 
Then you try to work in a Copy-Item command in and get an 
access denied message. 

This is the double hop problem. The credential used to authenticate 
with server01 cannot be used by server01 to authenticate to fileserver. 
Or any other network resources for that matter. That second hop is 
anything that requires authentication that is not on the remote system. 
#> 

<#
We can either pre-copy the file or re-authenticate on the remote end. 
First a few common variables to reuse in the rest of the commands.
#>
$file = '\\fileserver\share\installer.exe'
$computerName = 'server01'

<#
The obvious first approach is to use the admin share of the remote system 
to push content to a location we can call later. Here I just place it 
in the windows temp folder then remotely execute it.
#>

# pre-copy file using admin share
Copy-Item -Path $file -Destination "\\$computername\c$\windows\temp\installer.exe"
Invoke-Command -ComputerName $computerName -ScriptBlock { 	
    c:\windows\temp\installer.exe /silent 
} 

<#
There is a new feature added in Powershell 5.0 that allows you to copy 
files over your PSSession. So create a PSSession and just copy the file 
over it using the syntax below. A cool thing about this approach is that 
with Powershell 5.0, you can create a PSSession to a guest VM over the 
VM buss (instead of over the network) and you can still copy a file to it. 
#>
# pre-copy using PSSession (PS 5.0)
$session = New-PSSession -ComputerName $computerName
Copy-Item -Path $file -ToSession $session -Destination 'c:\windows\temp\installer.exe' 

Invoke-Command -Session $session -ScriptBlock { 	
    c:\windows\temp\installer.exe /silent 
}
Remove-PSSession $session 

<#
It actually is really easy to re-authenticate if that 
is that is needed. Just create a credential object and 
pass it into your Invoke-Command. Then use that credential 
to create a New-PSDrive. Even if you don't use the 
new drive mapping, it will establish authentication. 
#>
$credential = Get-Credential
$psdrive = @{
    Name = "PSDrive" 
    PSProvider = "FileSystem" 
    Root = "\\fileserver\share" 
    Credential = $credential
}

Invoke-Command -ComputerName $computerName -ScriptBlock {
	New-PSDrive @using:psdrive
	\\fileserver\share\installer.exe /silent 
} 

# Don’t use CredSSP

<#
I can't talk about the double hop problem without mentioning 
CredSSP. The most common solution you will find online 
if you google the double hop problem is to enable CredSSP. 
The general community has moved away from that as a solution 
because it puts your environment at risk. The issue with 
CredSSP is that your admin credential gets cached on the 
remote system in a way that gives attackers easy access 
to it. But there is a better solution called Resource-Based 
Kerberos Constrained Delegation. 
#>

# Resource-Based Kerberos Constrained Delegation.
# PowerShell Remoting Kerberos Double Hop Solved Securely
# https://blogs.technet.microsoft.com/ashleymcglone/2016/08/30/powershell-remoting-kerberos-double-hop-solved-securely/

# For ServerC in Contoso domain and ServerB in other domain            
$ServerB = Get-ADComputer -Identity ServerB -Server dc1.alpineskihouse.com            
$ServerC = Get-ADComputer -Identity ServerC            
Set-ADComputer -Identity $ServerC -PrincipalsAllowedToDelegateToAccount $ServerB

#To undo the configuration, simply reset ServerC’s attribute to null.
Set-ADComputer -Identity $ServerC -PrincipalsAllowedToDelegateToAccount $null 

