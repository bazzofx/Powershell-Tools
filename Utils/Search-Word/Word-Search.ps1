$userProfile = $env:USERPROFILE
$dateToday =  get-date -Format "dd/MM/yyyy"
$path = ""
$log = ""
$array = @()
$Document = [string]
$pattern = ""
$fileExtension = [string]
$searchResult = [string]
$name = [string]
$file =$Document
$pwd = pwd
#-------VARs

function retrieveParameters{
    $global:pattern = Read-Host "What text is present on the file you are looking for?"
    $global:fileExtension = Read-Host "What is the file extension (docx,txt,pdf,xlsx..) ?"
    
    #------------------         Create Log File         -----------------------------------
$pattern = $global:pattern
$log = "$userProfile\Documents\Reports\$pattern Result-WordSearch $(get-date -f dd-MM-yyy).txt"
$global:log = $log
$path = "$userProfile\Documents\Reports\$pattern FileList $(get-date -f dd-MM-yyy).txt"
$global:path = $path
$checkPath = Test-Path $log
if ($checkPath -eq $false){
$newFile = New-Item $log}
Else{
Add-Content $global:log "------------->Starting log on $dateToday"
}
#--------------------------------------------------------------------------------
    
    }#get paraments from user input



function searchArray {
    Add-Content $log "------------->Starting log on $dateToday"
    Add-Content $log "                                                  Searching for the $global:pattern"
    Add-Content $log ""

Try{
    $global:searchResult = Get-ChildItem -Recurse -ErrorAction SilentlyContinue  -filter *.$global:fileExtension | ForEach-Object {$_.FullName}
    $global:name = Get-ChildItem -Recurse -ErrorAction SilentlyContinue  -filter *.$global:fileExtension | ForEach-Object {$_.Name}
    
    
    }
Catch{Write-Host "Something wrong happened while creating the file list array"}
} #-- Get the files and place them on a array


function checkFile{

    ForEach ($x in $global:searchResult) {
        $name = $global:name
        Write-host "The name of the file is ----------> $name"
        $row = New-Object PSObject
        $pattern = $global:pattern
        Write-Host "Analysing file $x" -ForegroundColor yellow
    
             Try{$result = findWord $x $pattern}
             Catch{}
             if ($result -eq "True")
                 {
                 Write-host ""
                 Write-Host "                  @@@@@@@@@---- WORD WAS FOUND ----@@@@@@@@@" -BackgroundColor green -ForegroundColor black
                 write-host "                      '$pattern' is present in the file" -ForegroundColor green
                 Write-Host "--->    '$x'" -ForegroundColor green
                 Write-Host "                  @@@@@@@@@---- WORD WAS FOUND ----@@@@@@@@@" -BackgroundColor green -ForegroundColor black 
                 Add-Content $log ""
                 Add-Content $log ""
                 Add-Content $log "--------------------------------------------------------------------------------------------------------------------------------"
                 Add-Content $log "              @@@@@@@@@---- WORD WAS FOUND ----@@@@@@@@@"
                 Add-Content $log "              '$global:pattern' is present in the file $name"
                 Add-Content $log "                 $x"
                 Add-Content $log "              @@@@@@@@@---- WORD WAS FOUND ----@@@@@@@@@"
                 Add-Content $log "--------------------------------------------------------------------------------------------------------------------------------"
                 Add-Content $log ""

                 }
                 
             else
                 {write-host "The words '$global:pattern' does NOT exist in the file $x" -ForegroundColor Red
                 Add-Content $log "--------------------------------------------------------------------------------------------------------------------------------"   
                 Add-Content $log "The words '$global:pattern does NOT exist in the file $x"}
        #--creates array to be added to the file     
        $row | Add-Member -MemberType NoteProperty -Name "Word Searched" -Value $global:pattern
        $row | Add-Member -MemberType NoteProperty -Name "File Location" -Value $x             
        $global:array += $row
        

        


    } #---------------------close ForEach


}#---Run findWord on each object inside the list SearchArray 

function findWord ([string]$file,[string]$FindText) {
 $Document = $x
 $MatchCase = $False
 $MatchWholeWord = $True
 $MatchWildcards = $False
 $MatchSoundsLike = $False
 $MatchAllWordForms = $False
 $Forward = $True
 $Wrap = $FindContinue
 $Format = $False

 $Word = New-Object -comobject Word.Application
 $Word.Visible = $False

 $OpenDoc = $Word.Documents.Open($Document)
 $Selection = $Word.Selection

 $Selection.Find.Execute(
  $FindText,
  $MatchCase,
  $MatchWholeWord,
  $MatchWildcards,
  $MatchSoundsLike,
  $MatchAllWordForms,
  $Forward,
  $Wrap,
  $Format
  
 )

 $OpenDoc.Close()
} #--------Open Word Doc and Search for $pattern $fileExtension

function releaseMemory{
 # release memory
 $Word = $null
 # call garbage collection
 [gc]::collect()
 [gc]::WaitForPendingFinalizers()
 $openDocs = Get-Process -Name WINWORD
 $openDocs.Kill()
 }#-- refresh the memory

function introduction{
sleep .4
cls
Write-Host "------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "You are about to perform a word search on the following location:" -foreground yellow -BackgroundColor Black
Write-Host ""
Write-Host $pwd -ForegroundColor Yellow
Write-Host ""
Write-Host "If you want to search for the pattern on a different location `nplease change directories and run the script again." 
Write-Host "------------------------------------------------------------------" -ForegroundColor Yellow 
Write-host ""
Write-host ""
Write-host ""
Write-host ""
Write-Warning "After the script is finish running it will close all openned Word Documents, save your work now!!"
Write-host ""
Write-host ""
}#- makes it look good

function footer{
Write-Host "------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "                        Search completed                         " -BackgroundColor yellow -ForegroundColor Black
Write-Host ""
Write-Host "        Please check the .log file for the final results        " -ForegroundColor yellow
Write-Host ""
Write-Host "        Successful results for .$global:fileExtension files  containing the pattern '$global:pattern' are saved in the following location" -ForegroundColor yellow
Write-Host "        $path" -foreground Yellow
Write-Host "------------------------------------------------------------------" -ForegroundColor Yellow
}#- makes it look good

function createLog{$global:array | Export-Csv -Path $global:path -NoTypeInformation
} #-guess what this does..

function cleanup-File{
move "$userProfile\Documents\Reports\Result-WordSearch $(get-date -f dd-MM-yyy).txt" "$userProfile\Documents\Reports\$global:pattern Result-WordSearch $(get-date -f dd-MM-yyy).txt"

}


function Search-Word($global:pattern, $global:fileExtension){
introduction
if ($global:pattern -eq $null -and $global:fileExtension -eq $null){retrieveParameters}
searchArray
checkFile
footer
createLog
#cleanup-File
releaseMemory


} #--Main Function

Search-Word