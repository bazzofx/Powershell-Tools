#Get list of all Windows Apps - Name or PackageFullName to install
Get-AppxPackage -AllUsers > /AllAppsList.txt

#Uninstall Azure VPN
Remove-AppxPackage Microsoft.SkypeApp_15.87.3406.0_x86__kzf8qxf38zg5c
Remove-AppxPackage Microsoft.SkypeApp_15.85.3409.0_x86__kzf8qxf38zg5c

#Install Azure VPN
#Get-AppxPackage -allusers *Microsoft.AzureVpn* #| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\