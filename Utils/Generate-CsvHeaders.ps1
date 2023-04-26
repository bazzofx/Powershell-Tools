$stringHeaders = ""
$string = "First name,Surname,Tax ID,Salary identifier,Department,Leave type,Account,Valid from,Valid until,Bank Holiday calendar,Employee type,Accruing rate value,Accruing rate unit,Period start,Period end,Start balance,Balance at period start,Balance accrued,Balance used,Available balance,Unit,Notes,Leave pay – at the end day of the period filter"
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
    Write-Host "     TYPE y or yes"  -ForegroundColor White -BackgroundColor blue
    Write-Host "     TYPE n or no     "  -ForegroundColor White -BackgroundColor blue
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