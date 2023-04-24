$ie = New-Object -Com "InternetExplorer.Application"
$urls = @("http://www.google.com","http://www.yahoo.com")
$ie.Visible = $true
CLS
write-output "Loading pages now..."
sleep -seconds 2
#Maximize IE window
$asm = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$ie.height = $screen.height
#Open webpages
foreach ($link in $urls) {
   $ie.Navigate2($link, 0x1000) 
}
#close first blank tab
$sa = New-Object -ComObject Shell.Application
$tab = $sa.windows() | Where {$_.Name -match 'Internet Explorer' -and     $_.LocationName -eq ''}
$tab.quit()