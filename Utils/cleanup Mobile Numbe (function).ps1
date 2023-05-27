$path ="C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Trent Projects\2023\February\Fall Back Plan - Bulk Users Upload\Phase 2\Mobile\home.csv"
$outPath = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Trent Projects\2023\February\Fall Back Plan - Bulk Users Upload\Phase 2\Mobile\homeClean.csv"

$data = Import-Csv $path -Header "User","Phone"
$number = 2
$array = @()
forEach ($x in $data) {
    $row = New-Object Object
    $newPhone = $x.Phone -replace  '\s', ''
    $newPhone2 = $newPhone.replace('0044(0)', '0').replace('+44','0')
    $newPhone2 = $newPhone2 -replace '(.{5})', ' $1' #adds space every 5 characters
    $newPhone2
    
    $row | Add-Member -MemberType NoteProperty -Name "Ref#" -Value $x.User
    #$row | Add-Member -MemberType NoteProperty -Name "CorrectPhone" -Value "=CONCAT(D$number,C$number)"
    $row | Add-Member -MemberType NoteProperty -Name "Phone" -Value $newPhone2
    #$row | Add-Member -MemberType NoteProperty -Name "Zero" -Value "0"
    $number += 1
    $array += $row
}

    $array | Export-Csv -Path $outPath -NoTypeInformation 