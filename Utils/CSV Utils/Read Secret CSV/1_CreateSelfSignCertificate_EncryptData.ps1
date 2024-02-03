#https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/protect-cmsmessage?view=powershell-7.4
$testPath = "C:\Users\Joker\Documents\PBDocs\Github\Powershell-Tools\Utils\CSV Utils\Read Secret CSV\"
$email = "paulo.bazzo@necsws.com"

function createInfFile{
# Create .INF file for certreq
{[Version]
Signature = "$Windows NT$"

[Strings]
szOID_ENHANCED_KEY_USAGE = "2.5.29.37"
szOID_DOCUMENT_ENCRYPTION = "1.3.6.1.4.1.311.80.1"

[NewRequest]
Subject = "CN=$email"
MachineKeySet = false
KeyLength = 2048
KeySpec = AT_KEYEXCHANGE
HashAlgorithm = Sha1
Exportable = false
RequestType = Cert
KeyUsage = "CERT_KEY_ENCIPHERMENT_KEY_USAGE | CERT_DATA_ENCIPHERMENT_KEY_USAGE"
#ValidityPeriod = "Years"
#ValidityPeriodUnits = "1000"
NotBefore = (Get-Date)
NotAfter = (Get-Date).AddYears(50)
FriendlyName = "Paulo Bazzo - Cyber Samurai"
[Extensions]
%szOID_ENHANCED_KEY_USAGE% = "{text}%szOID_DOCUMENT_ENCRYPTION%"
} | Out-File -FilePath DocumentEncryption.inf

    }
function createCertificate{
certreq.exe -new DocumentEncryption.inf DocumentEncryption.cer
}

#createInfFile
#createCertificate

function EncryptSecret{

# Data to be encrypted
#$data = "Sensitive information to be encrypted"
$data = Get-Content "$testPath\data.csv"
# Convert the data to bytes

#$dataBytes = [System.Text.Encoding]::UTF8.GetBytes($data)

#ecnrypt bytes with a certificate
$protectedData = Protect-CmsMessage -Content $data -To "*$email"

return $protectedData
}

EncryptSecret > "$testPath\encryptedData.dat"