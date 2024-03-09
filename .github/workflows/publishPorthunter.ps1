$modulePath = "$PSScriptRoot\porthunter\"
Write-Host "Getting ready to publish it..."
Publish-Module -path $modulePath -NuGetApiKey $Env:apiporthunter