$excludedAccounts = "SYSTEM","NETWORK SERVICE","LOCAL SERVICE"
$minlength=1000 # Minimum length of command line to alert
$wd = $PSScriptRoot
$tempSafeListPath = "$wd\safelist.txt"
$safelist = Get-Content $tempSafeListPath | Select-String '^[^#]' | ConvertFrom-Csv
$excludedCommandList = @() #array inside Check-Command, keep track of excluded commands
$failedlogons=@{}
$failedLogonCount = @()
$totalsensprivuse=0 # start value -link to event 4673
$maxtotalsensprivuse=4 # max value -link to event 4673 n of max priv admin actions before its flagged
    # Password spray variables:
    $passspraytrack = @{}
    $passsprayuniqusermax = 6
    $passsprayloginmax = 6
    $passsprayuniqaccounts = 0
#------------------------------------    GLOBAL VARIABLES ---------------------------------------------
#---------------------              MySubFunctions
function extractTitle {
    param (
        [string]$inputString
    )

    $pattern = "^(.*?)[\.,]" # ^ = match start beggining of sentence, any character  up to [. or ,]

    $matches = [regex]::Matches($inputString, $pattern)

    if ($matches.Count -gt 0) {
        $result = @()
        foreach ($match in $matches) {
            $result += $match.Groups[1].Value
        }
        return $result
    } else {
        return $null
    }
} # subfunction to extract first Line of Message up until the "," or "."
#-------------                    DeepBlue SubFunctions
function Check-Creator($command,$creator){
    $creatortext=""  # Local variable for return output
    if ($creator){
        if ($command -Match "powershell"){
            if ($creator -Match "PSEXESVC"){
                $creatortext += "PowerShell launched via PsExec: $creator`n"
            }
            ElseIf($creator -Match "WmiPrvSE"){
                $creatortext += "PowerShell launched via WMI: $creator`n"
            }
        }
        ElseIf ($command -Match "cmd.exe"){
            if ($creator -Match "PSEXESVC"){
                $creatortext += "cmd.exe launched via PsExec: $creator`n"
            }
            ElseIf($creator -Match "WmiPrvSE"){
                $creatortext += "cmd.exe launched via WMI: $creator`n"
            }
        }
    }
    return $creatortext
}
function Check-Obfu($string){
    # Check for special characters in the command. Inspired by Invoke-Obfuscation: https://twitter.com/danielhbohannon/status/778268820242825216
    #
    $obfutext=""       # Local variable for return output
    $lowercasestring=$string.ToLower()

    $length=$lowercasestring.length
    $noalphastring = $lowercasestring -replace "[a-z0-9/\;:|.]"
    $nobinarystring = $lowercasestring -replace "[01]" # To catch binary encoding
    # Calculate the percent alphanumeric/common symbols
    if ($length -gt 0){
        $percent=(($length-$noalphastring.length)/$length)
        # Adjust minpercent for very short commands, to avoid triggering short warnings
        if (($length/100) -lt $minpercent){ 
            $minpercent=($length/100) 
        }
        if ($percent -lt $minpercent){
            $percent = "{0:P0}" -f $percent      # Convert to a percent
            $obfutext += "Possible command obfuscation: only $percent alphanumeric and common symbols`n"
        }
        # Calculate the percent of binary characters  
        $percent=(($nobinarystring.length-$length/$length)/$length)
        $binarypercent = 1-$percent
        if ($binarypercent -gt $maxbinary){
            #$binarypercent = 1-$percent
            $binarypercent = "{0:P0}" -f $binarypercent      # Convert to a percent
            $obfutext += "Possible command obfuscation: $binarypercent zeroes and ones (possible numeric or binary encoding)`n"
        }
    }
    return $obfutext
}
function Check-Regex($string,$type){
    $regextext="" # Local variable for return output
    foreach ($regex in $regexes){
        if ($regex.Type -eq $type) { # Type is 0 for Commands, 1 for services. Set in regexes.csv
            if ($string -Match $regex.regex) {
               $regextext += $regex.String + "`n"
            }
        }
    }
    #if ($regextext){ 
    #   $regextext = $regextext.Substring(0,$regextext.Length-1) # Remove final newline.
    #}
    return $regextext
}
function Remove-Spaces($string){
    # Changes this:   Application       : C:\Program Files (x86)\Internet Explorer\iexplore.exe
    #      to this: Application: C:\Program Files (x86)\Internet Explorer\iexplore.exe
    $string = $string.trim() -Replace "\s+:",":"
    return $string
}
function Check-Command(){
    
    Param($EventID)

    $text=""
    $base64=""
    # Check to see if command is safelisted
    foreach ($entry in $safelist) {
    
        if ($commandline -Match $entry.regex) {
            # Command is safelisted, return nothing
    #$matchRegex = $entry.regex  #debug
    #Write-Host "$commandline [matching regex safelist] $matchRegex" -ForegroundColor Yellow #debug
            $excludedCommandList += $commandline
            #Write-Host $commandline -ForegroundColor Red ;sleep 1
            return
        }
    }
    if ($commandline.length -gt $minlength){
        $text += "Long Command Line: greater than $minlength bytes`n"
    }
   
if($v){
      #This will be triggered if switch 'more' is active     
      $array = $event.message -split '\n' # Split each line of the message into an array
      $sid = Remove-Spaces ($array[5])
      $username = Remove-Spaces ($array[3])
      $domain = Remove-Spaces ($array[4])


      $obj.Results = "$username`n"
      $obj.Results += "$domain`n"
      $obj.Results += "Machine Name: $machinename`n"
      $obj.Results += "$sid`n"
}


    $text += (Check-Obfu $commandline)
    $text += (Check-Regex $commandline 0)
    $text += (Check-Creator $commandline $creator)
    # Check for base64 encoded function, decode and print if found
    # This section is highly use case specific, other methods of base64 encoding and/or compressing may evade these checks
    if ($commandline -Match "\-enc.*[A-Za-z0-9/+=]{100}"){
        $base64= $commandline -Replace "^.* \-Enc(odedCommand)? ",""
    }
    ElseIf ($commandline -Match "\-En.*[A-Za-z0-9/+=]{100}"){
            $base64= $commandline -Replace "^.* \-En",""
    }
    ElseIf ($commandline -Match ":FromBase64String\("){
        $base64 = $commandline -Replace "^.*:FromBase64String\(\'*",""
        $base64 = $base64 -Replace "\'.*$",""
    }
    if ($base64){
        if ($commandline -Match "Compression.GzipStream.*Decompress"){
            # Metasploit-style compressed and base64-encoded function. Uncompress it.
            $decoded=New-Object IO.MemoryStream(,[Convert]::FromBase64String($base64))
            $uncompressed=(New-Object IO.StreamReader(((New-Object IO.Compression.GzipStream($decoded,[IO.Compression.CompressionMode]::Decompress))),[Text.Encoding]::ASCII)).ReadToEnd()
            $obj.Decoded=$uncompressed
            $text += "Base64-encoded and compressed function`n"
        }
        else{
            $decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($base64))
            $obj.Decoded=$decoded
            $text += "Base64-encoded function`n"
            $text += (Check-Obfu $decoded)
            $text += (Check-Regex $decoded 0)
        }
    }
    if ($text){
        if ($servicecmd){
            $obj.Message = "Suspicious Service Command"
            $obj.Results = "Service name: $servicename`n"
        }

    if($event.id -eq 5158){$event| Select-Object *
          #  $Date    = $event.TimeCreated
          #  Log     = $logname
          #  EventID = $event.id
          #  Message = ""
          #  Results = " 
        
    
    
    }

        Else{
            Try{$obj.Message = "Suspicious Command Line"}Catch{}
        }
        Try{$obj.Command = $commandline}Catch{}
        Try{$obj.Results += $text}Catch{}
        Try{$obj.EventID = $EventID}Catch{}
        Write-Output $obj
        writeHostSeparator #creates a dash after record "---"

    }
    return
}
function writeHostSeparator{
Write-Host " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " -ForegroundColor Gray

}
#-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - 
# ------------------------------- LOAD Events ----------------------------------------

<#
 _______  ___   ___      _______  _______  ______   
|       ||   | |   |    |       ||       ||    _ |  
|    ___||   | |   |    |_     _||    ___||   | ||  
|   |___ |   | |   |      |   |  |   |___ |   |_||_ 
|    ___||   | |   |___   |   |  |    ___||    __  |
|   |    |   | |       |  |   |  |   |___ |   |  | |
|___|    |___| |_______|  |___|  |_______||___|  |_|
#>
##----------Create more switches as you need under this function.
function Create-FilterEvents ($file, $logname){
    # Return the Get-WinEvent filter
    $sys_events = "7030,7036,7045,7040,104"
    $sec_events = "4688,4672,4720,4728,4732,4756,4625,4673,4674,4648,1102"
    $app_events = "50"
    $applocker_events = "8003,8004,8006,8007"
    $powershell_events = "4688"
    $sysmon_events = "1,7,8"
    $wmi_events = "5861"
    $debug_events = "4648"
    
    $filter = @{
        Path = $file
        ID = @()
    }

    switch ($logname) {

        "all" {
            $filter.ID = $all_events -split ","
        }    
        "Debug" {
            $filter.ID = $debug_events -split ","
        }
        "security" {
            $filter.ID = $sec_events -split ","
        }
        "system" {
            $filter.ID = $sys_events -split ","
        }
        "application" {
            $filter.ID = $app_events -split ","
        }
        "applocker" {
            $filter.LogName = "Microsoft-Windows-AppLocker/EXE and DLL"
            $filter.ID = $applocker_events -split ","
        }
        "Powershell" {
            $filter.LogName = "Microsoft-Windows-PowerShell/Operational"
            $filter.ID = $powershell_events -split ","
        }
        "sysmon" {
            $filter.ID = $sysmon_events -split ","
        }
        "WMI-Activity" {
            $filter.LogName = "Microsoft-Windows-WMI-Activity/Operational"
            $filter.ID = $wmi_events -split ","
        }
        default {
            Write-Host "Invalid logname: $logname"
            Exit 1
        }
    }


    return $filter
}
function Load-FilterEvents ($file, $logname) {
    $filter = Create-FilterEvents -file $file -logname $logname

$events = Get-WinEvent -FilterHashtable $filter -ErrorAction SilentlyContinue
if ($null -eq $events) {
    Write-Host "No events found." -ForegroundColor Yellow
} else {
    $events
}


    return $events
    }
# --------------------------------------------------------


function main {

param(
    [string]$file,
    [string]$logname,
    [switch]$v
)
$events = Load-FilterEvents -file $file -logname $logname

forEach ($event in $events){
$eventXML = [xml]$event.ToXml()

       $trackEventList += $trackString
       #Write-Host $trackEventList -ForegroundColor Yellow ;sleep 2


#SYSMON
            if ($event.id -eq 1){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }

                if ($eventXML.Event.EventData.Data.Count -le 16){
                    $creator=$eventXML.Event.EventData.Data[14]."#text"
                    $commandline=$eventXML.Event.EventData.Data[10]."#text"
                }
                Else {
				    $creator=$eventXML.Event.EventData.Data[20]."#text"
				    $commandline=$eventXML.Event.EventData.Data[10]."#text"
				}
                if ($commandline){
                    Check-Command -EventID 1
                }
            }
            ElseIf ($event.id -eq 7){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }


                # Check for unsigned EXEs/DLLs:
                # This can be very chatty, so it's disabled. 
                # Set $checkunsigned to 1 (global variable section) to enable:
                if ($checkunsigned){
                    if ($event.Properties.Count -lt 14){
                    	if ($eventXML.Event.EventData.Data[6]."#text" -eq "false"){
                        	$obj.Message="Unsigned Image (DLL)"
                        	$image=$eventXML.Event.EventData.Data[3]."#text"
                        	$imageload=$eventXML.Event.EventData.Data[4]."#text"
                        	# $hash=$eventXML.Event.EventData.Data[5]."#text"
                        	$obj.Command=$imageload
                        	$obj.Results=  "Loaded by: $image"
                        	Write-Output $obj
                     	}
			        }
			        Else{   
				        if ($eventXML.Event.EventData.Data[11]."#text" -eq "false"){
                        	$obj.Message="Unsigned Image (DLL)"
                        	$image=$eventXML.Event.EventData.Data[4]."#text"
                        	$imageload=$eventXML.Event.EventData.Data[5]."#text"
                        	# $hash=$eventXML.Event.EventData.Data[10]."#text"
                        	$obj.Command=$imageload
                        	$obj.Results=  "Loaded by: $image"
                        	Write-Output $obj
                     	}		 
                    }
                 }
             }
            ElseIf ($event.id -eq 8){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                #Check remote thread (lsass activity, process migration, etc)
                $image=$eventXML.Event.EventData.Data[7]."#text"
                $user=$eventXML.Event.EventData.Data[12]."#text"
                $sourceimage=$eventXML.Event.EventData.Data[4]."#text"
                If ($image -Match "lsass.exe"){
                  $creatortext += "Remote thread to $image`n"
                  $obj.Message="Suspicious remote thread"
                  $imageload=$eventXML.Event.EventData.Data[7]."#text"
                  $obj.Command=$imageload
                  $obj.Results=  "Remote thread created to: $image from: $sourceimage by $user"
                  Write-Output $obj
                }
                ElseIf ($user -notmatch "SYSTEM"){
                  $creatortext += "Remote thread to $image`n"
                  $obj.Message="Suspicious remote thread"
                  $imageload=$eventXML.Event.EventData.Data[7]."#text"
                  $obj.Command=$imageload
                  $obj.Results=  "Remote thread created to: $image from: $sourceimage by $user"
                  Write-Output $obj
                }
            }
 
#-------------------Sysmon events end
#SYSTEM
            ElseIf ($event.id -eq 7030){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # The ... service is marked as an interactive service.  However, the system is configured 
                # to not allow interactive services.  This service may not function properly.
                $servicename=$eventXML.Event.EventData.Data."#text"
                $obj.Message = "Interactive service warning"
                $obj.Results = "Service name: $servicename`n"
                $obj.Results += "Malware (and some third party software) trigger this warning"
                # Check for suspicious service name
                $servicecmd=1 # CLIs via service creation get extra check
                $obj.Results += (Check-Regex $servicename 1)
                Write-Output $obj
            }
            ElseIf ($event.id -eq 7036){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # The ... service entered the stopped|running state.
                $servicename=$eventXML.Event.EventData.Data[0]."#text"
                $text = (Check-Regex $servicename 1)
                if ($text){
                    $obj.Message = "Suspicious Service Name"
                    $obj.Results = "Service name: $servicename`n"
                    $obj.Results += $text
                    Write-Output $obj
                }
            }
            ElseIf ($event.id -eq 7040){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # The start type of the Windows Event Log service was changed from auto start to disabled.
                $servicename=$eventXML.Event.EventData.Data[0]."#text"
                $action = $eventXML.Event.EventData.Data[2]."#text"
                if ($servicename -ccontains "Windows Event Log") {
                    $obj.Results = "Service name: $servicename`n"
                    $obj.Results += $text
                    if ($action -eq "disabled") {
                        $obj.Message = "Event Log Service Stopped"
                        $obj.Results += "Selective event log manipulation may follow this event."
                    } elseIf ($action -eq "auto start") {
                        $obj.Message = "Event Log Service Started"
                        $obj.Results += "Selective event log manipulation may precede this event."
                    }
                    Write-Output $obj
                }
            }
            ElseIf ($event.id -eq 104){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # The System log file was cleared.
                $obj.Message = "System Log Clear"
                $obj.Results = $event.message
                Write-Output $obj
            }
#-------------------System events end
#Application


Elseif ($event.id -eq 50) {
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # EMET Block
                $obj.Message="EMET Block"
                if ($event.Message){ 
                    # EMET Message is a blob of text that looks like this:
                    #########################################################
                    # EMET detected HeapSpray mitigation and will close the application: iexplore.exe
                    #
                    # HeapSpray check failed:
                    #   Application   : C:\Program Files (x86)\Internet Explorer\iexplore.exe
                    #   User Name     : WIN-CV6AHH1BNU9\Instructor
                    #   Session ID    : 1
                    #   PID           : 0xBA8 (2984)
                    #   TID           : 0x9E8 (2536)
                    #   Module        : mshtml.dll
                    #  Address       : 0x6FBA7512, pull out relevant parts
                    $array = $event.message -split '\n' # Split each line of the message into an array
                    $text = $array[0]
                    $application = Remove-Spaces($array[3])
                    $command= $application -Replace "^Application: ",""
                    $username = Remove-Spaces($array[4])
                    $obj.Message="EMET Block"
                    $obj.Command = "$command"
                    $obj.Results = "$text`n"
                    $obj.Results += "$username`n" 
                }
                Else{
                    # If the message is blank: EMET is not installed locally.
                    # This occurs when parsing remote event logs sent from systems with EMET installed
                    $obj.Message="Warning: EMET Message field is blank. Install EMET locally to see full details of this alert"
                }
                Write-Output $obj
            }
#-------------------application events end
#Security           
    ElseIf($event.Id -eq 4672){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }

                $username=$eventXML.Event.EventData.Data[1]."#text"
                $domain=$eventXML.Event.EventData.Data[2]."#text"
                $securityid=$eventXML.Event.EventData.Data[3]."#text"
                $privileges=$eventXML.Event.EventData.Data[4]."#text"

  if($username -in $excludedAccounts){#Write-Host "logon with a build in Service account $username " -ForegroundColor Yellow;continue
     }#-check if logon was made using buildin account, can add more if needed.
  Else{
  if ($privileges -match "SeTcbPrivilege" -or $privileges -match "SeTakeOwnershipPrivilege" ){$privileges = "Admin Priviledge account logon detected (admin access)"}
     Else{}      
            $obj.Message = $privileges  
            $obj.Results = "Username: $username`n"
            if($v) {
            $obj.Results += "Domain: $domain`n"
            $obj.Results += "User SID: $securityid`n"}
            Write-Output $obj
            writeHostSeparator #creates a dash after record "---"
  }
     
                
        }#-- Check if logon was done by user not in exception list
    ElseIf($event.id -eq 4648){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # A logon was attempted using explicit credentials.
                $username=$eventXML.Event.EventData.Data[1]."#text"
                $hostname=$eventXML.Event.EventData.Data[2]."#text"
                $targetusername=$eventXML.Event.EventData.Data[5]."#text"
                $sourceip=$eventXML.Event.EventData.Data[12]."#text"

                # For each #4648 event, increment a counter in $passspraytrack. If that counter exceeds 
                # $passsprayloginmax, then check for $passsprayuniqusermax also exceeding threshold and raise
                # a notice.
                if ($passspraytrack[$targetusername] -eq $null) {
                    $passspraytrack[$targetusername] = 1
                } else {
                    $passspraytrack[$targetusername] += 1
                }
                if ($passspraytrack[$targetusername] -gt $passsprayloginmax) {
                    # This user account has exceedd the threshoold for explicit logins. Identify the total number
                    # of accounts that also have similar explicit login patterns.
                    $passsprayuniquser=0
                    foreach($key in $passspraytrack.keys) {
                        if ($passspraytrack[$key] -gt $passsprayloginmax) { 
                            $passsprayuniquser+=1
                        }
                    }
                    if ($passsprayuniquser -gt $passsprayuniqusermax) {
                        $usernames=""
                        foreach($key in $passspraytrack.keys) {
                            $usernames += $key
                            $usernames += " "
                            $passsprayuniqaccounts += 1
                        }
                        $obj.Message = "Distributed Account Explicit Credential Use (Password Spray Attack)"
                        $obj.Results = "The use of multiple user account access attempts with explicit credentials is "
                        $obj.Results += "an indicator of a password spray attack.`n"
                        $obj.Results += "Target Usernames: $usernames`n"
                        $obj.results += "Unique accounts sprayed: $passsprayuniqaccounts`n"
                        $obj.Results += "Accessing Username: $username`n"
                        $obj.Results += "Accessing Host Name: $hostname`n"
                        Write-Output $obj
                        $passspraytrack = @{} # Reset
                    }
                }
            }#--user logs with one account but tries to run something with a different account - ie: map a driver
    ElseIf($event.id -eq 4673){
                $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # Sensitive Privilege Use (Mimikatz)
                $totalsensprivuse+=1
                # use -eq here to avoid multiple log notices
                if ($totalsensprivuse -eq $maxtotalsensprivuse) {
                    $obj.Message = "Too many Admin events logged. - Sensitive Privilege Use Exceeds Threshold"
                    $obj.Results = "Potentially indicative of Mimikatz, multiple sensitive privilege calls have been made.`n"
                    $sid = $eventXML.Event.EventData.Data[0]."#text"
                    $machineName = $event.MachineName
                    $username=$eventXML.Event.EventData.Data[1]."#text"
                    $domainname=$eventXML.Event.EventData.Data[2]."#text"

                    $obj.Results += "Username: $username`n"
                    $obj.Results += "Domain Name: $domainname`n"
                    if($v){
                    $obj.Results += "MachineName: $machineName`n"
                    $obj.Results += "Sid: $sid`n"
                }#-if -v switch has been selected
                    Write-Output $obj
                }
            }#-- A privileged service was called
    ElseIf($event.id -eq 4674){
                # An operation was attempted on a privileged object.
                if ($event.Message){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                    # Message is a blob of text that looks like this:
                    #########################################################
                    # An operation was attempted on a privileged object.
                    #
                    # Subject:
                    # 	Security ID:		SEC504STUDENT\Sec504
                    # 	Account Name:		Sec504
                    # 	Account Domain:		SEC504STUDENT
                    # 	Logon ID:		
                    #
                    # Object:
                    # 	Object Server:	SC Manager
                    # 	Object Type:	SERVICE OBJECT
                    # 	Object Name:	nginx
                    # 	Object Handle:	
                    #
                    # Process Information:
                    # 	Process ID:	0x21c
                    # 	Process Name:	C:\Windows\System32\services.exe
                    #
                    # Requested Operation:
                    # 	Desired Access:	WRITE_DAC
                    #
                    # 	Privileges:		SeSecurityPrivilege
                    $array = $event.message -split '\n' # Split each line of the message into an array
                    $text = $array[0]
                    $application = Remove-Spaces($array[3])
                    $user = Remove-Spaces(($array[4] -split ':')[1])
                    $service = Remove-Spaces(($array[11] -split ':')[1])
                    $application = Remove-Spaces(($array[16] -split ':	')[1])
                    $accessreq = Remove-Spaces(($array[19] -split ':')[1])

                    if ($application.ToUpper() -Eq "C:\WINDOWS\SYSTEM32\SERVICES.EXE" `
                            -And $accessreq.ToUpper() -Match "WRITE_DAC") {
                        $obj.Message="Possible Hidden Service Attempt"
                        $obj.Command = ""
                        $obj.Results = "User requested to modify the Dynamic Access Control (DAC) permissions of a service, possibly to hide it from view.`n"
                        $obj.Results += "User: $user`n"
                        $obj.Results += "Target service: $service`n"
                        $obj.Results += "Desired Access: $accessreq`n"
                        Write-Output $obj
                    }
                }
            }#-- An operation was attempted on a privileged object
    Elseif ($event.id -eq 4688){
        $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = $event.message
            Results = ""
            Command = ""
            Decoded = ""
        }
        
                # A new process has been created. (Command Line Logging)
                $commandline=$eventXML.Event.EventData.Data[8]."#text" # Process Command Line
                $creator=$eventXML.Event.EventData.Data[13]."#text"    # Creator Process Name
                if ($commandline){
                    Check-Command -EventID 4688
                }

            }#--Check for PsExec New Service 
    ElseIf($event.id -eq 4720){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                # A user account was created.
                $newUser=$eventXML.Event.EventData.Data[0]."#text"
                $userName=$eventXML.Event.EventData.Data[1]."#text"
                $sid=$eventXML.Event.EventData.Data[2]."#text"
                $machineName=$eventXML.Event.EventData.Data[4]."#text"
                
                #write-host "username $username"
                #write-host "newUser $newUser"

                $obj.Message = "New User Created"
                $obj.Results = "Username: $username`n"
                if($v){
                    $obj.Results += "MachineName: $machineName`n"
                    $obj.Results += "Sid: $sid`n"
                }#-if -v switch has been selected
                $obj.Results += "New User Account Name: $newUser"
                Write-Output $obj
                writeHostSeparator #creates a dash after record "---"

            }#-- New user created  
    ElseIf(($event.id -eq 4728) -or ($event.id -eq 4732) -or ($event.id -eq 4756)){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                
                # A member was added to a security-enabled (global|local|universal) group.
                $groupname=$eventXML.Event.EventData.Data[2]."#text"
                # Its possible to add check was added to specific group here, currently monitors all groups
                 if($groupname -ne "None"){
                    $username=$eventXML.Event.EventData.Data[6]."#text"
                    $sid=$eventXML.Event.EventData.Data[5]."#text"
                    $domain = $eventXML.Event.EventData.Data[7]."#text"

                    switch ($event.id){
                        4728 {$obj.Message = "User added to global $groupname group"}
                        4732 {$obj.Message = "User added to local $groupname group"}
                        4756 {$obj.Message = "User added to universal $groupname group"}
                    }
                    $obj.Results = "Username: $username`n"
                    if($v) {
                    $obj.Results += "Domain: $domain`n"
                    $obj.Results += "User SID: $sid`n"
                    }
                    Write-Output $obj
                    #sleep 4
                    writeHostSeparator
                    }#--close if checking if group name -eq or -ne
                 Else{}
            }#-- user added to admin group
    ElseIf($event.id -eq 4625){
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
            
               # $event | Select-Object * ; sleep 5
                # An account failed to log on.
                # Requires auditing logon failures
                # https://technet.microsoft.com/en-us/library/cc976395.aspx
                
                $username=$eventXML.Event.EventData.Data[5]."#text"
                $obj.Results = "Username: $username`n"
                $obj.Message = "Failed logon attempt on $username"
                if($v) {
                $obj.Results += "Domain: $domain`n"
                $obj.Results += "User SID: $sid"
                    }
                Write-Output $obj
                #sleep 4
                writeHostSeparator
    

            }#-- Failed logons   
    ElseIf ($event.id -eq 1102){ 
            $obj = [PSCustomObject]@{
            Date    = $event.TimeCreated
            Log     = $logname
            EventID = $event.id
            Message = ""
            Results = ""
        }
                
               $array = $event.message -split '\n' # Split each line of the message into an array
               $sid = Remove-Spaces ($array[2])
               $username = Remove-Spaces ($array[3])
               $domain = Remove-Spaces ($array[4])
               $machinename = Remove-Spaces ($event.MachineName)
              # Write-Host $domain -ForegroundColor Yellow ; sleep 2
               #$username=$eventXML.Event.EventData.Data[1]."#text"
               # $domain=$eventXML.Event.EventData.Data[2]."#text"
               # $securityid=$eventXML.Event.EventData.Data[3]."#text"
               # $privileges=$eventXML.Event.EventData.Data[4]."#text"

                # The Audit log file was cleared.
                $obj.Message = "Audit Log Clear"  
                $obj.Results = "$username`n"
                $obj.Results += "$domain`n"
                $obj.Results += "Machine Name: $machinename`n"
                $obj.Results += "$sid`n"
                $obj.Results += "The Audit log was cleared.`n"
        Write-Output $obj
        writeHostSeparator #creates a dash after record "---"




            }#-- Cleared logs
#-------------------securityn events end

<#                                                                 /$$                 /$$ /$$
                                                                | $$                | $$| $$
  /$$$$$$   /$$$$$$  /$$  /$$  /$$  /$$$$$$   /$$$$$$   /$$$$$$$| $$$$$$$   /$$$$$$ | $$| $$
 /$$__  $$ /$$__  $$| $$ | $$ | $$ /$$__  $$ /$$__  $$ /$$_____/| $$__  $$ /$$__  $$| $$| $$
| $$  \ $$| $$  \ $$| $$ | $$ | $$| $$$$$$$$| $$  \__/|  $$$$$$ | $$  \ $$| $$$$$$$$| $$| $$
| $$  | $$| $$  | $$| $$ | $$ | $$| $$_____/| $$       \____  $$| $$  | $$| $$_____/| $$| $$
| $$$$$$$/|  $$$$$$/|  $$$$$/$$$$/|  $$$$$$$| $$       /$$$$$$$/| $$  | $$|  $$$$$$$| $$| $$
| $$____/  \______/  \_____/\___/  \_______/|__/      |_______/ |__/  |__/ \_______/|__/|__/
| $$                                                                                        
| $$                                                                                        
|__/  #>
# -----------CHECK FOR POWERSHELL EXECUTION
            if ($event.id -eq 4103){
                $commandline= $eventXML.Event.EventData.Data[2]."#text"
                if ($commandline -Match "Host Application"){ 
                    # Multiline replace, remove everything before "Host Application = "
                    $commandline = $commandline -Replace "(?ms)^.*Host.Application = ",""
                    # Remove every line after the "Host Application = " line.
                    $commandline = $commandline -Replace "(?ms)`n.*$",""
                    if ($commandline){
                      Check-Command -EventID 4103
                    }
                }
            }
            ElseIf ($event.id -eq 4104){
                # This section requires PowerShell command logging for event 4104 , which seems to be default with 
                # Windows 10, but may not not the default with older Windows versions (which may log the script 
                # block but not the command that launched it). 
                # Caveats included because more testing of various Windows versions is needed
                # 
                # If the command itself is not being logged:
                # Add the following to \Windows\System32\WindowsPowerShell\v1.0\profile.ps1
                # $LogCommandHealthEvent = $true
                # $LogCommandLifecycleEvent = $true
                #
                # See the following for more information:
                #
                # https://logrhythm.com/blog/powershell-command-line-logging/
                # http://hackerhurricane.blogspot.com/2014/11/i-powershell-logging-what-everyone.html
                #
                # Thank you: @heinzarelli and @HackerHurricane
                # 
                # The command's path is $eventxml.Event.EventData.Data[4]
                #
                # Blank path means it was run as a commandline. CLI parsing is *much* simpler than
                # script parsing. See Revoke-Obfuscation for parsing the script blocks:
                # 
                # https://github.com/danielbohannon/Revoke-Obfuscation
                #
                # Thanks to @danielhbohannon and @Lee_Holmes
                #
                # This ignores scripts and grabs PowerShell CLIs
                if (-not ($eventxml.Event.EventData.Data[4]."#text")){
                      $commandline=$eventXML.Event.EventData.Data[2]."#text"
                      if ($commandline){
                          Check-Command -EventID 4104
                      }
                }
            }     
    Else{}      



}#--- close ForEach






}###--clos main function
