$exe = Start-Process Notepad
$wsh = New-Object -ComObject Wscript.Shell 
$wsh.AppActivate("$exe")
Start-Sleep 2
$wsh.SendKeys("{TAB}")
$wsh.SendKeys({This-is-awesome})
#Hello[System.Windows.Forms.SendKeys]::SendWait("{TAB}")