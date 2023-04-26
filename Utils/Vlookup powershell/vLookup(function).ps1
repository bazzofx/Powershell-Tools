$wd ="C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Github\Powershell Tools\Utils\Vlookup powershell\vlookup data(function)"
### Currently Working directory of script

$filePath1 = "$wd\info.csv"
$filePath2 = "$wd\plandayLeave.csv"
$outLocation = "$wd\Combined.csv"
$lookupKey = "Salary identifier"
$column = ""


function Headers1 {
#$filePath1 = Import-Csv $filePath1
$filePath1 = Import-Csv $filePath1
$filePath1 | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"} | Select Name, Definition
}
function Headers2 {
$filePath2 = Import-Csv $filePath2
$filePath2 | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"} | Select Name, Definition
}
function pd($filePath1, $filePath2, $column, $lookupKey, $outLocation){
        # Check if Combine.csv exists
    if (Test-Path $outLocation) {
        # Import Combine.csv if it exists
        $filePath1 = Import-Csv $outLocation
        Write-Host "         █├♦╩Mergin in progress -- Adding Headers $column to file" -ForegroundColor White -BackgroundColor Blue
         } 
  else {
        # Import Info.csv if Combine.csv does not exist
        $filePath1 = Import-Csv $filePath1
        Write-Host " Creating merged file" -ForegroundColor Black -BackgroundColor Yellow
        }

    $filePath2 = Import-Csv $filePath2


    $hash = @{} 

    $file1Headers = $filePath1 | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"}

    $fileHeaders = $file1Headers.Name -join ","
    $fileHeaders = $fileHeaders.split(",")

    $filePath2 | %{$hash[$_.$lookupKey]=$_.$column}  
    
    $filePath1 | Select-Object ($fileHeaders | Where-Object {$_ -ne $column}) |
             Select-Object *, @{name=$column; expression={$hash[$_.$lookupKey]}} |
             Export-Csv $outLocation -NoTypeInformation
}

function Pslookup ($column) {
pd -filePath1 $filePath1 -filePath2 $filePath2 -column $column -lookupKey $lookupKey -outLocation $outLocation
}

Pslookup -column "Balance used"
Pslookup -column "Available balance"