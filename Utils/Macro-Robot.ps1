﻿<#
Instructions
To use find the position of the mouse more efficienty use a software called.
MPos - Mouse Position Tracker

For information on how to use the keyboard events please check the manual on 
# Read Manual Here ----> https://ss64.com/vb/sendkeys.html
#>

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


function get-ready {
Write-Host "Getting ready in 5" -ForegroundColor red
sleep -seconds 4
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
function wait{
sleep -Milliseconds 250
}
function waitLong {
sleep -Milliseconds 4000
}
function robot-brain
{
$x = Get-Clipboard

Write-Host " -    +      -START OF SCRIPT-      +      - " -ForegroundColor black -BackgroundColor green
Write-Host "   -    -   Script Run Count: $global:count   -       -  " -ForegroundColor Black -BackgroundColor green
Write-Host ""
Write-Host "        Opening Profile P..." -ForegroundColor green
Add-Content $log "-------------------------STARTING SCRIPT-------------------------"
Add-Content $log ""

$wsh.SendKeys("^{c}")
$x = Get-Clipboard
Write-Host "[START] Updating DBS CHECK for $x"
wait
$wsh.SendKeys("%{TAB}") #press alt TAB # Read Manual Here ----> https://ss64.com/vb/sendkeys.html
wait
[Clicker]::LeftClickAtPoint(61,388)
wait
$wsh.SendKeys("^{a}") # press Ctrl+a
wait
$wsh.SendKeys("^{v}")
wait
$wsh.SendKeys("{ENTER}")
waitLong
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{RIGHT}")
wait
$wsh.SendKeys("{RIGHT}")
wait

$wsh.SendKeys("^{c}")
$x = Get-Clipboard
wait
$wsh.SendKeys("%{TAB}")
wait
[Clicker]::LeftClickAtPoint(844,300) # click on mouse
wait
$wsh.SendKeys("^{v}")
Write-Host "[START] Updating Form Reference $x"
wait
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{RIGHT}")
wait
$wsh.SendKeys("^{c}")
$x = Get-Clipboard
wait
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{TAB}")
#[Clicker]::LeftClickAtPoint(852,351)
wait
$wsh.SendKeys("^{v}")
Write-Host "[START] Updating Date Form Issue $x"
wait
$wsh.SendKeys("{TAB}") #
#[Clicker]::LeftClickAtPoint(906,396)
wait
$wsh.SendKeys("^{v}")
wait
[Clicker]::LeftClickAtPoint(868,436)
wait
$wsh.SendKeys("{E}")
wait
$wsh.SendKeys("{ENTER}")
wait
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{RIGHT}")
wait
$wsh.SendKeys("^{c}")
$x = Get-Clipboard
wait
$wsh.SendKeys("%{TAB}")
wait
wait
$wsh.SendKeys("{TAB}") # Date Discl ISSUED
#[Clicker]::LeftClickAtPoint(881,484)
waitLong
$wsh.SendKeys("^{v}")
Write-Host "[START] Updating Date Disclousure issued $x"
wait
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{RIGHT}")
wait
$wsh.SendKeys("^{c}")
$x = Get-Clipboard
wait
$wsh.SendKeys("%{TAB}")
wait
#[Clicker]::LeftClickAtPoint(856,529)
$wsh.SendKeys("{TAB}") # disclousure number
wait
wait
$wsh.SendKeys("^{v}")
Write-Host "[START] Updating Disclousure Number $x"
wait
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{RIGHT}")
wait
$wsh.SendKeys("^{c}")
wait
$wsh.SendKeys("%{TAB}")
wait
Write-Host "......"
#[Clicker]::LeftClickAtPoint(852,579)
$wsh.SendKeys("{TAB}") #renewal date
wait
$wsh.SendKeys("^{v}")
wait
[Clicker]::LeftClickAtPoint(920,636) # click save
Write-Host "Saving..."
wait
wait
$wsh.SendKeys("%{TAB}")
wait
$wsh.SendKeys("{RIGHT}")
wait
$wsh.SendKeys("{Y}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{LEFT}")
    wait
    $wsh.SendKeys("{DOWN}")

Add-Content $log "Script run completed"

}



function run {
robot-brain
}

get-ready


#THis For loop will run 100 times
For ($i=0;$i -le 100;$i++)
{
run
$global:count += 1
}

            