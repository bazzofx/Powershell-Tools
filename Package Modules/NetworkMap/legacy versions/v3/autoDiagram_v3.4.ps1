
$wd = "C:\Users\paulo.bazzo\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram\v3"

$data = Import-Csv "$wd\data.csv"



$temp1 = "$wd\temp1.csv"
$cookedFile = "$wd\cooked.csv"
$imageLevel1 = "https://cdn3.iconfinder.com/data/icons/server-rack/64/search-512.png"
$imageLevel2 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel3 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel4 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel5 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageInternet = "https://cdn3.iconfinder.com/data/icons/network-and-communications-8/32/network_web_internet_network-512.png"
$label1 = 'ip:%sourceLabel%<br>hostName:%hostName%<br><i style="color:gray;">DNS:%peerHost%</i><br><i style="color:red;">Rule:%ruleName%</i>'

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
    $connectionLegend = $x.app + " " + $x.act + $x.deviceDirection
    #$x.hostName ;sleep 1
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
            hostName = $x.hostName
            source = $x.src
            sourceLabel = $x.src
            dst = $x.dhost
            dst2 = ""
            dst3 = ""
            dst4 = ""
            dst5 = ""
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = $connectionLegend
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel1
            label = $label1
            

        }

        $export += $newRow
        $dstList += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -and $source -notin $dstList2) { 
#Write-Host "level 2" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            hostName = $x.hostName
            source = $x.src
            sourceLabel = $x.src
            dst = ""
            dst2 = $x.dhost
            dst3 = ""
            dst4 = ""
            dst5 = ""
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = $connectionLegend
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel2
            label = $label1
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -or $source -in $dstList2 -and $source -notin $dstList3) { 
#Write-Host "level 3" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            hostName = $x.hostName
            source = $x.src
            sourceLabel = $x.src
            dst = ""
            dst2 = ""
            dst3 = $x.dhost
            dst4 = ""
            dst5 = ""
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = $connectionLegend
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel3
            label = $label1
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
        $dstList3 += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -or $source -in $dstList2 -or $source -in $dstList3 -and $source -notin $dstList4) { 
#Write-Host "level 4" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            hostName = $x.hostName
            source = $x.src
            sourceLabel = $x.src
            dst = ""
            dst2 = ""
            dst3 = ""
            dst4 = $x.dhost
            dst5 = ""
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = $connectionLegend
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel4  
            label = $label1                           
        }

        $export += $newRow
        $dstList += $x.dhost
        $dstList2 += $x.dhost
        $dstList3 += $x.dhost
        $dstList4 += $x.dhost
###--------------------------------------------------
}
elseif($source -in $dstList -or $source -in $dstList2 -or $source -in $dstList3 -or $source -in $dstList4 -and $source -notin $dstList5) { 
#Write-Host "level 5" -ForegroundColor Yellow     
###------------------------------------------
        $newRow = [PSCustomObject]@{
            hostName = $x.hostName
            source = $x.src
            sourceLabel = $x.src
            dst = ""
            dst2 = ""
            dst3 = ""
            dst4 = ""
            dst5 = $x.dhost
            logged = $x.Logged
            remakrs = $x.remarks
            peerHost = $x.peerHost
            ruleName = $x.ruleName
            connectionLegend = $connectionLegend
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            image = $imageLevel5
            label = $label1
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
        hostName = $_.Group.hostName | Select-Object -First 1
        source = $_.name
        sourceLabel = $x.name
        dst = $_.Group.dst -join ','
        dst2 = $_.Group.dst2 -join ','
        dst3 = $_.Group.dst3 -join ','
        dst4 = $_.Group.dst4 -join ','
        dst5 = $_.Group.dst5 -join ','
            logged = $_.Group.Logged | Select-Object -First 1
            remakrs = $_.Group.remarks | Select-Object -First 1
            peerHost = $_.Group.peerHost | Select-Object -First 1
            ruleName = $_.Group.ruleName | Select-Object -First 1
            connectionLegend = $_.Group.ConnectionLegend | Select-Object -First 1
            fill = $_.Group.fill | Select-Object -First 1
            stroke = $_.Group.stroke | Select-Object -First 1
            shape = $_.Group.shape | Select-Object -First 1
            image = $_.Group.image | Select-Object -First 1
            label = $label1 | Select-Object -First 1
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
    $hostName = $x.hostName
   $missingOnes +=  $x.dst
   #debug #Write-Host " $destination added "; sleep 1
    }
}
$newRowList = @()
forEach($x in $missingOnes){
 $row =      [PsCustomObject]@{
                hostName = ""
                source = $x
                sourceLabel = $x
                dst = ""
                dst2 = ""
                dst3 = ""
                dst4 = ""
                dst5 = "Internet"
                fill = "#dae8fc"
                stroke = "#6c8ebf"
                shape = "ellipse"
                image = $imageLevel1
            logged = ""
            remakrs = ""
            peerHost = ""
            ruleName = ""
            connectionLegend = ""
            label = $label1 
        }
 $newRowList += $row
}

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation

}
function addInternetNode {
 $row =      [PsCustomObject]@{
                hostName = "Internet"
                source = "Internet"
                sourceLabel = ""
                dst = ""
                dst2 = ""
                dst3 = ""
                dst4 = ""
                dst5 = "www"
                fill = "#b3d1ff"
                stroke = "#1a75ff"
                shape = "ellipse"
                image = $imageInternet
                logged = ""
                remakrs = ""
                peerHost = ""
                ruleName = ""
                connectionLegend = "Outbound to the Internet"
                label = "The Internet" 
        }
 $newRowList += $row

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation
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
Write-Host "[SUCCESS] -----Script Completed" -ForegroundColor Green
Get-Content "$wd\finalFile.txt" | Set-Clipboard
Write-Host "Script saved to clipboard - ready to paste Draw.IO" -ForegroundColor Black -BackgroundColor Yellow