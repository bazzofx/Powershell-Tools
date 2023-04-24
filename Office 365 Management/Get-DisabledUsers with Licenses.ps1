$userProfile = $env:USERPROFILE
$log ="$userProfile\Downloads\CleanUP.log"
$ErrorActionPreference ="Stop"

function CheckLicenses{
Get-MsolAccountSku
} # Checks all your licenses names and quantities
function check {

 $x = Get-MsolUser -All | where {$_.isLicensed -eq $true -and $_.BlockCredential -eq $true -and $_.license -ne "FitzRoy:STANDARDWOFFPACK"} |
  Select FirstName, LastName,UserPrincipalName,IsLicensed, Licenses 
  return $x
} # Get Users who are disbaled but still have licenses attached to them, place them on an array.
function calculate {
$data = check
ForEach($row in $data){

Try{
    $upn = $row.UserPrincipalName
    Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $_
    Write-Host "All Licenses removed from $upn" -ForegroundColor Green
    Add-Content $log "[SUCCESS ]  -  All Licenses removed from $upn"

    }
Catch{
    Write-Warning "Could not remove license, check if this is linked to an Inherited license assigment - to remove the license you must first remove them from their group" 
    Add-Content $logExceptions "[ERROR]  -  There was an error removing the licenses for $upn"
}

} # Remove all licenses from users found on array
} # Remove all licenses from users inside array




function Start-Script{
check
calculate
}
Write-Host "SCRIPT STARTED" -ForegroundColor Black -BackgroundColor Green
Add-Content $log "Starting Log"
Add-Content $log "------------------------------------"

Start-Script

Write-Host "SCRIPT STOPPED" -ForegroundColor Black -BackgroundColor Green
Add-Content $log "#### END of Log ########"