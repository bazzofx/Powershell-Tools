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
        else{$selectImage = $imageLevel4}
        $row =      [PsCustomObject]@{
                objectUser = $x.processCmd
                parentFilePath = ""
                processFilePath = ""
                objectFilePath = ""
                processCmd = ""
                fill = "#dae8fc"
                stroke = "#6c8ebf"
                shape = "ellipse"
                label = $label1
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