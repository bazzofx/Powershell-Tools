﻿$ErrorActionPreference = "Stop"
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
#####                                     LEGACY FUNCTION NOT BEING USED
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
###-----------------------------------------------------------------------
##########################################################################################

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
 #subFunction located inside generateTemp1, used to retrieve only the last binary of an executable path. switches -v and -verbose
function carveString ($string) {
$pattern = "[^\\]+$"

    if ($string -match $pattern) {
      $captured= $matches[0]
    }
return $captured
}



function generateTemp1{
        param(
        [switch]$nouser = $false,
        [switch]$n = $false,
        [switch]$debugger = $false,
        [switch]$fullPath = $false,
        [switch]$f = $false)

$track = @()
$trackHost =@()
$export = @()

foreach ($x in $data) {
    if($fullPath -or $f) {
    #if verbose switch is active will show the entire path of the binaries
    $logged = $x.Logged
    $parentName = $x.parentName
    $parentCmd = $x.parentCmd
    $parentFilePath = $x.parentFilePath
    $osDescription = $x.osDescription
    $objectUser = $x.objectUser
    $processFilePath = $x.processFilePath
    $processCmd =$x.processCmd
    $objectFilePath = $x.objectFilePath
    $processSigner = $x.processSigner
    }
    else{
    #this is the default value and will show only the last executable binary on the active path
    $logged = carveString $x.Logged
    $parentName = carveString $x.parentName
    $parentCmd = carveString $x.parentCmd
    $parentFilePath = carveString $x.parentFilePath
    $osDescription = carveString $x.osDescription
    $objectUser = carveString $x.objectUser
    $processFilePath = carveString $x.processFilePath
    $processCmd = carveString $x.processCmd
    $objectFilePath = carveString $x.objectFilePath
    $processSigner = carveString $x.processSigner 
    
    }
    #comment this IF if, your report does not have 'objectUser' field
   #if main script is run without the -nouser switch perform a check if the objectUser header is empty and dont import the record.
    
    if(!($nouser -or $n)){
        if($objectUser -like $null -or $objectUser -like ""){
         $trackString = "$($objectUser) --> $($parentFilePath) --> $($processFilePath) --> $($objectFilePath)"
         Write-Host "I am here..."   
             }#close if
         Else{Write-Host "[INFO]  Skipping ROWS without a user associated with process" -ForegroundColor Yellow}
            
         }#close if on param switch $nouser
             #if -nouser switch is selected, do not perform the check if objectUser is empty.
    else {
        Write-Host "[INFO]  Importing Rows that dont have an user associated with it" -ForegroundColor DarkYellow
        $trackString = "$($objectUser) --> $($parentFilePath) --> $($processFilePath) --> $($objectFilePath)"
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
            objectUser = $objectUser
            parentFilePath = $parentFilePath
            processFilePath = ""
            objectFilePath = ""
            processCmd = $processCmd
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
            objectUser = $parentFilePath
            parentFilePath = ""
            processFilePath = $processFilePath
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
            objectUser = $processFilePath
            parentFilePath = ""
            processFilePath = ""
            objectFilePath = $objectFilePath
            processCmd = $processCmd
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
function mergeData{
        param([switch]$debugger = $false)

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
function addMissingDestinations{
        param([switch]$debugger = $false)

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
function addMissingProcessCmd{
        param([switch]$debugger = $false)

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
function showHelp {Write-Host "-----Script Manual Usage-----" -ForegroundColor Yellow
Write-Host "Please make sure the file has the following headers" -ForegroundColor Gray
Write-Host '"objectUser","parentFilePath","processFilePath","objectFilePath","processSigner"'  -ForegroundColor Yellow -BackgroundColor Black
Write-Host "If you run without any switches you will be creating a mindMap that will take the last binary of the path and use to make the connections." -ForegroundColor Gray
Write-Host "This is to make it easier to read the connections and to help keep the mindMap small, to see the full path on the mindMap use the switch -v" -ForegroundColor Gray
Write-Host "- By default the script will check which rows do not have a user associated with the command and if there is none it will skip the record." -ForegroundColor Gray
Write-Host "If you have a .csv file that you want to connect and do not have a user associated with it use the switch -n`n" -ForegroundColor Gray
Write-Host "-----COMMANDS-----" -ForegroundColor Yellow
Write-Host "-v or -verbose : This will make the connections using the full path from the file"
Write-Host "-n or -nouser  : Will allow to create mindMap for reports that do not have a user associated with the function row"
Write-Host "-h or -help    : Guess what this command does.."

Write-Host "-----EXAMPLES-----" -ForegroundColor Yellow
Write-Host "Just running bake command you will be prompt with a open file dialog box to choose your file,and will run with default switches, read above for more info"
Write-Host "bake`n" -ForegroundColor Gray
Write-Host "You can also import the report file directly passing the first argument as the path of your .csv report"
Write-Host "bake $userProfile\Downloads\report.csv`n"  -ForegroundColor Gray
Write-Host "You can use the switches together, you can specify the file path directly if not you will be prompted with a dialog box"
Write-Host "bake -fullPath -nouser`n"  -ForegroundColor Gray

}
function procmap{
    param(
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)] #this let file be the first parameter
        [string]$FilePath,
        [switch]$nouser = $false,
        [switch]$n = $false,
        [switch]$debugger = $false,
        [switch]$fullPath = $false,
        [switch]$f = $false,
        [switch]$h = $false,
        [switch]$help = $false
    )

if($help -or $h) {showHelp}
Else{
Write-Host "[START OF SCRIPT]" -ForegroundColor Black -BackgroundColor Blue

Write-Host "Please make sure the file has the following headers" -BackgroundColor Black -ForegroundColor Yellow
Write-Host '"objectUser","parentFilePath","processFilePath","objectFilePath",processSigner'-BackgroundColor Black -ForegroundColor Yellow


Try {

if($filePath){
$data = Import-Csv $filePath

} #if $filePath switch was used do not open file Dialog
Else{
OpenFile
$data = Import-Csv $global:filePath
}


if($nouser -or $n){generateTemp1 -nouser}
elseif($nouser -or $n -and $f -or $fullPath){generateTemp1 -nouser -fullPath}
elseif ($f -or $fullPath){generateTemp1 -fullPath}
else{generateTemp1}

                    Write-Host "[SUCCESS] Generating Temp1 file..." -ForegroundColor Gray
                    Start-Sleep -Seconds 1

mergeData 
                    Write-Host "[SUCCESS] Merging the columns together..." -ForegroundColor Gray
                    Start-Sleep -Seconds 1

addMissingDestinations
                    Start-Sleep -Seconds 2
addMissingProcessCmd
                    Write-Host "[SUCCESS] Adding Draw.IO components.." -ForegroundColor Gray
                    Start-Sleep -Seconds 1


mergeScriptData
                    Write-Host "[SUCCESS] Sprinkling a bit of magic.." -ForegroundColor Gray
                    Start-Sleep -Seconds 1

Try{
                    Write-Host "[ INFO ]  Deleting Temporary files.." -ForegroundColor Gray
                    Start-Sleep -Seconds 1
    cleanUp 
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


}#-close if checking if user selected -h or -help
    }#---close if Check if -help switch was selected








function runDebug{
Try{
#$data = Import-Csv "C:\Users\paulo.bazzo\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram\ProcessMap\v_5.6_newFeature\24hours_bypass.csv"
generateTemp1 -debugger $true
mergeData -debugger $true
addMissingDestinations -debugger $true
addMissingProcessCmd -debugger $true
mergeScriptData
#cleanUp
}
Catch{Write-Host "Come on mate.. you have do debug the debugger first..." -ForegroundColor Yellow}
}





