$ErrorActionPreference = "Stop"
#-------------------------------------------- DRAW.IO SCRIPT-------------------------------------
$global:drawioScript = @"
## Track Executables file from XDR Report like a BOSS!!!
# label: <i style="fontSize:16;"> ip:%ruleName%</i><br>hostName:%hostName%<br><i style="color:gray;">DNS:%peerHost%</i><br>
## style: shape=%shape%;rounded=1;fillColor=%fill%;strokeColor=%stroke%;
# style: label;image=%image%;whiteSpace=wrap;html=1;rounded=1;fillColor=%fill%;strokeColor=%stroke%;fontSize=16
# namespace: csvimport-
##fromlabel + sourcelabel + label + tolabel + targetlabel
# connect: {"from":"processCmd", "to":"objectUser","invert": false, "style":"fontSize=18;curved=1;endArrow=blockThin;endFill=3;"}
# connect: {"from":"parentFilePath", "to":"objectUser","invert": false, "style":"fontSize=18;curved=1;endArrow=blockThin;endFill=3;"}
# connect: {"from":"processFilePath", "to":"objectUser","invert": false, "style":"fontSize=18;curved=1;endArrow=blockThin;endFill=3;"}
# connect: {"from":"objectFilePath", "to":"objectUser","invert": false, "style":"fontSize=18;curved=1;endArrow=blockThin;endFill=3;"}
# wsourceth: auto
# height: auto
# padding: 5
# ignore: shape,fill,stroke,image
# nodespacing: 30
# levelspacing: 120
# edgespacing: 40
# layout: horizontalflow
## CSV data starts below this line
"@
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
$global:imageJson = "https://cdn3.iconfinder.com/data/icons/file-document-format-folder-5/64/Document_file_extension_office_work_paper_information_folder_documentation_json-256.png"
$global:imageTxt = "https://cdn4.iconfinder.com/data/icons/files-110/64/txt-text-file-format-extension-document-archive-256.png"
$global:imageJs = "https://cdn4.iconfinder.com/data/icons/file-extension-names-vol-8/512/27-256.png"
$global:pdf = "https://cdn4.iconfinder.com/data/icons/smashicons-file-types-flat/56/28_-_PDF_File_Flat-256.png"
$global:macroFiles = "https://cdn3.iconfinder.com/data/icons/file-document-15/512/file_danger_alert_warning-256.png"
$global:imageIcon = "https://cdn1.iconfinder.com/data/icons/multimedia-and-entertainment-3/48/25-Photo-256.png"






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
#####                                     
function removeSillyCommans{
#LEGACY FUNCTION NOT BEING USED
$data = Import-Csv $cookedFile

forEach ($row in $data) {
    $row.Psobject.Properties | ForEach-Object {
    $_.value = $_.value -replace'\["|\"]'
    if($_.value -like "*,*") {$_.value = ""}
        }
}
$data | Export-Csv $cookedFile -NoTypeInformation
} #removeSillyCommans kind not working nor its needed, kept for future reference only. 
###-----------------------------------------------------------------------
##########################################################################################

function OpenFile{

$initialPath = Join-Path $env:USERPROFILE "Downloads"        
        $FileDialogObject = [System.Windows.Forms.OpenFileDialog]
 # Create Object and add properties

        
        $OpenFileDialog = New-Object $FileDialogObject
        $OpenFileDialog.InitialDirectory = $initialPath
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
        [switch]$debugger = $false,
        [switch]$simple = $false,
        [switch]$s = $false)

$track = @()
$trackHost =@()
$export = @()

foreach ($x in $data) {
    if($s -or $simple){
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
    Else{
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


        $trackString = "$($objectUser) --> $($parentFilePath) --> $($processFilePath) --> $($objectFilePath)"


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
        elseif($tracker -like "*.ps1*" -or $tracker -like "*.psm1*"){$selectImage = $global:imagePs1}
        elseif($tracker -like "*.json"){$selectImage = $global:imageJson}
        elseif($tracker -like "*.pdf"){$selectImage = $global:pdf}
        elseif($tracker -like "*.txt" -or $tracker -like "*.log"){$selectImage = $global:imageTxt}
        elseif($tracker -like "*.js"){$selectImage = $global:imageJs}
        elseif($tracker -like "*.docm" -or $tracker -like "*.xlxm" -or $tracker -like "*.pptm" -or $tracker -like "*.bat"){$selectedImage = $global:macroFiles}
        elseif($tracker -like "*.png" -or $tracker -like "*.jpeg" -or $tracker -like "*.jpg" -or $tracker -like "*.gif" -or $tracker -like "*.wepb"){$selectImage = $global:imageIcon}
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
        elseif($tracker -like "*.ps1*" -or $tracker -like "*.psm1"){$selectImage = $global:imagePs1}
        elseif($tracker -like "*.json"){$selectImage = $global:imageJson}
        elseif($tracker -like "*.pdf"){$selectImage = $global:pdf}
        elseif($tracker -like "*.txt" -or $tracker -like "*.log"){$selectImage = $global:imageTxt}
        elseif($tracker -like "*.js"){$selectImage = $global:imageJs}
        elseif($tracker -like "*.docm" -or $tracker -like "*.xlxm" -or $tracker -like "*.pptm" -or $tracker -like "*.bat"){$selectedImage = $global:macroFiles}
        elseif($tracker -like "*.png" -or $tracker -like "*.jpeg" -or $tracker -like "*.jpg" -or $tracker -like "*.gif" -or $tracker -like "*.wepb"){$selectImage = $global:imageIcon}

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
#$script = Get-Content "$wd\drawIo.txt"
$script = $global:drawioScript
$script > $finalFile
$data >> $finalFile

Get-Content "$finalFile" | Set-Clipboard
}

function cleanUp {
Remove-Item $temp1
Remove-Item $cookedFile
Remove-Item $cleanFile
Remove-Item $finalFile
}
function showHelp {Write-Host "                        ----- ProcMap Manual -----                              " -ForegroundColor Yellow -BackgroundColor Black
Write-Host "                 Please make sure the file has the following headers            " -ForegroundColor Yellow -BackgroundColor Black
Write-Host '"objectUser","parentFilePath","processFilePath","objectFilePath","processSigner"'  -ForegroundColor Yellow -BackgroundColor Black
Write-Host ""
Write-Host "If you run without any switches you will create the connection using the full path of the files" -ForegroundColor Gray
Write-Host "To make it easier to read the connections and to help keep the mindMap small, to see the full path on the mindMap use the switch -s" -ForegroundColor Gray
Write-Host ""
Write-Host "                        -----COMMANDS-----                       " -ForegroundColor Yellow -BackgroundColor Black
Write-Host "-s or -simple : This will make the connections using the full path from the file"
Write-Host "-h or -help    : Guess what this command does.."

Write-Host "                        -----EXAMPLES-----                       " -ForegroundColor Yellow -BackgroundColor Black
Write-Host "Just running bake command you will be prompt with a open file dialog box to choose your file,and will run with default switches, read above for more info"
Write-Host "procmap`n" -ForegroundColor Gray
Write-Host "You can also import the report file directly passing the first argument as the path of your .csv report"
Write-Host "procmap $userProfile\Downloads\report.csv"  -ForegroundColor Gray
Write-Host "procmap -filePath $userProfile\Downloads\report.csv`n"  -ForegroundColor Gray
Write-Host "To Simplify the output of the path use the -s or -simple switch" 
Write-Host "procmap -s "  -ForegroundColor Gray
Write-Host "procmap -s \.report.csv`n"  -ForegroundColor Gray

}
function procmap{
    param(
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)] #this let file be the first parameter
        [string]$FilePath,
        [switch]$debugger = $false,
        [switch]$simple = $false,
        [switch]$s = $false,
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

if ($s -or $simple){generateTemp1 -simple}
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
                    Write-Host "[SUCCESS] - Script saved to your Clipboard! - Ready to paste(Ctrl+V) into Draw.IO"-ForegroundColor Green
                    Write-Host "[INSTRUCTIONS] - Go to Draw.IO and paste your clipboard on 'Arrange --> Insert --> Advance --> CSV -->Import'" -ForegroundColor Yellow
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
Catch{Write-Host "Well.. Before you start debugging, you you have do debug the debugger first... " -ForegroundColor Yellow}
}





