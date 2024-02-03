
$ErrorActionPreference = "SilentlyContinue"
$data = Import-Csv "$testPath\encryptedData.dat"
$decrypted = Unprotect-CmsMessage -Content $data
$data = $decrypted | ConvertFrom-Csv


Write-Host "type hostnme"
$hostname = Read-Host "Hostname"

forEach($row in $data){
$name = $row.name
$age = $row.age
$skill = $row.skill
$color = $row.color

if($Name -like "*$hostname*"){
Clear-Host
sleep -Milliseconds 100
Write-Host "Records shows the below Server belongs to" -ForegroundColor Yellow -BackgroundColor Black;Write-Host ""
Write-Host "Hostname: $name ---> Color:$color" 
}

}

