 # PSlookup
  ## Info
  This repository contains a PowerShell script that merges two CSV files based on a lookup key and a specified column. The merged result is outputted to a new CSV file, which is placed in the specified location. The script includes several functions that perform different actions, as explained below.

## Script Functions
### 1. emoji
This function generates an emoji based on a provided hex value, foreground color, and background color. It converts the hex value to an integer and then converts the Unicode point to a UTF-16 string.

### 2. Headers1
This function displays the headers of the first CSV file.

### 3. Headers2
This function displays the headers of the second CSV file.

### 4. pd
This is the main function that performs the CSV merge. It takes five arguments: filePath1, filePath2, column, lookupKey, and outLocation.

If the output file already exists, the function imports it and adds the specified header to the existing file. Otherwise, it imports the two input files, merges them based on the specified lookup key and column, and outputs the result to the specified location.

### 5. Pslookup
This function calls the pd function with a specified column and the other arguments already set to their default values. This simplifies the process of merging files based on a single column.

## Usage
To use this script, follow these steps:

Change the $wd variable to the working directory where your CSV files are located.
Set the $filePath1, $filePath2, and $outLocation variables to the paths of your input files and output file, respectively.
Set the $lookupKey variable to the column name that you want to use for the merge.
Run the Pslookup function with the column name that you want to merge on as an argument.
You can also call the pd function directly and provide the necessary arguments.

## Examples
The script includes several examples of how to use the Pslookup function with different columns. You can uncomment these examples and run them to see how the script works.

Note that you may need to modify the examples to match the column names in your CSV files.