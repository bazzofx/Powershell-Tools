function Get-Modified {

$files = Get-ChildItem | Sort-Object -Property LastWriteTime
$files += @() #-- adds the result into an array so we can loop it.
$fileCount = $files.Count
$now = Get-Date

#------------------------------------------Variables here
Write-Host "These files were not modified in the last day" -ForegroundColor white -background green 

    for($i=0;$files[$i];$i++)
    {#-               -open for
    $alphaTime = $files[$i].LastWriteTime - $now
    
        if($alphaTime.Days -lt 0) {

            Write-Host $files[$i].Name "is clean" -ForegroundColor green
            Write-Host "Modified" $alphaTime.Days " days and " $alphaTime.Hours " hours ago"
            
                                  }
        else{} # else will be ran on the second for loop line 

     } #-              -close for     
     
     
Write-Host "These files are under suspicious and were modified in the last day" -ForegroundColor Yellow -BackgroundColor black 
#This script could be written without this second for statement, but I wanted to include line 24 so 
#I needed to create another separate check
    
    for($i=0;$files[$i];$i++)
    {#-               -open for 
    $alphaTime = $files[$i].LastWriteTime - $now
   
        if($alphaTime.Days -lt 0) {} # second check so we can run line 24 only once
        else{
            Write-Host "---------------"
            Write-Host $files[$i] "modified at" $files[$i].LastWriteTime -ForegroundColor red
        }  
        
        
    }#-              -close for
}#-                                    close of fucntion