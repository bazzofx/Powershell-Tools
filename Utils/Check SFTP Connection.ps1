$Server = 192.168.0.15

function Test-Connection {
$Test = Test-NetConnection -ComputerName $Server -Port 22

If ($Test.TcpTestSucceeded -eq $True) 
    {Write-Host "Connection to SFTP on $Server is up"}
Else 
    {Write-Host "You've got a problem!"}
    } #--test STFP Connection