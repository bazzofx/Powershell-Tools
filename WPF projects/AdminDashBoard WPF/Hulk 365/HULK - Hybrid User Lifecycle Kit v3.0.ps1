﻿Add-Type -AssemblyName System.Windows.Forms

##################################################################
#--------------LOG VARIABLES START -------------------------------
$userProfile = $env:USERPROFILE
$ErrorActionPreference = "silentlycontinue"
$global:serverName = "AZDC01"
$license = "FitzRoy:STANDARDWOFFPACK"

$logPath = "C:\iMsScripts\HULK 365\reports\"
$logGoodFile = "SUCCESS $(get-date -f dd-MM-yyy).log"
$logBadFile = "EXCEPTIONS $(get-date -f dd-MM-yyy).log"
$logGood = $logPath + $logGoodFile
$logBad = $logPath + $logBadFile
$checkPathlogGood = Test-Path $logGood
$checkPathlogBad = Test-Path $logBad
$testFolderPath = Test-Path $logPath
Write-Host "All logs will be saved on $logPath" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "All logs will be saved on $logPath" -ForegroundColor Yellow -BackgroundColor Black
# -variables for logs ------------------------------------------------------------------------

Try{
New-Item -Path $logPath -ItemType Directory
Write-Host "All log files will be saved $logPath" -foreground Yellow}
Catch{Write-Host "All log files will be saved $logPath" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "" -ForegroundColor Yellow
Write-Host $logPath -ForegroundColor Yellow
}

if ($checkPathlogGood -eq $false -and $checkPathlogBad -eq $false){
$newFileGood = New-Item $logGood
$newFileBad = New-Item $logBad
}
Else{} 


#---------------------LOG VARIABLES END-------------------------------
######################################################################
#

#------------MINOR SUB FUNCTIONS-------------
#modified loadCSV to skip one <<removed>>
function loadCSV{
    Try{
 $global:users = Import-CSV $filePath -Header "UserPrincipalName", "Login", "Password","NewUserPrincipalName" |
                                                        Where-Object{$_.UserPrincipalName -ne "UserPrincipalName"}
 Write-Host "[SUCCESS] Data files loaded successfully" -ForegroundColor Green
  }
  Catch{Write-Host "[WARNING] Failed to import data" -ForegroundColor red }
                  } #-- close function
function Start-log{
Add-Content $logGood "------------>                Starting Log File on               $(Get-Date)"
Add-Content $logBad "------------>                Starting Log File on               $(Get-Date)"
} #-- close function
function checkConnection{
    Get-MsolDomain  -ErrorAction SilentlyContinue | Out-Null
    if($?){ #$? means asks a question to the program, did the last command was succesfull, it returns True or false.
    Write-Host "" -ForegroundColor Green} #if true means you are connected, do nothing, otherwise try to connect
    else{ Write-Host "You will need to login before you use this application" -ForegroundColor Yellow
          Startlogin}
if($env:COMPUTERNAME -eq "azdc01"){Write-Host "Connection TEST PASSED - You are operating from the AD Domain Controller" -ForegroundColor Green}
else{Write-Host "You will need to run this application from the AZDC01" -ForegroundColor Yellow
    loginAzureAD}

 
                        } #-- close function
function login365{
#Login to Office 365
Get-MsolDomain -ErrorAction SilentlyContinue 
    if($?){Write-Host "You are now connected to Microsoft Online 365" -ForegroundColor Green 
           $lbl_connected.Text="Connection to Office 365"
           $lbl_connected.ForeColor="green"
            }
    Else{

    Try{
    Connect-MsolService -ErrorAction SilentlyContinue
                Get-MsolDomain -ErrorAction SilentlyContinue 
    if($?){Write-Host "You are now connected to Microsoft Online 365" -ForegroundColor Green 
           $lbl_connected.Text="Connection to Office 365"
           $lbl_connected.ForeColor="green"}}
    Catch [System.Exception] {Write-Warning $Error[0]
                Add-Content $logBad $Error[0]
                Add-Content $logBad "Microsfot Online 365 was not able to connect"
                Add-Content $logBad "-------------------------------"}
    Catch {"Failed to connecte to server, please check if you are connected on the VPN"
                Add-Content $logBad "Failed to connecte to server, please check if you are connected on the VPN"
                Add-Content $logBad $Error[0]
                Add-Content $logBad "-------------------------------"
    }#close Catch
        }#close Else

} #-- close function
function loginAzureAD{
if($env:COMPUTERNAME -eq "azdc01"){
Write-Host "You are already connected to Azure AD AZDC01 Server." -ForegroundColor Green}
Else{$session = New-PSSession azdc01 -Credential (Get-Credential)
Enter-PSSession $session}
return
}
function changeUPN_AD {
$currentErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"

Add-Content $logGood "----------- Change UPN SUCCESS LOG START --------------"
Add-Content $logBad "----------- Change UPN EXCEPTION LOG START --------------" 

forEach ($user in $global:users)
        {
	    #Read user data from each field in each row and assign the data to a variable as below
	    $UserPrincipalName 	= $user.UserPrincipalName
	    $NewUserPrincipalName 	= $user.NewUserPrincipalName
        $userLogin = $user.Login
            $pieces = $userLogin.Split(".")
        $name = $pieces[0] + " " + $pieces[1]
        $surname = $pieces[1]
       
        

Try{           	
        Get-ADUser -Filter "userPrincipalName -eq '$UserPrincipalName'" -Properties *| 
        Set-ADUser -EmailAddress $NewUserPrincipalName -UserPrincipalName $NewUserPrincipalName -Surname $surname -SamAccountName $userLogin -DisplayName $name
Write-Host $name -ForegroundColor Yellow
Write-Host @"
[SUCCESS] Properties Updated
            Last Name: $surname
            Display Name: $name
            Email: $UserPrincipalName
            Login $userLogin
            User Principal Name: $UserPrincipalName
-   -   -   -   -   -   -   -   -   -   -   -   
"@ -ForegroundColor Green
    }#--close Try
Catch{Write-Host "[ERROR] Please run this application as an Administrator" -ForegroundColor Red}
        }
$ErrorActionPreference = $currentErrorActionPreference
} #-- subFunction close function changeUPNAD  # change properties on user on AZDC01
function changeUPN_365 {
Clear-Host
checkConnection
  
 
    foreach($row in $global:users){$i+=1}  #counts how many records exist on .csv file
    if($i -ge 1) { #to give errors in case user does not select .csv file

        $count =0
        ForEach ($row in $global:users)
            {
            $currentRowLogin = $row.Login
            $currentRowPassword = $row.Password
            $currentRowEmail = $row.UserPrincipalName
            $NewUserPrincipalName = $row.NewUserPrincipalName
            Try{
            
            Set-MsolUserPrincipalName -UserPrincipalName $UserPrincipalName -NewUserPrincipalName $NewUserPrincipalName
            Write-Host "$currentRowEmail has been updated to : $NewUserPrincipalName" -ForegroundColor Green

            }
            Catch {
                Write-Host "[FAIL] Change Email $currentRowEmail" -ForegroundColor Red
                Write-Host "[INFO] Please run this application as an Administrator - Check if email is spelled correctly." -ForegroundColor Yellow
                $badUsers += $currentRowEmail

                Add-Content $logBad "[FAIL] CHANGE EMAIL $currentRowEmail"        
                    }
            $count += 1
            } # -Close ForLoop
            Add-Content $logGood "-----------------------------------------------------------" 
            Add-Content $logBad "------------------------------------------------------------"
if($badUsers -eq "") {            
    Write-Host "          UPN has been successfully updated          " -ForegroundColor Black -BackgroundColor Green
    }
else{Write-Host "Change of Email completed successfully, but there are some exceptions!" -ForegroundColor Black -BackgroundColor Yellow
}       
        } #close if
    Else{Write-Host "[ERROR] Please select the .csv file to use." -ForegroundColor White -BackgroundColor Red}
 
} #-- subFunction close function changeUPN365

#------------RUN SUB FUNCTIONS-------------
Clear-Host
#---------------------------------------

function startLogin {
Start-Log
loginAzureAD
Start-sleep -Milliseconds 2000
#login365


} #-- close function 
function resetPass365{
Clear-Host
checkConnection
$currentErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Stop"
$badUsers = @()

        Add-Content $logGood "----------- RESET PASSWORD SUCCESS LOG START --------------"
        Add-Content $logGood ""
        Add-Content $logBad "----------- RESET PASSWORD EXCEPTION LOG START --------------"
        Add-Content $logBad "" 

    foreach($row in $global:users){$i+=1}  #counts how many records exist on .csv file
    if($i -ge 1) { #to give errors in case user does not select .csv file

            ForEach ($row in $global:users)
                {

                $currentRowLogin = $row.Login
                $currentRowPassword = $row.Password
                $currentRowEmail = $row.UserPrincipalName

                Try{
                     #reset on 365
                     Set-MsOlUserPassword -UserPrincipalName $currentRowEmail  -ForceChangePassword $True -NewPassword $currentRowPassword
                     #reset on AZDC01 Server
                     $accountName = get-aduser -Filter "UserPrincipalName -eq  '$currentRowEmail'"|
                     Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString $currentRowPassword -AsPlainText -Force)
                     Set-ADUser -Identity $currentRowLogin -ChangePasswordAtLogon $true
                     Write-Host "[SUCCESS] The password for $currentRowEmail has been reset on AZDC01 to ---> |  '$currentRowPassword'" -ForegroundColor Green
                     Write-Host "Changes may take up to 30mins to propagate..." -ForegroundColor Yellow
                     Write-Host "----------------------------------------------" -ForegroundColor Yellow
                     Add-Content $logGood "[SUCCESS] $currentRowEmail"
                 }
                 Catch{
                 $badUsers += $currentRowEmail
                 Write-Host "[ERROR] '$currentRowEmail' - Please check name." -ForegroundColor Red
                       Add-Content $logBad "[FAIL] $currentRowEmail"
                        }
     
                } # --close ForLoop
if($badUsers = ""){
Write-Host "          Passwords have been updated successfully!          " -ForegroundColor Black -BackgroundColor Green}
else{Write-Host "[INFO] - Reset password complete successfully, but there are some exceptions!" -BackgroundColor Yellow -ForegroundColor Black}
            }#close Try
    Else{Write-Host "[ERROR] Please select the .csv file to use." -ForegroundColor White -BackgroundColor Red}
        Add-Content $logGood "------------------------------------------------------------"
        Add-Content $logBad  "------------------------------------------------------------"
$ErrorActionPreference = $currentErrorAction
} #-- close function
function unlockAccount {
Clear-Host
checkConnection
$currentErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"


        Add-Content $logGood "----------- UNLOCKING ACCOUNT SUCCESS LOG START --------------"
        Add-Content $logGood ""
        Add-Content $logBad "----------- UNLOCKING ACCOUNT EXCEPTION LOG START --------------"
        Add-Content $logBad ""
   
 
    foreach($row in $global:users){$i+=1}  #counts how many records exist on .csv file
    if($i -ge 1) { #to give errors in case user does not select .csv file


        ForEach ($row in $global:users)
            {
            $currentRowLogin = $row.Login
            $currentRowPassword = $row.Password
            $currentRowEmail = $row.UserPrincipalName
            Try{
            Set-Msoluser -UserPrincipalName $currentRowEmail -BlockCredential $false
            Write-Host "[SUCCESS] - $currentRowEmail has been UNLOCKED" -ForegroundColor Green
            Write-Host ""
            Write-Host "---------------------------"

            Add-Content $logGood "[SUCCESS] - $currentRowEmail has been UNLOCKED"
            }
            Catch {Write-Host "[FAIL] - UNLOCK FAIL '$currentRowEmail'" -ForegroundColor Red
            Add-Content $logBad "[FAIL] - UNLOCK FAIL $currentRowEmail"        
            }


            } # -Close ForLoop
            Add-Content $logGood "--------------------------------------------------------------"
            Add-Content $logBad "--------------------------------------------------------------"

if($errorUsers -eq ""){
Write-Host "          Accounts have been UNLOCKED successfully!          " -ForegroundColor Black -BackgroundColor Green
}
else{Write-Host "[INFO] - UNLOCK ACCOUNT complete successfully, but there are some exceptions!" -BackgroundColor Yellow -ForegroundColor Black}
                  


        
        
        } #close if
    Else{Write-Host "[ERROR] Please select the .csv file to use." -ForegroundColor White -BackgroundColor Red}

$ErrorActionPreference = $currentErrorActionPreference
} #-- close function
function addLicense {
Clear-Host
checkConnection
        Add-Content $logGood "----------- ADDING LICENSES SUCCESS LOG START --------------"
        Add-Content $logGood ""
        Add-Content $logBad "----------- ADDING LICENSES EXCEPTION LOG START --------------"
        Add-Content $logBad ""

        foreach($row in $global:users){$i+=1}  #counts how many records exist on .csv file
        if($i -ge 1) { #to give errors in case user does not select .csv file
        ForEach ($row in $global:users)
            {
            $currentRowLogin = $row.Login
            $currentRowPassword = $row.Password
            $currentRowEmail = $row.UserPrincipalName
            $license = $global:license

            Try{
         Set-MSoluSer -UserPrincipalName $currentRowEmail -UsageLocation "GB"
         Set-MsolUserLicense -UserPrincipalName $currentRowEmail -AddLicenses $license 
         Write-Host "[SUCCESS] - License $license added to $currentRowEmail" -ForegroundColor Green
         Write-Host ""
         Write-Host "---------------------------"

         Add-Content $logGood "[SUCCESS] - License $license added to $currentRowEmail"
       }
        Catch [System.Exception] {Write-Host ""}
        Catch {Write-Host "[ERROR] - Something went when attemption to add '$license' license to $currentRowEmail" -ForegroundColor Red

        Add-Content $logBad "[ERROR] - Something went when attemption to add '$license' license to $currentRowEmail"
    }


        } #-close forLoop

            Add-Content $logGood "----------- ADDING LICENSES SUCCESS LOG END --------------"
            Add-Content $logGood ""
            Add-Content $logBad "----------- ADDING LICENSES EXCEPTION LOG END --------------"
            Add-Content $logBad ""      
            Write-Host "          License ES2 have been added successfully!          " -ForegroundColor Black -BackgroundColor Green
       
        }#close if
    Else{Write-Host "[ERROR] You need to load the .csv file first." -ForegroundColor White -BackgroundColor Red}
        } #-- close function
function changeUPN{
changeUPN_AD
#changeUPN_365
} # --close function


function generateCSV {
$userProfile = $env:USERPROFILE
$myDownload = "$userProfile\Downloads"
$csvExportPath = "$myDownload\IT-Data-Upload-Sample.csv"

$array =@()
        $row = New-Object Object
        $row | Add-Member -MemberType NoteProperty -Name "UserPrincipalName" -Value "Name.Surname@fitzroy.org"
        $row | Add-Member -MemberType NoteProperty -Name "Login" -Value "name.Surname"
        $row | Add-Member -MemberType NoteProperty -Name "Password" -Value "Cookies"
        $row | Add-Member -MemberType NoteProperty -Name "NewUserPrincipalName" -Value "newName.newSurname@fitzroy.org"
        $array += $row
Try{
        $array | Export-Csv -Path $csvExportPath -NoTypeInformation
        Write-Host "[SUCCESS] Sample .csv created successfully" -ForegroundColor Green
        Write-Host "Sample file is located on the followig path" -ForegroundColor Green
        Write-Host "The application needs at least 2 rows to work properly, so do not delete the first row on the file." -ForegroundColor Green
        Write-Host $csvExportPath -ForegroundColor Yellow}
Catch{Write-Host "[ERROR] It could not generate sample.csv file" -ForegroundColor Black -BackgroundColor Red
      Write-Host "[ERROR] Please create a .csv file manually with the following headers" -ForegroundColor Black -BackgroundColor Red
      Write-Host "----------------------------------------------------------------" -ForegroundColor Red
      Write-Host "| UserPrincipalName | Login | Password | NewUserPrincipalName |" -ForegroundColor Green
Write-Host      "name.surname@fitzroy.org | Name.Surname | xxx111lol | newName.newSurname@fitzroy.org |" -ForegroundColor Green
  }
        } # --close function
function lockAccount {
$currentErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Stop"
Clear-Host
checkConnection
Add-Content $logGood "----------- BLOCKING ACCOUNT SUCCESS LOG START --------------"
Add-Content $logGood ""
Add-Content $logBad "----------- BLOCKING ACCOUNT EXCEPTION LOG START --------------"
Add-Content $logBad ""
        foreach($row in $global:users){$i+=1}  #counts how many records exist on .csv file
        if($i -ge 1) { #to give errors in case user does not select .csv file
        ForEach ($row in $global:users)
            {
            $currentRowLogin = $row.Login
            $currentRowPassword = $row.Password
            $currentRowEmail = $row.UserPrincipalName
        
            Try{
            Set-Msoluser -UserPrincipalName $currentRowEmail -BlockCredential $true
            Write-Host "[SUCCESS] - $currentRowEmail has been BLOCKED" -ForegroundColor Green
            Write-Host ""

            Add-Content $logGood "[SUCCESS] - $currentRowEmail has been BLOCKED"
            }
            Catch {Write-Host "[FAIL] to block -  '$currentRowEmail'" -ForegroundColor Red
                  Add-Content $logBad "[FAIL] $currentRowEmail"
            $badUsers += $currentRowEmail
            }
            }#- Close ForLoop
            Add-Content $logGood "-------------------------------------------------------------"
            Add-Content $logBad "-------------------------------------------------------------"
 if($badUsers -eq ""){          
   Write-Host "          Accounts have been LOCKED successfully!          " -ForegroundColor Black -BackgroundColor Green
                }
else{Write-Host "[INFO] - Blocknig accounts complete successfully, but there are some exceptions!" -BackgroundColor Yellow -ForegroundColor Black}

        }
    Else{Write-Host "[ERROR] Please select the .csv file to use." -ForegroundColor white -BackgroundColor Red}
$ErrorActionPreference = $currentErrorAction
} #-- close function
function removeAllLicenses() {
$currentErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"
Clear-Host
checkConnection
        Add-Content $logGood "----------- REMOVAL ALL LICENSES SUCCESS LOG START --------------"
        Add-Content $logGood ""
        Add-Content $logBad "----------- REMOVAL ALL LICENSES EXCEPTION LOG START --------------"
        Add-Content $logBad ""    
        $errorUsers = @()
        
For($j=1;$j -le 2;$j++) #run the loop twice, running once was not working correctly.
{

    foreach($row in $global:users){$i+=1}  #counts how many records exist on .csv file
    if($i -ge 1) { #to give errors in case user does not select .csv file
        #Write-host "$currentRowEmail" -ForegroundColor Yellow

        ForEach ($row in $global:users)
            {
            $currentRowLogin = $row.Login
            $currentRowPassword = $row.Password
            $currentRowEmail = $row.UserPrincipalName
            $license = "FitzRoy:STANDARDWOFFPACK"
            Try{        
        (get-MsolUser -UserPrincipalName $currentRowEmail).licenses.AccountSkuId |
        foreach{Set-MsolUserLicense -UserPrincipalName $currentRowEmail -RemoveLicenses $_ -ErrorAction Stop
            if($j -eq 2){ 
            Write-Host "[SUCCESS] - The Licenses from $currentRowEmail has been removed." -ForegroundColor Green

            Add-Content $logGood "[SUCCESS] - The Licenses from $currentRowEmail has been removed."
                        }
            }
       }#-close Try
            Catch
            {
            if($j -eq 2){   
            $user = $currentRowEmail
                $errorUsers += $user
            Write-Host "[FAIL EXCEPTION]------------------------x" -ForegroundColor Red
            Add-Content $logBad "[ERROR] $currentRowEmail"
                        }
            }#close Catch

    } # -- close ForEach
        if($j -eq 2){ 
        Add-Content $logGood "-----------------------------------------------------------------"
        Add-Content $logGood ""
        Add-Content $logBad "Check if  UPN  is typed wrong or contain ending spaces or and remove them from your .csv file"
        Add-Content $logBad "-----------------------------------------------------------------"
        Add-Content $logBad "" 
           }
            
            }#close if
    Else{Write-Host "[ERROR] Please select the .csv file to use." -ForegroundColor white -BackgroundColor red
    }


}#cls For 
$ErrorActionPreference = $currentErrorActionPreference
if($errorUsers -eq ""){
Write-Host "          ALL Licenses have now been removed from the accounts!          " -ForegroundColor Black -BackgroundColor Green
}
else{Write-Host "[INFO] - Reset password complete successfully, but there are some exceptions!" -BackgroundColor Yellow -ForegroundColor Black}
      
        
        } #--close function
function checkInactiveWithLicense{Write-Host "[INFO] This function is currently turned off, due to the end of life module MSOlservice and Azure AD." -ForegroundColor Yellow}
function checkInactiveWithLicense_old {

Clear-Host
checkConnection

Try{
Write-Host "This might take a a few minutes... but no more than 5 minutes!!" -ForegroundColor Black -BackgroundColor Green
Get-MsolUser -all |
                Where-Object{$_.UserPrincipalName -like "*fitzroy*"`
                -or $_.UserPrincipalName -like "*love4life*"`
                -and $_.islicensed -eq "$true"`
                -and $_.blockcredential -eq "$true"} |`
                Select-Object UserPrincipalName, DisplayName, isLicensed, blockcredential
Write-Host "-------------------------------------------------------------------------"
Write-Host "                    ------- Search is now compelted -------           " -ForegroundColor Green
Write-Host "Users above are blocked but currently are holding at least one license"
}
Catch{Write-Host "[ERROR] Something went wrong trying to get Inactive users with licenses"}


} # --close function


###-  -  -  -  -  -  -  -  - ... ... \_(*.*)_/ FORM DESIGN STARTS HERE \_(*.*)_/ ... ... -  -  -  -  -  -  -  -  -  -###

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$FileDialogObject = [System.Windows.Forms.OpenFileDialog]
$ButtonObject = [System.Windows.Forms.Button]
$RadioObject = [System.Windows.Forms.RadioButton]
$greenButton = "#269524"
$green2Button ="#112811"
$redButton = "#D7411F"
$red2Button = "#2B100D"
$bgcolor = "#CFCFED"
$lighttext = "#E9DBB8"
$darktet = "#999999"
$titleFont = "Cambria,11,style=bold"
$radioFont = "Verdana,9"
$fontBasic = "Verdana,10,style=bold"
###MAIN WINDOW
$window = New-Object $FormObject
$window.MaximumSize="360,490"
$window.MinimumSize="360,490"
$window.ClientSize="350,450"
$window.Text="[H.U.L.K]"
$window.ForeColor = "darkblue"
$window.backcolor = $bgcolor
####$window.Add_FormClosing( { $_.Cancel = $true; } ) ###make user unable to close window

    #Define Main Title of Program
$lbl_title = New-Object $LabelObject
$lbl_title.text = "H.U.L.K Hybrid User Lifecycle Kit v3.0"
$lbl_title.Autosize = $true
$lbl_title.Font="Cambria,11,style=bold" ### --------------------------------------------font here
$lbl_title.ForeColor = $red2Button
$lbl_title.Location = New-Object system.drawing.point (12,5)

    #Define FilePath Label info
$lbl_filePath = New-Object $LabelObject
$lbl_filePath.text = "File not selected yet"
$lbl_filePath.AllowDrop = $true
$lbl_filePath.AutoEllipsis= $true
$lbl_filePath.AutoSize=$false
$lbl_filePath.BorderStyle="Fixed3D"
$lbl_filePath.width ="220"
$lbl_filePath.Height="20"
$lbl_filePath.Font="Verdana,8,style=bold"
$lbl_filePath.ForeColor=$red2Button
$lbl_filePath.Location = New-Object system.drawing.point (20,85)
    
    #Define label if connected or not
$lbl_connected = New-Object $LabelObject
$lbl_connected.text = "Not yet connected"
$lbl_connected.ForeColor="red"
$lbl_connected.Font="Verdana,9"
$lbl_connected.AutoSize=$true
$lbl_connected.Location = New-Object system.drawing.point (12,45)    
    #Define Search Button
$btn_Search = New-Object $ButtonObject
$btn_Search.text="Search..."
$btn_Search.ForeColor =$red2Button
$btn_Search.AutoSize=$true
$btn_Search.Location = New-Object System.Drawing.Point(250,80)

    #Define Onboarding Label
$lbl_Onboarding = New-Object $LabelObject
$lbl_Onboarding.text = "_____________Onboarding_____________"
$lbl_Onboarding.Autosize = $true
$lbl_Onboarding.ForeColor = "black"
$lbl_Onboarding.Font=$titleFont ### --------------------------------------------font here
$lbl_Onboarding.Location = New-Object system.drawing.point (20,120)

    #Define Radio options for Onboarding
$rdn_Button1 = New-Object $RadioObject
$rdn_Button1.Text ="Reset Password"
$rdn_Button1.Font=$radioFont
$rdn_Button1.Location= New-Object System.Drawing.Point(20,150)
$rdn_Button1.AutoSize=$true
$rdn_Button1.Parent="onboarding"

$rdn_Button2 = New-Object $RadioObject
$rdn_Button2.Text ="Unlock Account"
$rdn_Button2.Font=$radioFont
$rdn_Button2.Location= New-Object System.Drawing.Point(20,175)
$rdn_Button2.AutoSize=$true
$rdn_Button2.Parent="onboarding"

$rdn_Button3 = New-Object $RadioObject
$rdn_Button3.Text ="Add Ms E2 License"
$rdn_Button3.Font=$radioFont
$rdn_Button3.Location= New-Object System.Drawing.Point(20,200)
$rdn_Button3.AutoSize=$true
$rdn_Button3.Parent="onboarding"

$rdn_Button4 = New-Object $RadioObject
$rdn_Button4.Text ="Change UPN(mail)"
$rdn_Button4.Font=$radioFont
$rdn_Button4.Location= New-Object System.Drawing.Point(20,225)
$rdn_Button4.AutoSize=$true
$rdn_Button4.Parent="onboarding"
    
    #Define Onboarding Label
$lbl_Offboarding = New-Object $LabelObject
$lbl_Offboarding.text = "_____________Offboarding_____________"
$lbl_Offboarding.ForeColor = "black"
$lbl_Offboarding.Autosize = $true
$lbl_Offboarding.Font=$titleFont ### --------------------------------------------font here
$lbl_Offboarding.Location = New-Object system.drawing.point (20,255)

    #Define Radio options for Offboarding
$rdn_Button5 = New-Object $RadioObject
$rdn_Button5.Text ="Lock Account"
$rdn_Button5.Font=$radioFont
$rdn_Button5.Location= New-Object System.Drawing.Point(20,280)
$rdn_Button5.AutoSize=$true
$rdn_Button5.Parent="offboarding"

$rdn_Button6 = New-Object $RadioObject
$rdn_Button6.Text ="Remove All Licenses"
$rdn_Button6.Font=$radioFont
$rdn_Button6.Location= New-Object System.Drawing.Point(20,302)
$rdn_Button6.AutoSize=$true
$rdn_Button6.Parent="offboarding"

$btn_checkInactive = New-Object $ButtonObject
$btn_checkInactive.text="Check Inactive users w/ Licenses"
$btn_checkInactive.AutoSize=$true
$btn_checkInactive.Font="Arial,10,style=bold"
$btn_checkInactive.ForeColor= $green2Button
$btn_checkInactive.Location = New-Object System.Drawing.Point(25,330)

$btn_Login = New-Object $ButtonObject
$btn_Login.text="Login"
$btn_Login.AutoSize=$true
$btn_Login.Font="Arial,9,style=bold"
$btn_Login.ForeColor= $greenButton
$btn_Login.Location = New-Object System.Drawing.Point(250,40)

$btn_exec = New-Object $ButtonObject
$btn_exec.text="Execute"
$btn_exec.Font="Arial,13,style=bold"
$btn_exec.ForeColor= $greenButton
$btn_exec.AutoSize=$true
$btn_exec.Location = New-Object System.Drawing.Point(20,400)

$btn_csv = New-Object $ButtonObject
$btn_csv.text="Generate .csv"
$btn_csv.Font="Arial,10,style=bold"
$btn_csv.ForeColor= $greenButton
$btn_csv.AutoSize=$true
$btn_csv.Location = New-Object System.Drawing.Point(200,365)

$btn_cancel = New-Object $ButtonObject
$btn_cancel.text="Cancel"
$btn_cancel.Font="Arial,11,style=bold"
$btn_cancel.ForeColor= $redButton
$btn_cancel.AutoSize=$true
$btn_cancel.Location = New-Object System.Drawing.Point(250,400)
#Functions
function SearchDialog{
        $OpenFileDialog = New-Object $FileDialogObject
        $OpenFileDialog.InitialDirectory = $Path
        $OpenFileDialog.CheckPathExists = $true
        $OpenFileDialog.CheckFileExists = $true
        $OpenFileDialog.Title = "Please feed me"
        $OpenFileDialog.Filter = "csv files (*.csv)|*.csv" #|All files (*.*)|*.*"

        $OpenFileDialog.ShowDialog()

            if ($openFileDialog.CheckFileExists -eq $true) {
                $filePath = $openFileDialog.FileName
                $global:users = $filePath }
        $lbl_filePath.Text = $filePath
        $lbl_filePath.ForeColor="green"

loadCSV
}

###FUNCTIONS FOR FORM
function checkSelected {
if($rdn_Button1.Checked -eq $true) {resetPass365}
Elseif ($rdn_Button2.Checked  -eq $true ) {unlockAccount}
Elseif ($rdn_Button3.Checked  -eq $true ) {addLicense}
Elseif ($rdn_Button4.Checked  -eq $true ) {changeUPN}
Elseif ($rdn_Button5.Checked  -eq $true ) {lockAccount }
Elseif ($rdn_Button6.checked -eq $true)   {removeAllLicenses}
Else {Write-Host "[ERROR] You are not yet connected to your AZDC01. - Please select an option." -foreground Red} 
 }#close function

function checkConnected{
Write-Host "All log files will be saved $logPath" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------"
Try{
    ###Get-MsolDomain  -ErrorAction SilentlyContinue | Out-Null ## legacy check connectino to 365
    $serverNameConst = $env:COMPUTERNAME
        if($serverNameConst -eq $global:serverName){Write-Host "You are now connected to the AZDC01 Server" -ForegroundColor Green 
               $lbl_connected.Text="You are connected to AZDC01"
               $lbl_connected.ForeColor="green"
                }
        Else{Write-Host "You will first need to connect to the AZDC01 before using the software" -ForegroundColor Yellow}
    }#close Try
Catch{}
}#close function
checkConnected
function closeWindow{
    $window.Close()
}


##Add Functions to the Form
$btn_Search.Add_Click({SearchDialog})
$btn_Login.Add_Click({startLogin})
$btn_exec.Add_Click({checkSelected})
$btn_cancel.Add_Click({closeWindow})
$btn_csv.Add_Click({generateCSV})
$btn_checkInactive.Add_Click({checkInactiveWithLicense})

##Control add things to the window
$window.Controls.AddRange(@($lbl_title,$lbl_connected,$btn_Search,$lbl_filePath,$lbl_Onboarding,
$rdn_Button1,$rdn_Button2,$rdn_Button3,$rdn_Button4,$rdn_Button5,$rdn_Button6,$rdn_Button7
$lbl_Offboarding,$btn_Login,$btn_exec,$btn_csv,$btn_checkInactive,$btn_cancel))


#creates form
$window.ShowDialog()
#cleans up
$window.Dispose()

#checkConnected # check the connection when the programms open

###TO ADDD

##GENERATE .CSV FILE
$array = @()


##DISCOVER INACTIVE USRERS WITH LICENSES - would you like to remove licenses (yes|no)

##Update Email