$data = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Trent Projects\In Progress\Automation Reporting Manager - FTP+Data Conversion\SAP-test\Norfolk-data.csv"
$content = Get-Content $data
$contentSplit = $content.split(",")
$dataExtract= "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Trent Projects\In Progress\Automation Reporting Manager - FTP+Data Conversion\SAP-test\Data-Extract\Norfolk-data-extract.csv"
$lenght = $dataExtract.Length


[string[]] $Params = $content
$result = for ($i = 0; $i -lt $Params.Count -1; $i+=1 ) {
    [PSCustomObject]@{
    # if any of the strings in the $Params array contains spaces 
    # or comma's I would strongly suggest quoting the output.
   $x = '"{0}","{1}"' -f $Params[$i], $Params[$i+1]
   }
}

$result | ConvertTo-CSV --NoTypeInformation | out-file $dataExtract -Encoding utf8 -Force
#$result | Set-Content $dataExtract
