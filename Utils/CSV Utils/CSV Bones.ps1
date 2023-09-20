$array = @()

ForEach($object in $myCsvFile)
    {
    $row = New-Object Object

    $row | Add-Member -MemberType NoteProperty -Name "Employee ID" -Value $ID
    #...
    #...
    #...

    $array +=$row
    }
    $array | Export-Csv $outLocation -NoTypeInformation
