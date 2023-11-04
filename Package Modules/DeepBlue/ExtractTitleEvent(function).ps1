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
        Write-Host "No matches found."
        return $null
    }
}


$file = "C:\Users\Slave\Desktop\DeepBlue\security logs.evtx"
$logname = "Security"


#$filter = Create-Filter -file $file -logname $logname
#$events = Get-WinEvent -FilterHashtable $filter

forEach ($event in $events){
$eventXML = [xml]$event.ToXml()
        $obj = [PSCustomObject]@{
            #Date    = $event.TimeCreated
            #Log     = $logname
            #EventID = $event.id
            Message = ""
            Results = ""
            #Command = ""
            #Decoded = ""
        }
        
                $message = extractTitle -inputString $event.message
                #$username=$eventXML.Event.EventData.Data[1]."#text"
                #$domain=$eventXML.Event.EventData.Data[2]."#text"
                #$securityid=$eventXML.Event.EventData.Data[3]."#text"
                #$privileges=$eventXML.Event.EventData.Data[4]."#text"
                #Write-Host $privileges -ForegroundColor Green ; sleep 4
 if ($privileges -match "SeTcbPrivilege"){$privileges = "System Full Priviledge"}Else{}      
        
        #$obj.Message = "Logon with SeDebugPrivilege (admin access)`n" 
        $obj.Message = $message
        #$obj.Results = "Username: $username`n"
        #$obj.Results += "Domain: $domain`n"
        #$obj.Results += "User SID: $securityid`n"
        $obj.Results += "Privileges: $privileges`n"
        #$obj.Command = ""
       # $obj.Decoded = ""
        Write-Output $obj
        #sleep 5

}