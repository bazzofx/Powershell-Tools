#change for the working path directory of file
### Currently Working directory of script
$wd= "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Trent Projects\2023\June\MattZone" 
#-------------- CHANGE ME
#File 2 will be added into file 1
$filePath1 = "$wd\patterOverrideResponses.csv"
$filePath2 = "$wd\AllEmployees.csv"
$outLocation = "$wd\finalPatternResponses.csv"
$lookupKey = "Email"


#├----------------------- FUNCTIONS -----------------------
function emoji ($hexValue,$fgColor,$bgColor){
#Firstly, the code below will convert the Hex value to Integer
$EmojiIcon = [System.Convert]::toInt32("$hexValue",16)
#Secondly, convert the Unicode point which is stored in $EmojiIcon to UTF-16 String
 $emoji = Write-Host -ForegroundColor $fgColor -BackgroundColor $bgColor ([System.Char]::ConvertFromUtf32($EmojiIcon)) -NoNewline
 return $emoji
 } 
function Headers1 {
#$filePath1 = Import-Csv $filePath1
$filePath1 = Import-Csv $filePath1
$filePath1 | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"} | Select Name, Definition
}
function Headers2 {
#$filePath1 = Import-Csv $filePath1
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
        emoji 1F344 white blue
        Write-Host " [SUCCESS]      █├♦╬ Mergin in progress -- Adding Header to file name: '$column' " -ForegroundColor White -BackgroundColor Blue
        
         } 
  else {
        # Import Info.csv if Combine.csv does not exist
        $filePath1 = Import-Csv $filePath1
        emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red
        Write-Host "   ▀─¦    Turning on the oven..." -ForegroundColor white -BackgroundColor Red -NoNewline
        emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;emoji 1F525 white red;
        Start-Sleep 2
        Write-Host " ►  Adding your files into recipe...   " -ForegroundColor white -BackgroundColor Red
        Start-Sleep 1
        #Write-Host "                  █¦╩►  Mixing all ingredients and files together" -ForegroundColor Green
        emoji 1F344 white blue
        Write-Host " [SUCCESS]      █├♦╬ Mergin in progress -- Adding Header to file name: '$column' " -ForegroundColor White -BackgroundColor Blue
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
#├----------------------- FUNCTIONS -----------------------

#├-----------------------  EXAMPLES 1-----------------------
Pslookup -column "EmployeeID"