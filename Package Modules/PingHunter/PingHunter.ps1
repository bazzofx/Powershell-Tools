function main {
$date = Get-Date -Format dd-mm-yyyy
$hour = Get-Date -Format HHmm
$targetIp = Get-Content "c:/temp/ips.txt"
$outArray = @()
"@                                    PING HUNTER~~
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




Write-Host "Type the port number you would like to check if its open|closed?" -ForegroundColor Green
$port = Read-Host "Port Number"
$outfile = "C:\temp\Port" + "$port" + "_ScanDate_" + "$date@$hour.csv"
$array = @()
forEach ($record in $targetIp){
$row = New-Object Object

    $connect = Test-NetConnection $record -Port $port
    if($connect.TcpTestSucceeded -like "True" ){Write-Host "[OPEN] $record PORT: $port" -ForegroundColor green;
     $row | Add-Member -MemberType NoteProperty -Name "IP" -Value $record
     $row | Add-Member -MemberType NoteProperty -Name "Port" -Value $port
     $row | Add-Member -MemberType NoteProperty -Name "Status" -Value "Open"
     }

    else{Write-Host "[CLOSED] $record PORT: $port" -ForegroundColor Red
     $row | Add-Member -MemberType NoteProperty -Name "IP" -Value $record
     $row | Add-Member -MemberType NoteProperty -Name "Port" -Value $port
     $row | Add-Member -MemberType NoteProperty -Name "Status" -Value "Closed"
    
    }
    
    $array += $row
}

$array | Export-Csv $outfile -NoTypeInformation

Write-Host "File exported to $outFile" -ForegroundColor Yellow

###Import results and show it on screen
Start-Sleep -Seconds 1
#read file that we are able to ping on console that was just exported
$log = Import-Csv "C:\temp\outFile.csv" | Where-Object {$_.Status -eq "Open"}
Write-Host "                Results from list - Servers with PORT:$port OPEN:          " -ForegroundColor Yellow
$log
}

function Pinghunter{
$ErrorActionPreference = "Stop"
Clear-Host
Try{
$inputFile = Get-Content "C:\temp\ips.txt"
}#close try
Catch{
Write-Host "[ERROR] - Please make sure your inputFile is not empty and run the PingHunter again!" -ForegroundColor Red
Write-Host "[INFO] - Your input file should be saved on C:\temp\ips.txt - containing one IPv4 or IPv6 per line."  -ForegroundColor Yellow
}
if (-not $inputFile -or $inputFile.Count -eq 0){
    return
}#close if

else {
Write-Host "[CHECK] -  Reading contens from C:/temp/ips.txt..." -ForegroundColor Gray
Start-Sleep -Seconds 1
Write-Host "[SUCCESS]- Input file loaded succesfully." -ForegroundColor Gray
Start-Sleep -Seconds .5

#running main function
main


}## close else

}#-close PingHunter

