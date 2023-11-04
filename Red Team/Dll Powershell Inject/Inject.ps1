$wd = $PSScriptRoot

function createDll{
# Create a malicious DLL (e.g., evil.dll)
$dllContent = @"
[DllImport("user32.dll", CharSet = CharSet.Auto)]
public static extern bool ShowWindow(int hWnd, int nCmdShow);

public void Execute()
{
    ShowWindow(0, 1); // Show a window
}
"@
$dllContent | Out-File -FilePath "$wd\evil.dll" -Encoding ASCII
}