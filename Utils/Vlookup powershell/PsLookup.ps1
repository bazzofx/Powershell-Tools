#change for the working path directory of file
### Currently Working directory of script
$wd= "" 
#-------------- CHANGE ME

$filePath1 = "$wd\main.csv"
$filePath2 = "$wd\weight.csv"
$outLocation = "$wd\Oven\Cooked_andCombined_Report.csv"
$lookupKey = "Salary identifier"
$column = ""

#├----------------------- FUNCTIONS -----------------------
function Headers1 {
#$filePath1 = Import-Csv $filePath1
$filePath1 = Import-Csv $filePath1
$filePath1 | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"} | Select Name, Definition
} #will show available Heades on file 1
function Headers2 {
#$filePath1 = Import-Csv $filePath1
$filePath2 = Import-Csv $filePath2
$filePath2 | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"} | Select Name, Definition
} # will show available Heades on file 2
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
} #main function
function Pslookup ($column) {
pd -filePath1 $filePath1 -filePath2 $filePath2 -column $column -lookupKey $lookupKey -outLocation $outLocation
} #main function lazy mode
#├----------------------- FUNCTIONS -----------------------

#├-----------------------  EXAMPLES 1-----------------------
Pslookup -column "weight"
$filePath2 = "$wd\salary.csv"
Headers2
Pslookup -column "Salary"
Pslookup -column "Year"
#├-----------------------  EXAMPLES 2 -----------------------
pd -filePath1 $filePath1 -filePath2 $filePath2 -column "Salary" -lookupKey "Salary identifier" -outLocation "$wd/salaryOnly_merged.csv"