$modulePath = "$PSScriptRoot\porthunter\"
Write-Host $Env:apiporthunter
Publish-Module -path $modulePath -NuGetApiKey $Env:apiporthunter