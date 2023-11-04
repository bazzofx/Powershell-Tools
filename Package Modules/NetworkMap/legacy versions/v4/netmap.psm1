$global:drawioScript = @"
## Habit Tracker UML use case diagram
# label: <i style="fontSize:16;"> ip:%ruleName%</i><br>hostName:%hostName%<br><i style="color:gray;">DNS:%peerHost%</i><br>
## style: shape=%shape%;rounded=1;fillColor=%fill%;strokeColor=%stroke%;
# style: label;image=%image%;whiteSpace=wrap;html=1;rounded=1;fillColor=%fill%;strokeColor=%stroke%;fontSize=16
# namespace: csvimport-
##fromlabel + sourcelabel + label + tolabel + targetlabel
# connect: {"from":"dst", "to":"source","invert": false,"fromlabel":"%connectionLegend%","sourcelabel":"%connectionLegend%", \
#"style":"fontSize=18;curved=1;endArrow=blockThin;endFill=3;"}
# connect: {"from":"dst2", "to":"source","label":"%connectionLegend%", "style": \
#             "fontSize=18;curved=1;endArrow=blockThin;endFill=1;dashed=1;"}
# connect: {"from":"dst3", "to":"source","sourcelabel":"%connectionLegend%",  "style": \
#            "fontSize=18;curved=1;endArrow=blockThin;endFill=1;dashed=1;"}
# connect: {"from":"dst4", "to":"source","sourcelabel":"%connectionLegend%", "style": \
#            "fontSize=18;curved=1;endArrow=blockThin;endFill=1;dashed=1;"}
# connect: {"from":"dst5", "to":"source","sourcelabel":"%connectionLegend%","targetlabel":"%connectionLegend%",  "style": \
#            "fontSize=18;curved=1;endArrow=blockThin;endFill=1;dashed=1;strokeColor=#1a75ff"}
# wsourceth: auto
# height: auto
# padding: 5
# ignore: shape,fill,stroke,dst,image
# nodespacing: 40
# levelspacing: 120
# edgespacing: 40
# layout: horizontalflow
## CSV data starts below this line
"@


#------------------------ GLOBAL VARIABLES$global:filePath
$scriptPath = $MyInvocation.MyCommand.Path
$wd= [System.IO.Path]::GetDirectoryName($scriptPath) ##old version  #$wd = "C:\Users\user.name\location\folder\"

##----------------Open File Dialog function
Add-Type -AssemblyName System.Windows.Forms
$userProfile = $env:USERPROFILE
$Path ="$userProfile\Downloads"
$global:filePath = ""
function OpenFile{
        
        $FileDialogObject = [System.Windows.Forms.OpenFileDialog]
 # Create Object and add properties

        
        $OpenFileDialog = New-Object $FileDialogObject
        $OpenFileDialog.InitialDirectory = $Path
        $OpenFileDialog.CheckPathExists = $true
        $OpenFileDialog.CheckFileExists = $true
        $OpenFileDialog.Title = "Load a XDR Report that contains at least the headers'dhost' and 'src'"
        $OpenFileDialog.Filter = "csv files (*.csv)|*.csv" #|All files (*.*)|*.*"

        $OpenFileDialog.ShowDialog()

        if ($openFileDialog.CheckFileExists -eq $true) {
            $filePath = $openFileDialog.FileName}
        $global:filePath =  $filePath
        }




#------------------------------------------------------------- TEMP FILES
$temp1 = "$wd\temp1.csv"
$cookedFile = "$wd\cooked.csv"
$finalFile = "$wd\finalFile.txt"


#--------------------------------------VARIABLES FOR DRAW.IO
$imageFireWall = "https://cdn1.iconfinder.com/data/icons/unigrid-phantom-security-vol-1/60/013_032_firewall_protection_security_defense_brick_wall_threat_fire-512.png"
$imageLevel1 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel2 = "https://cdn3.iconfinder.com/data/icons/server-rack/64/search-512.png"
$imageLevel3 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel4 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageLevel5 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageInternet = "https://cdn3.iconfinder.com/data/icons/network-and-communications-8/32/network_web_internet_network-512.png"
$label1 = 'ip:%source%<br>hostName:%hostName%<br><i style="color:gray;">DNS:%peerHost%</i><br><i style="color:red;">Rule:%ruleName%</i>'
$label2 = 'Destination<br><i style="color:green;">IP:%source%</i><br>Rule:%ruleName%'

#main function creates .csv file on DrawIO format 1st pass
function generateTemp1{

$track = @()
$trackHost =@()
$export = @()
$dstList = @()
$dstList2 =@()
$dstList3 = @()
$dstList4 = @()
$dstList5 = @()
foreach ($x in $data) {
    $trackString = "$($x.src) --> $($x.dhost)"
    $source = $x.src
    $connectionLegend = $x.app + " " + $x.act + " " + $x.deviceDirection
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

#Combine same rows of data into a single cell
function mergeData{

Import-Csv $temp1 | 
Group-Object source | 
ForEach-Object {
    [PsCustomObject]@{
        hostName = $_.Group.hostName | Select-Object -First 1
        source = $_.name | Select-Object -First 1
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
#not all destinations are added on the first pass
function addMissingDestinations{

$data = Import-Csv $temp1
#$allSources = @()
$allSources = $data.source
$missingOnes = @()
foreach($x in $data) {
if($x.dst -notin $allSources -and $x.dst -notin $missingOnes -and $x.dst -ne $null -and $x.dst -ne ""){
    $destination = $x.dst
    $hostName = $x.hostName
   $missingOnes +=  $x.dst
   $ruleName = $x.ruleName
   #debug #Write-Host " $destination added "; sleep 1
    }
}
$newRowList = @()
forEach($x in $missingOnes){
 $row =      [PsCustomObject]@{
                hostName = ""
                source = $x
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
            ruleName = $ruleName
            connectionLegend = ""
            label = $label2 
        }
 $newRowList += $row
}

$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation

}
#adds a final Internet connection to the final destinations that dont have a 'from'
#does not mean 100% that they are connecting to the internet, it means a 'FROM' destination was not found on those IPs from the loaded data file.
function addInternetNode {
 $row =      [PsCustomObject]@{
                hostName = "Internet"
                source = "Internet"
                dst = ""
                dst2 = ""
                dst3 = ""
                dst4 = ""
                dst5 = "www"
                fill = "#80b3ff"
                stroke = "#1a75ff"
                shape = "circle"
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
#output has silly ',' on empty cells, this function removes them
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

#merge Draw.IO.txt with cooked.csv
function mergeScriptData{
$data = Get-Content $cookedFile
#$script = Get-Content "$wd\drawIo.txt"
$script = $global:drawioScript
$script > $finalFile
$data >> $finalFile
}

#delete temporary files from folder
function cleanUp {
Remove-Item $temp1
Remove-Item $cookedFile
Remove-Item $finalFile
}

function netmap{
Write-Host "NEW VERSION 2" -ForegroundColor Magenta
Write-Host "For better results please ensure your report.csv has the following headers" -ForegroundColor Yellow
Write-Host "hostName,dhost,remarks,src,peerHost,ruleName,shost,act,app,deviceDirection" -ForegroundColor Green
Try{OpenFile
$data = Import-Csv $global:filePath
$check = $true
Write-Host "File loaded successfully" -ForegroundColor Green;sleep 1}
Catch{Write-Host "Please select a file to ingest" -ForegroundColor Yellow}
if($check){
Write-Host "[START SCRIPT] -----Generating Diagram Script`n"  -ForegroundColor Black -BackgroundColor Yellow
generateTemp1
mergeData
addMissingDestinations
addInternetNode
removeSillyCommans
mergeScriptData
Write-Host "[SUCCESS] -----Script file generated, located on" -ForegroundColor Green
Write-Host "$wd\finalFile.txt" -ForegroundColor Yellow
Get-Content "$wd\finalFile.txt" | Set-Clipboard
sleep -seconds 2;
Try{cleanup}Catch{Write-Host "could not clean up temporary files"}
Write-Host "[SUCCESS] -----Script saved to clipboard - ready to paste Draw.IO`n"-ForegroundColor Green
Write-Host "[END SCRIPT] -----Script Completed" -ForegroundColor Black -BackgroundColor Yellow
}
else{Write-Host "Please select a .csvfile to ingest" -ForegroundColor Yellow}
}

Export-ModuleMember -Function netmap