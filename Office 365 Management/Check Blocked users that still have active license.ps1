$licensedUsers = Get-MSOLUser -All | Where {$_.blockCredential -eq $true} | Select DisplayName, UserPrincipalName,{$_.Licenses.AccountSkuId},blockCredential -ErrorAction SilentlyContinue

$disabledUsersWithLicenses = @(
    foreach($user in $licensedUsers)
    {
        if($user.blockCredential -eq $true)
        {
            $user
        }
    }
)