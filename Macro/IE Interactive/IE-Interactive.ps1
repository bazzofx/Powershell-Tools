<# Manual
https://docs.microsoft.com/en-us/archive/msdn-magazine/2008/march/test-run-web-ui-automation-with-windows-powershell
https://www.youtube.com/watch?v=6KkK8kEghm4
https://github.com/bazzofx/Powershell/tree/main
#>

$web = "https://ce0622li.webitrent.com/ce0622li_web/itrent_wrd/run/etadm001gf.main"
#------$ie.Document | gm
# VARIABLES

#------Call IE Explorer MAXIMISED
Write-Host "Initializing Internet Explorer" -ForegroundColor Yellow
start chrome -WindowStyle maximized
Start-Sleep -seconds 1
$ie = (New-Object -COM "Shell.Application").Windows() | ? { $_.Name -eq "Internet Explorer" }
Write-Host "Navigating to Trent." -ForegroundColor Yellow
$ie.navigate("$web")


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




    While ($ie.Busy -eq $true){
    Start-Sleep 1
    Write-Host "Waiting for web page to load..."
    }
#------------ 1st Trent Page 
Start-Sleep 3
Write-Host "`nGetting Page Elements" -ForegroundColor Yellow

$btn = $ie.Document.IHTMLDocument3_getElementsByTagName("select") | ?{$_.Classname -eq "select-role-dropdown"}
$btn.value = ("7837303apF")
$sgn = $ie.Document.IHTMLDocument3_getElementsByTagName("input") | ?{$_.Classname -eq "submit"}
sleep 1
#$sgn.click()
Write-Host "Sending Click - Sign In " -ForegroundColor Yellow
[Clicker]::LeftClickAtPoint(855,555)
    While ($ie.Busy -eq $true){
    Start-Sleep 1
    Write-Host "Waiting for Sing in page to finish loading..." -ForegroundColor blue
    }
#------------2nd Trent Page
Start-Sleep 5
Write-Host "Successfully logged in " -ForegroundColor Yellow
Write-Host "Getting Page Elements" -ForegroundColor Yellow
$btn = $ie.Document.IHTMLDocument3_getElementsByTagName("div") | ?{$_.Classname -eq "notifications"}
$btn.click()
$btn2 = $ie.Document.IHTMLDocument3_getElementsByTagName("span") | ?{$_.Classname -eq "mdl-tabs__ripple-container mdl-js-ripple-effect"} 
$btn2.click()

#Remove-Variable -Name * -ErrorAction SilentlyContinue