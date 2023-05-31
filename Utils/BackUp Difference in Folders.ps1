$today = Get-Date
$ErrorActionPreference = "Stop"
#----------------------- GLOBAL VARIABLES
$sourceFolder = "C:\Users\pb\Desktop\a"
$destinationFolder = "C:\Users\pb\Desktop\b"
$log = "C:\Users\pb\backuplog.log"
#----------------------- GLOBAL VARIABLES
# Function to recursively copy files and folders
Try{
function Copy-FilesRecursively {
    param(
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath
    )

    # Get all files and folders in the source path
    $items = Get-ChildItem -Path $SourcePath -Recurse

    # Iterate through each item
    foreach ($item in $items) {
        $relativePath = $item.FullName.Replace($SourcePath, "")
        $destinationPath = Join-Path -Path $DestinationPath -ChildPath $relativePath

        if ($item.PSIsContainer) {
            # If it's a folder, create the folder in the destination if it doesn't exist
            if (!(Test-Path -Path $destinationPath)) {
                New-Item -ItemType Directory -Path $destinationPath | Out-Null
                Add-Content $log "[SUCCESS] Created New Folder $relativePath" ###########{ADD LOG}##########
            }
        } else {
            # If it's a file, copy the file to the destination if it's modified or doesn't exist
            if (!(Test-Path -Path $destinationPath) -or ($item.LastWriteTime -ne (Get-Item -Path $destinationPath).LastWriteTime)) {
                Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                Write-Output "Copied file: $relativePath"
            }
        }
    }
}
# Get all files and folders in the source folder
$sourceItems = Get-ChildItem -Path $sourceFolder -Recurse
$totalItems = $sourceItems.Count
$currentItemCount = 0

Add-Content $log "Backup log starting ----> $today"    ###########{ADD LOG}##########
Add-Content $log ""                                    ###########{ADD LOG}##########
# Iterate through each item in the source folder
foreach ($item in $sourceItems) {
    $relativePath = $item.FullName.Replace($sourceFolder, "")
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $relativePath

    if ($item.PSIsContainer) {
        # If it's a folder, create the folder in the destination if it doesn't exist
        if (!(Test-Path -Path $destinationPath)) {
            New-Item -ItemType Directory -Path $destinationPath | Out-Null
        }
    } else {
        # If it's a file, copy the file to the destination if it's modified or doesn't exist
        if (!(Test-Path -Path $destinationPath) -or ($item.LastWriteTime -ne (Get-Item -Path $destinationPath).LastWriteTime)) {
            Copy-Item -Path $item.FullName -Destination $destinationPath -Force
            Write-Output "Copied file: $relativePath"
             Add-Content $log "[SUCCESS]  New File Added --> $relativePath" ###########{ADD LOG}##########
        }
    }

    $currentItemCount++
    $percentage = ($currentItemCount / $totalItems) * 100

    # Update the progress bar
    Write-Progress -Activity "Backing up files" -Status "Progress: $currentItemCount/$totalItems" -PercentComplete $percentage
}

# Check for new files in the root folder
$rootFiles = Get-ChildItem -Path $sourceFolder -File
foreach ($file in $rootFiles) {
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $file.Name


    if (!(Test-Path -Path $destinationPath)) {
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Output "New file: $($file.Name)"
        Add-Content $log "[SUCCESS]   Added New Files to $destinationPath" ###########{ADD LOG}##########
    }
} 
$today = Get-Date
Add-Content $log ""                                         ###########{ADD LOG}##########
Add-Content $log "[SUCCES] -   Backup completed successfully $today" ###########{ADD LOG}##########
Add-Content $log "-----------------------------------------------------------------------------------"
Write-Host "[SUCCES] -   Backup completed successfully $today" -ForegroundColor Green
}
Catch{Write-Host "[ERROR] Something went wrong during the backup." -ForegroundColor Red
      Write-Host $Error[0] -ForegroundColor Yellow
      Add-Content $log "[ERROR] Something went wrong during the backup." ###########{ADD LOG}##########
} 