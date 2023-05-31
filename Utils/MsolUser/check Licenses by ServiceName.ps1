Connect-MsolService
#Get-MsolUser -MaxResults 1  | Where-Object {$_.IsLicensed -eq "True"}


#user this function to check, change the name below
Get-MsolUser -MaxResults 5000  | 
Where-Object {$_.Office -eq "Laurel Cottage" -or $_.Office -eq "Littleover"} |
Select  UserPrincipalName, UsageLocation, IsLicensed, Office |
Sort-Object "UserPrincipalName"