function addInternetNode {
 $row =      [PsCustomObject]@{
                source = "Internet"
                dst = "www"
                dst2 = ""
                dst3 = ""
                dst4 = ""
                dst5 = ""
                fill = "#dae8fc"
                stroke = "#6c8ebf"
                shape = "ellipse"
                label = "Internet"
        }
 $newRowList += $row

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation
$newRowList | Format-Table
}
addInternetNode