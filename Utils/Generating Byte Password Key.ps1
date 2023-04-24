# Using AES Encryption to make a Secure String
#----------Creating the Encrypted Password File---------------------------------------

$PasswordFile = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\password"
$keyFile = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\key.key"

function Generate-RandomAESKey {
$file = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\key.key"
$Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $file
#-Keys can also be created manually

}

function Generate-Encrypted-Password{
 # Make your own key (16/24/32 bytes) {1byte = 1 character/number from 1 to 256}
$PasswordFile = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\password"
$keyFile = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\key.key"
$Key = Get-Content $KeyFile
$Password = "type password here" | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile}


function Generate-PSCredential {
$User = "type email here"
$PasswordFile = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\password"
$keyFile = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\PowerShell\Check Reporting Managers SFTP\key.key"
$key = Get-Content $KeyFile
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
}