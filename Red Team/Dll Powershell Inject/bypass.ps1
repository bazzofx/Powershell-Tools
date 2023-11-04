$scriptContent = @"
Write-Host "UAC Bypass Successful!"
"@
"ou" > "1.txt"
"ou" > "2.txt"
$scriptContent | Out-File -FilePath "$wd\bypass.ps1" -Encoding ASCII