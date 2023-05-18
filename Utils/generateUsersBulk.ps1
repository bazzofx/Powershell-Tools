$wd = "C:\iMsScripts\functions\Create Users Bulk\"
$path = "C:\iMsScripts\functions\Create Users Bulk\data.csv"
$data = import-csv $path
$ou = "OU=Littleover - Staff,OU=East Midlands Support Workers,OU=East Midlands,OU=Offices,DC=efitzroy,DC=org,DC=uk"
$manager = "Paulo.Bazzo"


forEach($x in $data) {
$serviceName = "Littleover"
$username = $x.login
$email ="$username@fitzroy.org"
$jobTitle = $x."Job Title"
$pass = $x.Password
$password = ConvertTo-SecureString -String $pass -AsPlainText -Force
$displayName = $username.replace("."," ")
$parts = $username.split(".")
$name = $parts[0]
$surname= $parts[1]

    $params = @{
        SamAccountName = $Username
        UserPrincipalName = $email
        Name = $displayName 
        GivenName = $name 
        Surname = $surname
        DisplayName = $displayName
        AccountPassword = $password
        Enabled = $true
        EmailAddress = $email
        Office = $serviceName
        Title = $jobTitle
        Description = $jobTitle
        Department = $serviceName
        Company = "FitzRoy"
        Manager = $manager
        Path = $ou

    } # -----------------set parameters for each ROW

New-ADUser @params
Write-Host "[SUCCESS] $email created ----> Password $pass" -ForegroundColor Green

}
