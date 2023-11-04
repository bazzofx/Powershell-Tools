# Set the input and output file paths
#$inputFilePath = "$wd\out.csv"

$outFile = "$wd\cooked.csv"

Import-Csv "$wd\out.csv" | Group-Object source | ForEach-Object {
    [PsCustomObject]@{
        source = $_.Name
        dst = $_.Group.dst -join ','
    }
} | Export-Csv $outFile -NoTypeInformation