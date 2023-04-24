#Connect MsOlservice
Connect-MsolService

#Get info about domain
get-msoldomain | fl

#get roles
get-msolrole
##assign role to user
Add-MsolRoleMember -RoleName "Global Reader" -RoleMemberEmailAddress "$userEmail"


#get all user accounts 
get-msoluser


#get company information
Get-MsolCompanyinformation
set-msolCompanyinformation -MarketingNotificationEmails "emails"

#get password policy
Get-MsolDomain
Get-MsolPasswordPolicy -DomainName starsintheskyhants.co.uk
Set-MsolPasswordPolicy -DomainName starsintheskyhants.co.uk -ValidityPeriod 180 -NotificationDays 10

#reset password / password nevere expires
Set-MsolUserPassword -UserPrincipalName $userEmail -NewPassword "newPassword123" -ForceChangePassword $true
Set-MsolUser -UserPrincipalName $userEmail -PasswordNeverExpires $true

#reset on 365
#does not work with hybrid environments (365 + AD)
$currentRowEmail = "homer.simpson@fitzroy.org"
$currentRowPassword = "OvelhaNegra22@"
Set-MsOlUserPassword -UserPrincipalName $currentRowEmail -NewPassword $currentRowPassword -ForceChangePassword $True


#Manage direct sync syncronisation onPrem and Azure AD
    #Checks if Directory Syncronization is enabled on the organisation
    (Get-MsolCompanyInformation).directorysynchronizationenabled
    #check what features are enabled or disabled on 365
    Get-MsolDirSyncfeatures

#check last time a user was sync with active directory
    $email = "paulo.bazzo@fitzroy.org"
    Get-MsolUser -UserPrincipalName $email| select-object userprincipalname, lastdirsynctime | Where-Object ($_.lastdirsynctime -gt "06/09/2022 13:39:55")
    Get-MsolUser -all | select-object userprincipalname, lastdirsynctime | Sort-Object lastsynctime


#Install AD Sync Module
Install-Module ADSync
Import-Module ADSync
#Force AD to Snnc
    Start-ADSyncSyncCycle -PolicyType Delta
