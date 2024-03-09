##----------------Open File Dialog function
Add-Type -AssemblyName System.Windows.Forms
$userProfile = $env:USERPROFILE
$wd = Get-Location
$date = Get-Date -Format dd-mm-yyyy
$hour = Get-Date -Format HHmm
$global:filePath = ""
$global:tracker= @()
$art = "@                                    PORT HUNTER~~
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

##---------------------------------------
##SUB FUNCTONS
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
if($testOutLocation -eq $false){mkdir "C:/temp";Write-Host "'C:/temp' created" -ForegroundColor Gray}
else{Write-Host "'C:/Temp' location already exist" -ForegroundColor Gray}
}
##---------------------------------------

##-FUNCTIONS
###----------- SEARCH BLOCKS
function portHunterTXT {
$data = Get-Content $global:filePath
$array = @()
$outArray = @()
createTempFolder


Write-Host "Type the port number you would like to check if its open|closed?" -ForegroundColor Green
$port = Read-Host "Port Number"
$outfile = "C:\temp\Port" + "$port" + "_SCAN_" + "$date@$hour.csv"

forEach ($record in $data){
$row = New-Object Object


if($record -notin $global:tracker){


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
    $global:tracker += $record
    $array += $row

}#--if record not yet in global tracker

}#--forEach record in data

$array | Export-Csv $outfile -NoTypeInformation

Write-Host "File exported to $outFile" -ForegroundColor Yellow
}
$global:arrayCSV = @()
function portHunterCSV {
createTempFolder
$data = Import-Csv $global:filePath -Header "hostname","ip" | Select-Object -Skip 1
Write-Host "Type the port number you would like to check if its open|closed?" -ForegroundColor Green
$port = Read-Host "Port Number"
$outfile = "C:\temp\Port" + "$port" + "_SCAN_" + "$date@$hour.csv"


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
        $global:arrayCSV  += $row
        }#--close if record not in tracker, skip this record 
    }#--close forLoop

}



forEach($x in $data){
    
    pingEach $x

}

$global:arrayCSV | Export-Csv $outfile -NoTypeInformation







}
#----------------------------------------------

# MAIN
function porthunter {

    OpenFile
$path = $global:filePath
$extension = [regex]::Match($path, '\.[^.\\]+$').Value

    if ($path -ne "") {      
        Write-Host "File extension selected is $extension"         #-debug
        
        switch($extension){
        ".txt" {portHunterTXT}

        ".csv" {portHunterCSV}


        }
    }#--close if

   else {
        Write-Host "[WARNING] - Application terminated, no file selected." -ForegroundColor Yellow -BackgroundColor Black
    }

}


Export-ModuleMember -Function porthunter






