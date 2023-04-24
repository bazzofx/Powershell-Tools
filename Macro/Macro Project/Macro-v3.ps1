#----------------------Mouse Events Source Code - Start------------------------------
$cSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Clicker
{
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct INPUT
{ 
    public int        type; // 0 = INPUT_MOUSE,
                            // 1 = INPUT_KEYBOARD
                            // 2 = INPUT_HARDWARE
    public MOUSEINPUT mi;
}

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct MOUSEINPUT
{
    public int    dx ;
    public int    dy ;
    public int    mouseData ;
    public int    dwFlags;
    public int    time;
    public IntPtr dwExtraInfo;
}

//This covers most use cases although complex mice may have additional buttons
//There are additional constants you can use for those cases, see the msdn page
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

const int screen_length = 0x10000 ;

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
[System.Runtime.InteropServices.DllImport("user32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

public static void LeftClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}

public static void RightClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}

}
'@
Add-Type -TypeDefinition $cSource -ReferencedAssemblies System.Windows.Forms,System.Drawing
#----------------------Mouse Events Source Code - END ------------------------------
#----------------------Keyboards Events Source Code - Start------------------------------
# Read Manual Here ----> https://ss64.com/vb/sendkeys.html
$wsh = New-Object -ComObject Wscript.Shell 
$wsh.AppActivate("$exe")
#----------------------Keyboards Events Source Code - Start------------------------------

#------------------------ GLOBAL VARIABLES---------------------------------
$count = 1
$web = "https://ce0622li.webitrent.com/ce0622li_web/itrent_wrd/run/etadm001gf.main"
$search= "element details"
$search2 = "Update payroll element details"
$yes ="yes"
$file = "Element_Update $(get-date -f dd-MM-yyy).txt"
$path = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Trent Projects\In Progress\Payroll Element Overtime Sleep Rate Change\fixing data\LOGs\"
$log = "$path" + "$file"
$clipboard = "x"
#-------------------Create Log File
$checkPath = Test-Path $log
if ($checkPath -eq $false){
$newFile = New-Item $log}
Else{}
#--------------------------------------------------------------------------
function get-ready {
Write-Host "Getting ready in 5" -ForegroundColor red
sleep -seconds 1
Write-Host "Getting ready in 4" -ForegroundColor red
sleep -seconds 1
Write-Host "Getting ready in 3" -ForegroundColor yellow
sleep -seconds 1
Write-Host "Getting ready in 2" -ForegroundColor Yellow
sleep -seconds 1
Write-Host "Getting ready in 1" -ForegroundColor green
sleep -seconds 1
clear
}
function start-log{Add-Content $log "------------>                Starting Log File on               $(Get-Date)"
}
function page1{

Write-Host " -    +      -START OF SCRIPT-      +      - " -ForegroundColor black -BackgroundColor green
Write-Host "   -    -   Script Run Count: $global:count   -       -  " -ForegroundColor Black -BackgroundColor green
Write-Host ""
Write-Host "        Payroll Element Macro Starting..." -ForegroundColor green
Add-Content $log "-------------------------STARTING SCRIPT-------------------------"
Add-Content $log ""
[Clicker]::LeftClickAtPoint(75,125)

sleep -Milliseconds 500
[Clicker]::LeftClickAtPoint(130,160)
sleep -Milliseconds 500
[Clicker]::LeftClickAtPoint(60,200)
sleep -Milliseconds 500
$wsh.SendKeys("^{a}")
sleep -Milliseconds 500
$wsh.SendKeys($search) #--- open Element Details Page
sleep -Milliseconds 500
$wsh.SendKeys("{ENTER}")
sleep -Milliseconds 500
Write-Host "        [PAGE] Opening Element Page Details" -ForegroundColor yellow
Add-Content $log "        [PAGE] Opening Element Page Details"
[Clicker]::LeftClickAtPoint(44,291)
$wsh.SendKeys("%{TAB}")
sleep -seconds 1
    $wsh.SendKeys("^{c}")
    $copy = Get-Clipboard
$copy = $x
Write-Host "        Staring update for '$copy'" -ForegroundColor yellow
Add-Content $log "        Staring update for '$copy'"
sleep -seconds 2
$wsh.SendKeys("%{TAB}")
sleep -seconds 2
[Clicker]::LeftClickAtPoint(44,425)
sleep -Milliseconds 500
$wsh.SendKeys("^{a}")
sleep -Milliseconds 500
$wsh.SendKeys("^{v}") #--paste element name
sleep -seconds 1
$wsh.SendKeys("{ENTER}")
sleep 3
$wsh.SendKeys("%{TAB}")
sleep 2
$wsh.SendKeys("{RIGHT}")
sleep -Milliseconds 500
$wsh.SendKeys("^{c}") #-- copy new element name
$copy = Get-Clipboard

Write-Host "        Copying '$copy' New Name for Element" -ForegroundColor yellow
sleep -Milliseconds 500
$wsh.SendKeys("%{TAB}")
sleep 1
    For ($i=0;$i -le 4; $i++){
    sleep -Milliseconds 250
    $wsh.SendKeys("{TAB}")} #------ 4 Tabs
    
sleep -Milliseconds 500
$wsh.SendKeys("^{a}")
sleep -Milliseconds 500
$wsh.SendKeys("^{v}") #--paste Element Name name
Write-Host "    [ACTION] - '$copy' Updating Element Name" -ForegroundColor green
Add-Content $log "    [ACTION] - '$copy' Updating Element Name"
sleep -seconds 1
    For ($i=0;$i -le 10; $i++){
        sleep -Milliseconds 250
        $wsh.SendKeys("{TAB}")} # ---- 10 tabs
sleep -Milliseconds 500
$wsh.SendKeys("^{a}")
sleep -Milliseconds 500
$wsh.SendKeys("^{v}") #--paste Element Payslip name
Write-Host "    [ACTION] - '$copy' Updating Payslip Element Name" -ForegroundColor green
Add-Content $log "    [ACTION] - '$copy' Updating Payslip Element Name"
    For ($i=0;$i -le 11; $i++){
        sleep -Milliseconds 250
        $wsh.SendKeys("{TAB}")} # ---- 11 tabs
sleep -seconds 3
$wsh.SendKeys("{ENTER}") #--- save changes
sleep -seconds 4
Write-Host "    +[SAVING] - '$copy' Updates to Element Details" -ForegroundColor green
Add-Content $log "    +[SAVING] - '$copy' Updates to Element Details"
[Clicker]::LeftClickAtPoint(53,424)
sleep -seconds 3
$wsh.SendKeys("^{a}")
sleep -seconds 1
$wsh.SendKeys("^{v}") #--search for new updated element
sleep -seconds 1
$wsh.SendKeys("{ENTER}")
sleep -seconds 5
}
function page2{
$copy = Get-Clipboard

[Clicker]::LeftClickAtPoint(190,168)
sleep -seconds 2
[Clicker]::LeftClickAtPoint(120,200)
sleep -seconds 1
$wsh.SendKeys("^{a}")
sleep -seconds 1
$wsh.SendKeys($search2) #--- open Update Elements Page  
sleep -seconds 2
[Clicker]::LeftClickAtPoint(70,290)
sleep -seconds 1
Write-Host "        [PAGE] - Opening Update Payroll Element" -ForegroundColor yellow
Add-Content $log "        [PAGE] - Opening Update Payroll Element"
sleep -Milliseconds 500
    For ($i=0;$i -le 4; $i++){
        sleep -Milliseconds 300
        $wsh.SendKeys("{TAB}")} # ---- select All
Write-Host "    [ACTION] - Selecting  All Element Values" -ForegroundColor green
Add-Content $log "    [ACTION] - Selecting  All Element Values"
sleep -Milliseconds 500
$wsh.SendKeys("{ENTER}")
sleep -Milliseconds 500
    For ($i=0;$i -le 7; $i++){
        sleep -Milliseconds 300
        $wsh.SendKeys("{TAB}")} # ---- update all payslip
sleep -Milliseconds 1500
$wsh.SendKeys("{ENTER}")
Write-Host "    [ACTION] - Selecting  All Payrolls" -ForegroundColor green
Add-Content $log "    [ACTION] - Selecting  All Payrolls"
 sleep -seconds 2

        $wsh.SendKeys("{TAB}") # ---- Tab to Enter
Write-Host "    +[SAVING] - '$copy' Updates to Payroll" -ForegroundColor green
Add-Content $log "    +[SAVING] - '$copy' as New Payroll Element"
$global:clipboard = $copy
sleep -seconds 2
$wsh.SendKeys("{ENTER}")
sleep -seconds 3
[Clicker]::LeftClickAtPoint(71,124)
sleep -seconds 1
}
function page3 {
$wsh.SendKeys("{ENTER}")
sleep 3
}
function update-excel{
$wsh.SendKeys("^{c}")
$copy = Get-Clipboard

$wsh.SendKeys("%{TAB}")
sleep -seconds 2
$wsh.SendKeys("{RIGHT}")
sleep -Milliseconds 300
$wsh.SendKeys("{RIGHT}")
sleep -Milliseconds 300
$wsh.SendKeys($yes) #------------------------- update excel
Write-Host "        Updated Excel Element Name - 'yes'" -ForegroundColor yellow
sleep -Milliseconds 300
$wsh.SendKeys("{RIGHT}")
sleep -Milliseconds 300
$wsh.SendKeys($yes) #------------------------- update excel
Write-Host "        Updated Excel Payroll Update - 'yes'" -ForegroundColor yellow
sleep -seconds 2
$wsh.SendKeys("{LEFT}")
sleep -Milliseconds 300
$wsh.SendKeys("{LEFT}")
sleep -Milliseconds 300
$wsh.SendKeys("{LEFT}")
sleep -Milliseconds 300
$wsh.SendKeys("{LEFT}")
sleep -Milliseconds 300
$wsh.SendKeys("{DOWN}")
sleep -Milliseconds 2
$wsh.SendKeys("%{TAB}")
}
function footer{
$copy = Get-Clipboard
$copy = $x
write-host "this is x $x"
Write-Host "            Script Run Completed" -ForegroundColor yellow
Write-Host "---------------------------------------------------------" -Foreground green
Write-Host "-                    -END OF SCRIPT-                      -" -ForegroundColor red -BackgroundColor green
Write-Host ""
Add-Content $log "[END]   Script Run Completed" 
Add-Content $log "-----------------------------------------------------------------------------------" 
Add-Content $log ">>>>>>>>                           '$copy'                                  <<<<<<<<"
Add-Content $log ">>>>>>>>                              Renamed & Updated                        <<<<<<<<"
Add-Content $log "-----------------------------------------------------------------------------------" 
Add-Content $log "-------------------------------     END OF SCRIPT     -----------------------------"
Add-Content $log "-----------------------------------------------------------------------------------" 
Add-Content $log  ""

}


function main {
page3
}

get-ready
for ($i=0;$i-le 5000;$i++){
main

$global:count += 1

}