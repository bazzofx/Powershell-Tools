#test
$x = "C:\Program Files\Microsoft OneDrive\OneDrive.exe"

function start {
    Start-Process $x
}

fuction check{

        Try{
            #Start-Process $x
                while(Get-Process $x -ErrorAction SilentlyContinue){
                     Start-Sleep -Milliseconds 500
                     Write-Host "Starting OneDrive" -ForegroundColor yellow
               }
        Start-Sleep -Seconds 5
                if ((Get-Process -name $x -ErrorAction SilentlyContinue) -eq $null){
                   Write-Host "OneDrive is running fine" -ForegroundColor green
                   Start-Sleep 2
                   check}
                else{start}
                }#---close try



        Catch{Write-Warning "I catched that"}

}

check # start the party
