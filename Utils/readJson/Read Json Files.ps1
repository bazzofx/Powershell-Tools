$wd = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Github\FitzRoy\PlanDaySync_API_LIVE"
$file = "$wd\currentEmployees.json"
$outLocation = "C:\Users\Paulo.Bazzo\Downloads\outFile.csv"

$json = Get-Content $file | Out-String | ConvertFrom-Json
$array = @()
$json[0].data | ForEach-Object {
    $row = New-Object Object
    $flattenedObject = $_ | ConvertTo-Json -Depth 100 | ConvertFrom-Json
    $email = $flattenedObject.email
    $employeeGroup = $flattenedObject.employeeGroups
    [string]$x = $employeeGroup
    $x = $x.replace(" ",";")

    $row | Add-Member -MemberType NoteProperty -Name "email" -Value $email
    $row | Add-Member -MemberType NoteProperty -Name "employeeGroups System Object" -Value $employeeGroup
    $row | Add-Member -MemberType NoteProperty -Name "employeeGroups" -Value $x
    $array +=$row
    Write-Host "$email  $x"
}
$array | Export-Csv $outLocation -NoTypeInformation