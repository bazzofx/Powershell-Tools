$stringHeaders = ""
$string = "Structure Level 1,Structure Level 2,Structure Level 3,Structure Level 4,Structure Level 5,Structure Level 6,Structure Level 7,Structure Level 8,Structure Level 9,Structure Level 10,Employee Name,Job Title,Reference,Scheme Name,Adjustment Reason,Unit,End of Holiday Year,Basic Entitlement,Pro rated,B/F,B/F Lost,Adjustment,Override,Total Entitlement"
$separator = ","
function stringify ($string,$separator) {
cls
$blob = $string.split(",")
$headersCount = $blob.Length - 1
$count =0
    ForEach ($x in $blob){
    if($count -eq $headersCount)
    {   $xmodified = '"' + $x + '"'
        $stringHeaders += $xmodified
        }
    else{$xmodified = '"' + $x + '",'
        $stringHeaders += $xmodified
        }
$count  += 1
    }#cls forEach
#Write-host $stringHeaders -ForegroundColor Yellow
    Write-Host "        Would you like to save the result on your clip-board?      " -ForegroundColor White -BackgroundColor blue
    Write-Host "        TYPE 'y' or 'n'"  -ForegroundColor White -BackgroundColor blue
    Write-Host ""
    $answer = Read-Host "Answer"
    function yes{Set-Clipboard $stringHeaders}

 switch ($answer){
        "yes" {yes}
        "y" {yes}
        "no" {}
        default {}
}

return $stringHeaders

}

stringify -string $string -separator $separator