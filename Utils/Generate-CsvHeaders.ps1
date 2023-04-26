$stringHeaders = ""
$string = "First name,Surname,Tax ID,Salary identifier,Department,Leave type,Account,Valid from,Valid until,Bank Holiday calendar,Employee type,Accruing rate value,Accruing rate unit,Period start,Period end,Start balance,Balance at period start,Balance accrued,Balance used,Available balance,Unit,Notes,Leave pay – at the end day of the period filter"
function stringify ($string,$separator) {
$blob = $string.split(",")
$headersCount = $blob.Length - 1
$count =0
    ForEach ($x in $blob){
    if($count -eq $headersCount)
    {   $xmodified = '"' + $x + '"'
        $stringHeaders += $xmodified
        #Write-Host "exception" -ForegroundColor Red
        }
    else{$xmodified = '"' + $x + '",'
        $stringHeaders += $xmodified
        #Write-Host $count  -ForegroundColor Yellow
        $xmodified}
$count  += 1
    }#cls forEach
return $stringHeaders

}

stringify $string ","