 $file = ".\evtx\sliver-security.evtx"
 $file = ".\evtx\disablestop-eventlog.evtx"
function Create-FilterEvents ($file, $logname){
    # Return the Get-WinEvent filter
    #$all_events = "7030,7036,7045,7040,104,4688,4672,4720,4728,4732,4756,4625,4673,4674,4648,1102,2,8003,8004,8006,8007,1,7,8,5861,4648"
    $all_events  = "7030,7036,7045,7040,104,4688,4672,4720,4728,4732,4756,4625,5140,4673,4674,4648,1102,2,8003,8004,8006,8007,4648,1,8"
    $sys_events = "7030,7036,7045,7040,104"
    $sec_events = "4688,4672,4720,4728,4732,4756,4625,4673,4674,4648,1102"
    $app_events = "2"
    $applocker_events = "8003,8004,8006,8007"
    $powershell_events = "4688"
    $sysmon_events = "1,7,8"  #not included on all as it breaks the filter for some reason
    $wmi_events = "5861"      #not included on all as it breaks the filter for some reason
    $debug_events = "5140"
    
    $filter = @{
        Path = $file
        ID = @()
    }

    switch ($logname) {

                "all" {
            $filter.ID = $all_events -split ","
        }    
            "Debug" {
            $filter.ID = $debug_events -split ","
        }
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
        "sysmon" {
            #$filter.LogName = "Microsoft-Windows-Sysmon/Operational"
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
    $filter = Create-FilterEvents -file $file -logname $logname
    Try{
    $events = Get-WinEvent -FilterHashtable $filter
    }Catch{Write-Host "Failed load events" -ForegroundColor Red}
    return $events
    }
# --------------------------------------------------------


Load-FilterEvents $file -logname "system"