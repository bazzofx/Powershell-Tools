<# Agenda
    Create Distribution Groups (DG), Security Groups, and Office 365 group
    Managing membership groups
    Modifying group attributes
    Assigning and managing group permissions (Send As, Send on Behalf)
#>

#Need to connect to MSOlModule

function connect {
 Connect-ExchangeOnline

}

#get Mailbox
Get-Mailbox

#Create Distribution group
New-DistributionGroup -Name "ManagersGroup" -PrimarySmtpAddress managersgroupd@fitzroy.org
#reject messages from particular user
Set-DistributionGroup -Name "ManagersGroup" -RejectMessagesFrom $userEmail
#get information about group
Get-DistributionGroup "ManagersGroup" | fl

#add Member
Add-DistributionGroupMember -Identity managersgroup@fitzroy.org -Member $userEmail
#Get all users members of a group
Get-DistributionGroup managersgroup@fitzroy.org

#Add Send as Permissions
Add-RecipientPermission -Identity managesgroup@fitzroy.org -Trustee $userEmail -AccessRights SendAs
#check who has permissions to send for an email
Get-RecipientPermission managersgroup@fitzroy.org

#Get All Active Transport Rules
function getAllActiveTransportRules {
Get-TransportRule | Where-Object{$_.State -eq "Enabled"}|?{$_.ExceptIfFrom -like "*@*"`
                                                       -or $_.FromMemberOf -like "*@*"`
                                                       -or $_.From -like "*@*" } | 
                                  FL Identity,From,FromMemberOf,ExceptIfFrom,ExceptIfFromMemberOf
                                  }

function get-MailBoxRules {
$MailboxName = Read-Host -Prompt 'Enter the mailbox name'

$Rules = Get-InboxRule -Mailbox $MailboxName


    If ($Rules) {
        Write-Host "The following rules are being applied to the mailbox $MailboxName"
        $Rules | ForEach-Object {Write-Host $_.Name}
    }
    Else {
        Write-Host "No rules are being applied to the mailbox $MailboxName"
}

}
