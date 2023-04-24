$out = (1,1,2,3,4,5,6,6,6,7,8,9,9)
$array = @{}
    $out | foreach {$array["$_"] += 1}
    $array.keys | where {$array["$_"] -gt 1} |foreach {$_.replace('}','')} | foreach {Write-Host "Duplicated found $_."}