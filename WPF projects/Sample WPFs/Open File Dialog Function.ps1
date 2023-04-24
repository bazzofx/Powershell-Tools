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
        $OpenFileDialog.Title = "Please feed me"
        $OpenFileDialog.Filter = "csv files (*.csv)|*.csv" #|All files (*.*)|*.*"

        $OpenFileDialog.ShowDialog()

        if ($openFileDialog.CheckFileExists -eq $true) {
            $filePath = $openFileDialog.FileName}
        $global:filePath =  $filePath
        }
OpenFile
$data = Import-Csv $global:filePath
$data