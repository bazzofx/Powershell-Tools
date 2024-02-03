$outArray = @()
Add-Type -AssemblyName System.Windows.Forms
$userProfile = $env:USERPROFILE
$wd = Get-Location
$date = Get-Date -Format dd-mm-yyyy
$hour = Get-Date -Format HHmm
$global:filePath = ""
$global:tracker= @()
$outfile = "C:\temp\PingSweep" + "$port" + "_ScanDate_" + "$date@$hour.csv"

$art = "@                                    PING SWEEP~~
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
function brain {
param(
[switch]$f =$false,
[switch]$h =$false
)

$data = OpenFile
Write-Host $art -ForegroundColor Magenta
Write-Host "[CHECK] -  Reading contens from file" -ForegroundColor Gray
Start-Sleep -Seconds 1
Write-Host "[SUCCESS]- Input file loaded succesfully." -ForegroundColor Gray
Start-Sleep -Seconds .5
Write-Host "[STARTING] Pingsweep with ICMP packets " -ForegroundColor Gray
Start-Sleep -Seconds .5
Write-Host "-----------------------------------------" -ForegroundColor Gray
Write-Host "[INFO] Final scan will be saved on 'C:/Temp' " -ForegroundColor Yellow


createTempFolder
$targetIp = Get-Content $global:filePath

if($f -eq $true) {Write-Host " x - x -[ FAST MODE ACTIVE ]- x - x " -ForegroundColor Yellow}
if($h -eq $true) {Write-Host "Run pingsweep -f to run fast mode( sends 2 packets instead of 4)"}

$array = @()

forEach ($record in $targetIp){

    if($record -notin $global:tracker){
    $row = New-Object Object
    if ($f -eq $true) {
    $result = Test-Connection $record -Count 2
    }
    else{
    $result = Test-Connection  $record 
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
    $global:tracker += $record

}#-close if $record not on global:tracker    
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

function help{
Write-Host "-------------- GUIDE -----------------"  -ForegroundColor Gray
Write-Host "To run this application first" -ForegroundColor Gray
Write-Host "Create an .TXT file and save an IPV4 or IPv6 for each line and save the file as TXT file." -ForegroundColor Gray
Write-Host "run pingsweep again `n" -ForegroundColor Gray

Write-Host "-f    -    Will perform a fast ping (2 pings instead of 4 pings [default]" -ForegroundColor Gray
Write-Host "-h    -    Will print this help menu." -ForegroundColor Gray
Write-Host""
Write-Host "-Example:" -ForegroundColor Yellow
Write-Host "pingsweep" -ForegroundColor Gray
Write-Host "pingsweep -f" -ForegroundColor Gray
Write-Host "--------------------------------------" -ForegroundColor Gray
}

function OpenFile {
    $initialPath = Join-Path $env:USERPROFILE "Downloads"
    $FileDialogObject = [System.Windows.Forms.OpenFileDialog]

    # Create Object and add properties
    $OpenFileDialog = New-Object $FileDialogObject
    $OpenFileDialog.InitialDirectory = $initialPath
    $OpenFileDialog.CheckPathExists = $true
    $OpenFileDialog.CheckFileExists = $true
    $OpenFileDialog.Title = "Load a XDR Report that contains at least the headers 'dhost' and 'src'"
    $OpenFileDialog.Filter = "Text files (*.txt)|*.txt|CSV files (*.csv)|*.csv"

    $result = $OpenFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:filePath = $OpenFileDialog.FileName
    }
}
function createTempFolder{
$testOutLocation = Test-Path "C:/temp"
if($testOutLocation -eq $false){mkdir "C:/temp";Write-Host "'C:/temp' created for final output file" -ForegroundColor Gray}
else{}
}


##-control pane
function Pingsweep{
param(
[switch]$f = $false,
[switch]$h = $false
)
$ErrorActionPreference = "Stop"
Clear-Host

if($h -eq $true){help} #print help function

if($h -eq $false) # -h flag was not called, perform check if input file is present
{ 
    #running main function

    if ($f -eq $true){brain -f $true}


    else{brain}

} #-the user did not send -h command

}#-close PingHunter

Export-ModuleMember -Function pingsweep