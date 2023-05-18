## Disable annoying CEIP announcement:
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

## Set script directory:
$SCRIPT_DIR = "C:\scripts\storcli_script"

## Go to script directory:
Set-Location $SCRIPT_DIR

## ESXi host:
$ESXi_HOST="your_ESXi_host_ip_address"

## Load ESXi host credentials from encrypted file: 
$credential = Import-Clixml -Path encrypted_password.cred

## Connect to ESXi host:
Connect-VIServer -Server ${ESXi_HOST}  -Credential $credential

## Enable SSH on remote ESXi host:
Get-VMHost ${ESXi_HOST} | Get-VMHostService | Where Key -EQ "TSM-SSH" | Start-VMHostService

## Gather RAID status log with strocli on remote ESXi host:
ssh root@${ESXi_HOST} "/opt/lsi/storcli/storcli  show all  > /tmp/storcli.out"

## Copy RAID status log from ESXi host to local machine:
scp root@${ESXi_HOST}:/tmp/storcli.out $SCRIPT_DIR

## Send RAID status log content to Telegram:
Function Send-Telegram {
Param([Parameter(Mandatory=$true)][String]$Message)
$Telegramtoken = "your_Telegram_Bot_token"
$Telegramchatid = "your_Telegram_Chat_ID"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)"}

Send-Telegram -Message "$(get-content storcli.out)"

## Disable SSH on remote ESXi host:
Get-VMHost ${ESXi_HOST} | Get-VMHostService | Where Key -EQ "TSM-SSH" |  Stop-VMHostService -Confirm:$False
