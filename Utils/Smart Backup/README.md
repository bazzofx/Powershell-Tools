# Backup Script Readme

This script performs a backup by recursively copying files and folders from a source folder to a destination folder. It also logs the backup process in a specified log file.

## Global Variables

- `$sourceFolder`: The path of the source folder from where files and folders will be copied.
- `$destinationFolder`: The path of the destination folder where files and folders will be copied.
- `$log`: The path of the log file that records the backup process.

## Function

### Copy-FilesRecursively

This function is responsible for recursively copying files and folders from the source path to the destination path.

## Backup Process

The backup process consists of the following steps:

1. Iterate through each item in the source folder.
   - If the item is a folder:
     - Create the folder in the destination if it doesn't exist.
   - If the item is a file:
     - Copy the file to the destination if it's modified or doesn't exist.
2. Check for new files in the root folder.
   - Copy any new files to the destination.
3. Log the backup process in the specified log file.

## Error Handling

In case of an error during the backup process, the script will log the error message and display a corresponding message.

Note: The log file will be appended with the backup progress and any encountered errors.

Please ensure to update the source folder, destination folder, and log file paths as per your requirements before running the script.