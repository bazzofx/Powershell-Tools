Clear-Host
$targetIp = Get-Content "c:/temp/ips.txt"
$outArray = @()
$outfile = "C:\temp\outFile.txt"
$port = Read-Host "Select the port number you would like to check if its open? " 

forEach ($record in $targetIp){
    $connect = Test-NetConnection $record -Port $port
    if($connect.TcpTestSucceeded -like "True" ){Write-Host "[OPEN] $record Port" -ForegroundColor green;$value = "[OPEN] IP: $record on Port $port"} 
    else{Write-Host "I cant ping $record" -ForegroundColor Red;$value = "[CLOSED] IP: $record Port $port"}
    
    $outArray += $value
}

$outArray > $outFile
Write-Host "File exported to $outFile" -ForegroundColor Yellow
Start-Sleep -Seconds 1

#read file that we are able to ping on console that was just exported
$log = Get-Content "C:\temp\outFile.txt"

forEach($x in $log){
    if ($x -like "*OPEN*"){
        $x = $x.replace("[OPEN] IP: ","").replace(" on Port 3389","")
        Write-Host $x -ForegroundColor Green
        }
}
