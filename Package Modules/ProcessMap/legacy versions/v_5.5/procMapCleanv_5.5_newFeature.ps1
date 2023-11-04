$ErrorActionPreference = "Stop"
#-------------------------------------------- VARIABLES DRAW.IO -------------------------------------
$imageLevel1 = "https://cdn4.iconfinder.com/data/icons/mexican-curious-1/400/emojiDF_angry_comp-512.png"
$imageLevel2 = "https://cdn2.iconfinder.com/data/icons/data-organization-and-management-7/64/vector_525_04-512.png"
$imageLevel3 = "https://cdn0.iconfinder.com/data/icons/call-center-and-service-2/32/06-Question-512.png"
$imageLevel4 = "https://cdn2.iconfinder.com/data/icons/module/512/nfc-chip-chipset-pay-service-mobile-512.png"
$imageLevel5 = "https://cdn0.iconfinder.com/data/icons/computer-technology-16/5083/2-Search-512.png"
$imageInternet = "https://cdn3.iconfinder.com/data/icons/network-and-communications-8/32/network_web_internet_network-512.png"
$label1 = '%objectUser%'
$label4 = '<i style="color:#004d80;">%objectUser%</i>'
$labelUnknownFile  = '%objectUser%'
$imageUnknown = "https://cdn2.iconfinder.com/data/icons/module/512/nfc-chip-chipset-pay-service-mobile-512.png"
$imageSigned = "https://cdn-icons-png.flaticon.com/128/1949/1949225.png"
$labelsigned= '%objectUser%<br>Signed:<i style=color:blue;>%signed%</i>'
#-----------------------------------------------DRAW.IO FIle TYPE ICONS -------------------------------------
###############################################################################################################
$global:imageExe ="https://cdn0.iconfinder.com/data/icons/100-file-document-format-type/48/EXE-512.png"
$global:imageDll = "https://cdn2.iconfinder.com/data/icons/file-types-3/32/file_DLL-512.png"
$global:imagePs1 = "https://cdn2.iconfinder.com/data/icons/azure-1/512/Console-512.png"



#--------------------------------------------------- GLOBAL VARIABLES -------------------------------------
$scriptPath = $MyInvocation.MyCommand.Path
$wd= [System.IO.Path]::GetDirectoryName($scriptPath) ##old version  "$wd ="C:\Users\user.name\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram\ProcessMap\v_04"

$objectFilePathList = @()
$dstList = @()
$sourceList = @()

##----------------Open File Dialog function
Add-Type -AssemblyName System.Windows.Forms
$userProfile = $env:USERPROFILE
$Path =$wd
$global:filePath = ""
#-------------------------------------------------- TEMP FILES -------------------------------------
$temp1 = "$wd\temp1.csv"
$cookedFile = "$wd\cooked.csv"
$cleanFile = "$wd\cleanFile.csv"
$finalFile = "$wd\finalScript.txt"
#------------------------------------------------------------------------
#####LEGACY FUNCTIONS NOT BEING USED
function removeSillyCommans{
$data = Import-Csv $cookedFile

forEach ($row in $data) {
    $row.Psobject.Properties | ForEach-Object {
    $_.value = $_.value -replace'\["|\"]'
    if($_.value -like "*,*") {$_.value = ""}
        }
}
$data | Export-Csv $cookedFile -NoTypeInformation
} #removeSillyCommans kind not working nor its needed yet
###------------------
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
function generateTemp1($debugger){

$track = @()
$trackHost =@()
$export = @()

foreach ($x in $data) {
    $objectUser = $x.objectUser
    $processSigner = $x.processSigner
    $processCmd =$x.processCmd
    if($objectUser -notlike $nul -or $objectUser -notlike ""){
    $trackString = "$($x.objectUser) --> $($x.parentFilePath) --> $($x.processFilePath) --> $($x.objectFilePath)"
    }
    # Check if the trackString is not already in the $track array
    if ($trackString -notin $track) {
        # Add the trackString to the $track array
        $track += $trackString
        #$trackString
        ######Process Records here Display the trackString in Cyan
       # Write-Host $trackString -ForegroundColor Cyan


###------------------------------------------

        #Add PARENT
        $newRow = [PSCustomObject]@{
            objectUser = $x.objectUser
            parentFilePath = $x.parentFilePath
            processFilePath = ""
            objectFilePath = ""
            processCmd = $x.processCmd
            fill = "#ccffe6"
            stroke = "#009900"
            shape = "ellipse"
            label = $label1   
            image = $imageLevel1
            signed= $processSigner
      
        }
        $export += $newRow
        #Add CHILD
        $newRow = [PSCustomObject]@{
            objectUser = $x.parentFilePath
            parentFilePath = ""
            processFilePath = $x.processFilePath
            objectFilePath = ""
            processCmd = ""
            fill = "#ffe6ff"
            stroke = "#d9d9d9"
            shape = "ellipse"
            label = $label1   
            image = $imageLevel2
            signed = $processSigner
      
        }
        $export += $newRow
        #Add CHILDCMD
        if($processSigner -like $null -or $processSigner -like ""){$labelSelected = $labelUnknownFile;$imageSelected =$imageUnknown}
        else{$labelSelected = $labelsigned;$imageSelected = $imageSigned}
        $emp
        $newRow = [PSCustomObject]@{
            objectUser = $x.processFilePath
            parentFilePath = ""
            processFilePath = ""
            objectFilePath = $x.objectFilePath
            processCmd = $x.processCmd
            fill = "#dae8fc"
            stroke = "#6c8ebf"
            shape = "ellipse"
            label = $labelSelected   
            image = $imageSelected
            signed = $x.processSigner
     
        }
        $export += $newRow
        $dstList += $x.parentFilePath
        $objectFilePathList += $x.objectFilePath
        $sourceList += $x.objectUser

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
if ($debugger){
$x = Import-Csv $temp1
$x[3] | Select-Object objectUser, processCmd
}
else{}
}
function mergeData($debugger){

Import-Csv $temp1 | 
Group-Object objectUser | 
ForEach-Object {
    [PsCustomObject]@{
        objectUser = $_.name | Select-Object -First 1
        parentFilePath = ($_.Group.parentFilePath | Sort-Object -Unique) -join ','  -replace '^,'
        processFilePath = ($_.Group.processFilePath | Sort-Object -Unique) -join ',' -replace '^,'
        objectFilePath = ($_.Group.objectFilePath | Sort-Object -Unique) -join ',' -replace '^,'
        processCmd = ($_.Group.processCmd | Sort-Object -Unique) -join ',' -replace '^,'
            fill = $_.Group.fill | Select-Object -First 1
            stroke = $_.Group.stroke | Select-Object -First 1
            shape = $_.Group.shape | Select-Object -First 1
            label = $_.Group.label | Select-Object -First 1
            image = $_.Group.image | Select-Object -First 1
            signed = ($_.Group.signed | Where-Object { $_ -notlike $null -or $_ -notlike "" }| Select-Object -First 1)   
    }

} | 
Export-Csv $cookedFile -NoTypeInformation

if($debugger){
Import-Csv $cookedFile | Format-Table
}
Else{}
}
function addMissingDestinations($debugger){
$MissingList = Import-Csv $temp1
#import all sources from temp1 file
$sources = $MissingList.objectUser

#For Each objectFilePath that is not yet added to the objectUser list, add
#This function is to create the unique cell on the Draw.io
$childCmdMissing = Import-Csv $temp1 | 
Where-Object {$_.objectFilePath -notlike $null -or 
$_.objectFilePath -notlike "" -and $_.objectFilePath -notin $sources}
$childRepetitionTracker =@() #this function was adding double records, this list is to keep track of them and avoid
$newRowList = @()
    forEach($x in $childCmdMissing){
        
        if($x.objectFilePath -notin $childRepetitionTracker) {
        $tracker = $x.objectFilePath
        $childRepetitionTracker += $tracker
       
        if($tracker -like "*.exe"){$selectImage = $global:imageExe}
        elseif($tracker -like "*.dll"){$selectImage = $global:imageDll}
        elseif($tracker -like "*.ps1*"){$selectImage = $global:imagePs1}
        else{$selectImage = $imageLevel4}
        $row =      [PsCustomObject]@{
                objectUser = $x.objectFilePath
                parentFilePath = ""
                processFilePath = ""
                objectFilePath = ""
                processCmd = $x.processCmd
                fill = " #e6e6e6"
                stroke = "#0d0d0d"
                shape = "ellipse"
                label = $label4
                image = $selectImage
                signed = $x.processSigner 

        }
        $newRowList += $row
                }#-close if
    }#-close for Each
$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation

if($debugger){
Import-Csv $cookedFile | Format-Table
}
}
function addMissingProcessCmd($debugger){
$MissingList = Import-Csv $temp1
#import all sources from temp1 file
$processCmd = $MissingList.processCmd

#Imports Temp1, to focus on the processCmd
$processCmdMissing = Import-Csv $temp1 | Where-Object {$_.processCmd -notlike $null -or $_.processCmd -notlike ""}
$processTracker =@() #this function was adding double records, this list is to keep track of them and avoid
$newRowList = @()
    forEach($x in $processCmdMissing){

        
        if($x.processCmd -notin $processTracker) {
        $tracker = $x.processCmd
        $processTracker += $tracker
        if($tracker -like "*.exe"){$selectImage = $global:imageExe}
        elseif($tracker -like "*.dll"){$selectImage = $global:imageDll}
        elseif($tracker -like "*.ps1*"){$selectImage = $global:imagePs1}
        else{$selectImage = $imageLevel4}
        $row =      [PsCustomObject]@{
                objectUser = $x.processCmd
                parentFilePath = ""
                processFilePath = ""
                objectFilePath = ""
                processCmd = ""
                fill = "#e6e6e6"
                stroke = "#0d0d0d"
                shape = "ellipse"
                label = $label4
                image = $selectImage
                signed = $x.processSigner 

        }
        $newRowList += $row
                }#-close if
    }#-close for Each
$newRowList | Export-Csv -Append $cookedFile -NoTypeInformation

if($debugger){
Import-Csv $cookedFile | Format-Table
}
}
function mergeScriptData{
# Import the CSV file and filter the data and Export the filtered data to a new CSV file
$data = Import-Csv $cookedFile | Where-Object {($_.objectUser -ne $null) -and ($_.objectUser -ne "")}
$data | Export-Csv $cleanFile -NoTypeInformation

$data = Get-Content $cleanFile
$script = Get-Content "$wd\drawIo.txt"
$script > $finalFile
$data >> $finalFile

Get-Content "$finalFile" | Set-Clipboard
}

function cleanUp {
Remove-Item $temp1
Remove-Item $cookedFile
Remove-Item $cleanFile
}

function run{
Write-Host "[START OF SCRIPT]" -ForegroundColor Black -BackgroundColor Blue

Write-Host "Please make sure the file has the following headers" -BackgroundColor Black -ForegroundColor Yellow
Write-Host '"objectUser","parentFilePath","processFilePath","objectFilePath",processSigner'-BackgroundColor Black -ForegroundColor Yellow


Try {OpenFile
$data = Import-Csv $global:filePath

generateTemp1 
Write-Host "[SUCCESS] Generating Temp1 file..." -ForegroundColor Gray;sleep .5

mergeData 
Write-Host "[SUCCESS] Merging the columns together..." -ForegroundColor Gray;sleep .5

addMissingDestinations
addMissingProcessCmd -debugger $true
Write-Host "[SUCCESS] Adding Draw.IO components.." -ForegroundColor Gray;sleep .5


mergeScriptData
Write-Host "[SUCCESS] Sprinkling a bit of magic.." -ForegroundColor Gray;sleep 1

Try{
    Write-Host "[ INFO ]  Deleting Temporary files.." -ForegroundColor Gray; sleep 1
    #cleanUp 
    Write-Host "[SUCCESS] Deleting Temporary files" -ForegroundColor Gray

}#close try
Catch{Write-Host "[ERROR] - Could not delete temporary files, please delete them manually" -ForegroundColor Red}


Write-Host "[SUCCESS] Script finished running`n" -ForegroundColor Gray
Write-Host "[SUCCESS] - Script saved to Clipboard! - Ready to paste Draw.IO"-ForegroundColor Green
Write-Host "[INSTRUCTIONS] - Go to Draw.IO and paste your clipboard on 'Arrange --> Insert --> Advance --> CSV -->Import'" -ForegroundColor Yellow
Write-Host "[SUCCESS] ------------------------> Script file is also located on" -ForegroundColor Green
Write-Host $finalFile -ForegroundColor Yellow
Write-Host "[END OF SCRIPT]" -ForegroundColor Black -BackgroundColor Blue
}#-close try

Catch {Write-Host "An error occurred: $_"
    Write-Host "Please select a .csv file" -BackgroundColor Black -ForegroundColor Red
Write-Host "Please make sure the file has the following headers" -BackgroundColor Black -ForegroundColor red
Write-Host '"objectUser","parentFilePath","processFilePath","objectFilePath",processSigner' -BackgroundColor Black -ForegroundColor Yellow
    
    }

}

run

function runDebug{
$data = Import-Csv "C:\Users\paulo.bazzo\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram\ProcessMap\v_5.5_newFeature\scripts_bypass.csv"
generateTemp1 -debugger $true
mergeData -debugger $true
addMissingDestinations -debugger $true
addMissingProcessCmd -debugger $true
mergeScriptData
#cleanUp
}


