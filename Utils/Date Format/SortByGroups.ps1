$wd = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Github\Powershell Tools\Utils\CSV Utils\Sort by Groups"
$file = "$wd\sampleData.csv"
$data = Import-csv $file | Group-Object -Property EmployeeId

function sortByInnerGroups{
#Sort BY INNER GROUPS
$sortedSystemObjects = $data | Sort-Object -Property { $_.Group.ScalePoint } -Descending

ForEach ($x in $sortedSystemObjects) {
    $highestScalePoint = $x.Group | Sort-Object -Property ScalePoint -Descending | Select-Object -First 1
    $highestScalePoint
    Start-Sleep -Seconds 4
    }
}

function sortByOutterGroups{
#SORT BY OUTTER GROUPS
$sortedSystemObjects = $data | Sort-Object -Property { $_.Group.ScalePoint } -Descending

 forEach($x in $sortedSystemObjects) {
    $x.Group | Select-Object -First 1
    sleep 4
}

}

