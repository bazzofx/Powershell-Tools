$filePath = "C:/temp/data.csv"
$inputFile = Import-Csv $filePath -Header "hostname","ip"
Clear-Host
$date = Get-Date -Format dd-mm-yyyy
$hour = Get-Date -Format HHmm
Write-Host "File will be saved on C:/temp" -ForegroundColor Yellow
Write-Host "Please type the file name" -ForegroundColor Yellow
$fileName = Read-Host "File Name"
$port = Read-Host "Port Number"
$outfile = "C:\temp\" + "$fileName" + "scan port " + "$port" + "$date@$hour.csv"
$global:array = @()
$global:tracker= @()
"@                                    PING HUNTER TRAIL~~
                /i
                //,              *             *
  |            ///i 
 -X-         ,/ ).'i            SEEK  .                .
  |           |   )-i                  AND 
              |   )i           .              YOU   .
              '   )i                    .     
             /    |-        .           
        _.-./-.  /z_               SHALL         .
         `-. >._\ _ );i.                        .       ,
          / `-'/`k-'`u)-'`          .      FIND...
         /    )-                .          .      *
  ,.----'   ) '                       *
  /      )1`                            ~~by PB a.k.a CyberSamurai
 ///v`-v\v                                            https://cybersamurai.co.uk
/v  
@"
Write-Host $art -ForegroundColor Magenta


function pingEach($line){
    
    $ip = $line."Ip"
    $hostname =$line.hostname
    $ipParts = $ip.split(",")
    $ipCount = $ipparts.count

    for($i=0;$i -lt $ipCount;$i++){
    $record =  $ipParts[$i]
    
    $row = New-Object Object

    if($record -notin $global:tracker){
        $connect = Test-NetConnection $record -Port $port
            if($connect.TcpTestSucceeded -like "True" ){Write-Host "[OPEN] $record PORT: $port" -ForegroundColor green;
     $row | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $hostname
     $row | Add-Member -MemberType NoteProperty -Name "IP" -Value $record
     $row | Add-Member -MemberType NoteProperty -Name "Port" -Value $port
     $row | Add-Member -MemberType NoteProperty -Name "Status" -Value "Open"
     }

             else{Write-Host "[CLOSED] $record PORT: $port" -ForegroundColor Red
     $row | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $hostname
     $row | Add-Member -MemberType NoteProperty -Name "IP" -Value $record
     $row | Add-Member -MemberType NoteProperty -Name "Port" -Value $port
     $row | Add-Member -MemberType NoteProperty -Name "Status" -Value "Closed"
    
    }
    
        $global:tracker += $record
        $global:array += $row
        }#--close if record not in tracker, skip this record 
    }#--close forLoop

}



forEach($x in $inputFile){
    
    pingEach $x

}

$global:array | Export-Csv $outfile -NoTypeInformation

Write-Host "File exported to $outFile" -ForegroundColor Yellow
