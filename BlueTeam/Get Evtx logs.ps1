#Get all logs from a computer

$outLocation = "C:\temp"
function getAllLogs{
Get-WinEvent -ListLog *
}

function get-ResponseLogs{
#define list of logs you want to extract
$logs = Get-WinEvent -ListLog "Application","Security","Setup","System"

    forEach ($log in $logs){
    $logName = $log.logName
    $path = Get-WinEvent -ListLog $logName | Select LogFilePath 
    Try{
    #copy live .evtx files into temp directory
    $outPath = "$outLocation\$lotname"
    Copy-Item $path $outPath

    #move all the exported .evtx from the temp folder into one .zip file

    Write-Host "$logname exported to $outLocation" -ForegroundColor Green
    }
    Catch{Write-Host "Could not export logs" -ForegroundColor Red}
    

            }
}


function showWinLog($name){
Get-WinEvent -ListLog $name
}
