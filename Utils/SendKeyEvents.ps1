$exe = Start-Process Notepad
$wsh = New-Object -ComObject Wscript.Shell 
$wsh.AppActivate("$exe")
Start-Sleep 2
$wsh.SendKeys("{TAB}")
$wsh.SendKeys({This-is-awesome})
#Hello[System.Windows.Forms.SendKeys]::SendWait("{TAB}")




# Start Notepad and capture the process object
#$proc = Start-Process Notepad
#$wsh.AppActivate("$proc")
# Start Notepad and capture the process object
Start-Process Notepad
# Wait for Notepad to start
Start-Sleep -Seconds 2

# Activate the Notepad window using the process object
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
[System.Windows.Forms.SendKeys]::SendWait("~Great stuff mate")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
[System.Windows.Forms.SendKeys]::SendWait("~Great stuff mate")


