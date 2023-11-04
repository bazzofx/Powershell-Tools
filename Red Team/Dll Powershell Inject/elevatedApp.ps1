# Create a COM object
$comObject = New-Object -ComObject Shell.Application

# Start a process with elevated privileges
$comObject.ShellExecute("powershell.exe", "-NoExit -Command write-host 'testing';sleep 20", "", "runas", 1)
