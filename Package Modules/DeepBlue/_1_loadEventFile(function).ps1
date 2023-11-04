
function Create-FilterEvents ($file, $logname)
{
    # Return the Get-WinEvent filter
    $sys_events = "7030,7036,7045,7040,104"
    $sec_events = "4688,4672,4720,4728,4732,4756,4625,4673,4674,4648,1102"
    $app_events = "2"
    $applocker_events = "8003,8004,8006,8007"
    $powershell_events = "4103,4104"
    $sysmon_events = "1,7,8"
    $wmi_events = "5861"
    
    $filter = @{
        Path = $file
        ID = @()
    }

    switch ($logname) {
        "Security" {
            $filter.ID = $sec_events -split ","
        }
        "System" {
            $filter.ID = $sys_events -split ","
        }
        "Application" {
            $filter.ID = $app_events -split ","
        }
        "Applocker" {
            $filter.LogName = "Microsoft-Windows-AppLocker/EXE and DLL"
            $filter.ID = $applocker_events -split ","
        }
        "Powershell" {
            $filter.LogName = "Microsoft-Windows-PowerShell/Operational"
            $filter.ID = $powershell_events -split ","
        }
        "Sysmon" {
            $filter.LogName = "Microsoft-Windows-Sysmon/Operational"
            $filter.ID = $sysmon_events -split ","
        }
        "WMI-Activity" {
            $filter.LogName = "Microsoft-Windows-WMI-Activity/Operational"
            $filter.ID = $wmi_events -split ","
        }
        default {
            Write-Host "Invalid logname: $logname"
            Exit 1
        }
    }



    return $filter
}



function Load-FilterEvents ($file, $logname) {
    $filter = Create-Filter -file $file -logname $logname
    $events = Get-WinEvent -FilterHashtable $filter
    return $events
    }

$events = Load-FilterEvents -file '.\security logs.evtx' -logname "Security"
