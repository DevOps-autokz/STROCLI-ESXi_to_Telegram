# STROCLI-ESXi_to_Telegram
Powershell script to get storcli (RAID status check) results and send it to Telegram

**storcli** is the controller utility for LSI based HBA and RAID controllers.
Read more about it at VMware documentation site: https://kb.vmware.com/s/article/2148867

**Script's prerequisites:**

SSH should be installed: 
https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/ssh-remoting-in-powershell-core?view=powershell-7.3

SSH-keys should be generated:
https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement
This script searches for the SSH private key by the default name and in the default location.

SSH-key-based authentication to ESXi should be setup:
https://kb.vmware.com/s/article/1002866
https://kb.vmware.com/s/article/1019852

Create 'encrypted_password.cred' that stores your ESXi credentials:
In PowerShell terminal enter: 
$credential = Get-Credential
$credential | Export-Clixml -Path encrypted_password.cred

## Generate ssh-keys to ESXi host. 
