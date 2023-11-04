function addMissingSources{

$data = Import-Csv $temp1
#$allSources = @()
$allSources = $data.source
$missingOnes = @()
foreach($x in $data) {
if($x.dst -notin $allSources -and $x.dst -notin $missingOnes -and $x.dst -ne $null -and $x.dst -ne ""){
    $destination = $x.dst

   $missingOnes +=  $x.dst
   Write-Host " $destination added ";sleep 1
    }
}
$newRowList = @()
forEach($x in $missingOnes){
 $row =      [PsCustomObject]@{
                source = $x
                dst = "Internet"
                dst2 = ""
                dst3 = ""
                dst4 = ""
                dst5 = ""
                fill = "#dae8fc"
                stroke = "#6c8ebf"
                shape = "ellipse"
                label = "IP: "+ $x
        }
 $newRowList += $row
}

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation

}

addMissingSources
