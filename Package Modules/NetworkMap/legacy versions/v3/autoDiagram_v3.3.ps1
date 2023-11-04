$wd = "C:\Users\paulo.bazzo\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram\v3"
$data = Import-Csv "$wd\data2.csv"
$temp1 = "$wd\temp1.csv"
$cookedFile = "$wd\cooked.csv"
$imageLevel1 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel2 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel3 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel4 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel5 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageInternet = "https://cdn3.iconfinder.com/data/icons/network-and-communications-8/32/network_web_internet_network-512.png"
function generateTemp1{

$track = @()
$export = @()
$dstList = @()
$dstList2 =@()
$dstList3 = @()
$dstList4 = @()
$dstList5 = @()
foreach ($x in $data) {
    $trackString = "$($x.src) --> $($x.dhost)"
    $source = $x.src
    # Check if the trackString is not already in the $track array
    if ($trackString -notin $track) {
        # Add the trackString to the $track array
        $track += $trackString

        ######Process Records here Display the trackString in Cyan
       # Write-Host $trackString -ForegroundColor Cyan

if($source -notin $dstList) { 
#Write-Host "level 1" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            source = $x.src
            dst = $x.dhost
            dst2 = ""
            dst3 = ""
            dst4 = ""
            dst5 = ""
            label = $x.src
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = '$x.app + " " + $x.act + " " + $x.deviceDirection'
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel1
            

        }

        $export += $newRow
        $dstList += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -and $source -notin $dstList2) { 
#Write-Host "level 2" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            source = $x.src
            dst = ""
            dst2 = $x.dhost
            dst3 = ""
            dst4 = ""
            dst5 = ""
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = '$x.app + " " + $x.act + " " + $x.deviceDirection'
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel2
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -or $source -in $dstList2 -and $source -notin $dstList3) { 
#Write-Host "level 1" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            source = $x.src
            dst = ""
            dst2 = ""
            dst3 = $x.dhost
            dst4 = ""
            dst5 = ""
            label = $x.src
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = '$x.app + " " + $x.act + " " + $x.deviceDirection'
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel3
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
        $dstList3 += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -or $source -in $dstList2 -or $source -in $dstList3 -and $source -notin $dstList4) { 
#Write-Host "level 1" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            source = $x.src
            dst = ""
            dst2 = ""
            dst3 = ""
            dst4 = $x.dhost
            dst5 = ""
            label = $x.src
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = '$x.app + " " + $x.act + " " + $x.deviceDirection'
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel4                 
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
        $dstList3 += $x.dhost
        $dstList4 += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -or $source -in $dstList2 -or $source -in $dstList3 -or $source -in $dstList4 -and $source -notin $dstList5) { 
#Write-Host "level 1" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            source = $x.src
            dst = ""
            dst2 = ""
            dst3 = ""
            dst4 = ""
            dst5 = $x.dhost
            label = $x.src
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = '$x.app + " " + $x.act + " " + $x.deviceDirection'
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel5
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
        $dstList3 += $x.dhost
        $dstList4 += $x.dhost
        $dstList5 += $x.dhost
###--------------------------------------------------
}


    } 
    else {
        # Check if the trackString is in the $done array
        if ($trackString -in $done) {
            # Skip the current record if the trackString is in $done
            continue
        }
        # Display the trackString in Yellow if it's not in $done
        #Show records that were skipped for being repetitive
        #Write-Host $trackString -ForegroundColor Yellow
    }

    # Add the current trackString to the $done array to mark it as processed
    $done += $trackString
}



$export | Export-Csv -Path $temp1 -NoTypeInformation

}

function mergeData{

Import-Csv $temp1 | 
Group-Object source | 
ForEach-Object {
    [PsCustomObject]@{
        source = $_.name
        dst = $_.Group.dst -join ','
        dst2 = $_.Group.dst2 -join ','
        dst3 = $_.Group.dst3 -join ','
        dst4 = $_.Group.dst4 -join ','
        dst5 = $_.Group.dst5 -join ','
        label = "IP: "+ $_.name
            logged = $_.Group.Logged | Select-Object -First 1
            remakrs = $_.Group.remarks | Select-Object -First 1
            peerHost = $_.Group.peerHost | Select-Object -First 1
            ruleName = $_.Group.ruleName | Select-Object -First 1
            connectionLegend = $_.Group.Connection | Select-Object -First 1
            fill = $_.Group.fill | Select-Object -First 1
            stroke = $_.Group.stroke | Select-Object -First 1
            shape = $_.Group.shape | Select-Object -First 1
            image = $_.Group.image | Select-Object -First 1
    }
} | 
Export-Csv $cookedFile -NoTypeInformation

}
function addMissingSources{

$data = Import-Csv $temp1
#$allSources = @()
$allSources = $data.source
$missingOnes = @()
foreach($x in $data) {
if($x.dst -notin $allSources -and $x.dst -notin $missingOnes -and $x.dst -ne $null -and $x.dst -ne ""){
    $destination = $x.dst

   $missingOnes +=  $x.dst
   #debug #Write-Host " $destination added "; sleep 1
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
                label = "IP: "+ $x
                fill = "#dae8fc"
                stroke = "#6c8ebf"
                shape = "ellipse"
                image = $imageLevel1
            logged = ""
            remakrs = ""
            peerHost = ""
            ruleName = ""
            connectionLegend = ""
        }
 $newRowList += $row
}

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation

}
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
                image = $imageInternet
                logged = ""
                remakrs = ""
                peerHost = ""
                ruleName = ""
                connectionLegend = ""
        }
 $newRowList += $row

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation
$newRowList | Format-Table
}
function removeSillyCommans{
$data = Import-Csv $cookedFile

forEach ($row in $data) {
    $row.Psobject.Properties | ForEach-Object {
    $_.value = $_.value -replace'\["|\"]'
    if($_.value -eq ",") {$_.value = ""}
        }
}
$data | Export-Csv $cookedFile -NoTypeInformation
$data | Format-Table
}

function mergeScriptData{
$data = Get-Content $cookedFile
$script = Get-Content "$wd\drawIo.txt"
$finalFile = "$wd\finalFile.txt"
$script > $finalFile
$data >> $finalFile
}

generateTemp1
mergeData
addMissingSources
addInternetNode
removeSillyCommans
mergeScriptData
