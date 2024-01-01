function main {
param(
[switch]$f =$false,
[switch]$h =$false
)

$date = Get-Date -Format dd-mm-yyyy
$hour = Get-Date -Format HHmm
$targetIp = Get-Content "c:/temp/ips.txt"
$outArray = @()
"@                                    PING SWEEP~~
  ___   _      ___   _      ___   _      ___   _      ___   _           .         *       .
 [(_)] |=|    [(_)] |=|    [(_)] |=|    [(_)] |=|    [(_)] |=|
  '-`  |_|     '-`  |_|     '-`  |_|     '-`  |_|     '-`  |_|     Don't be a packet dropout in life ...
 /mmm/  /     /mmm/  /     /mmm/  /     /mmm/  /     /mmm/  /        .            .                 .
       |____________|____________|____________|____________|
                             |            |            |         transmit your dreams ~~~        *
                         ___  \_      ___  \_      ___  \_       *        .                .   . 
                        [(_)] |=|    [(_)] |=|    [(_)] |=|           . 
                        '-`  |_|     '-`  |_|     '-`  |_|      .      ~~~~   until they're received.
                        /mmm/        /mmm/        /mmm/                    *            *
                                                               A tool by PB a.k.a CyberSamurai
@"
Write-Host $art -ForegroundColor Magenta
if($f -eq $true) {Write-Host " x - x -[ FAST MODE ACTIVE ]- x - x " -ForegroundColor Yellow}
if($h -eq $true) {Write-Host "Run pingsweep -f to run fast mode( sends 2 packets instead of 4)"}


$outfile = "C:\temp\PingSweep" + "$port" + "_ScanDate_" + "$date@$hour.csv"
$array = @()
forEach ($record in $targetIp){
   
    $row = New-Object Object
    if ($f -eq $true) {
    $result = ping $record -n 2
    }
    else{
    $result = ping $record 
    }
    #$result = $result.toString()
 

#meat and potatoes
    if(!([string]$result -like "*unreachable*" -or 
    $result -like "*could not find host*" -or 
    $result -like "*timed out*"))
    
    {
    Write-Host "[SUCCESS] ICMP ping to $record "-ForegroundColor green
    
     
     $row | Add-Member -MemberType NoteProperty -Name "IP" -Value $record
     $row | Add-Member -MemberType NoteProperty -Name "Type" -Value "ICMP"
     $row | Add-Member -MemberType NoteProperty -Name "Status" -Value "Online"
     }

    else{
    Write-Host "[FAIL] ICMP ping to $record "-ForegroundColor red
     
     $row | Add-Member -MemberType NoteProperty -Name "IP" -Value $record
     $row | Add-Member -MemberType NoteProperty -Name "Type" -Value "ICMP"
     $row | Add-Member -MemberType NoteProperty -Name "Status" -Value "Unreachable"
    
    }
    
    $array += $row
}

$array | Export-Csv $outfile -NoTypeInformation

Write-Host "File exported to $outFile" -ForegroundColor Yellow

###Import results and show it on screen
Start-Sleep -Seconds 1
#read file that we are able to ping on console that was just exported
$log = Import-Csv $outfile
Write-Host "                Results from Pinging                          " -ForegroundColor Yellow
$log
}

function Pingsweep{
param(
[switch]$f = $false 
)
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
Write-Host "[STARTING] ping sweep with ICMP packets " -ForegroundColor Gray
#running main function

if ($f -eq $true)
{main -f $true}

else{
main
}



}## close else

}#-close PingHunter