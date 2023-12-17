clear-host
$art = "@
Art by Morfina                  Amidst the dice roll of a data leak....

               (( _______
     _______     /\O    O\           can the CEO let go of control. 
    /O     /\   /  \      \
   /   O  /O \ / O  \O____O\ ))              and  guide the company 
((/_____O/    \\    /O     /   
  \O    O\    / \  /   O  /                       
   \O    O\ O/   \/_____O/                               ....towards redemption and growth.
    \O____O\/ )) mrf      ))
  ((
                                  API by: https://cavalier.hudsonrock.com/docs
                                  Powershell by: Paulo bazzo - a.k.a CyberSamurai.co.uk
@" 
Write-Host "$art`n" -ForegroundColor Magenta
Write-Host "Type the domain name you would like to check" -ForegroundColor Yellow
$inputDomain = Read-Host "Domain name"
$response  = fetch -domain $inputDomain
$statusCode = $response.StatusCode

function fetch($domain){
$url = 'https://cavalier.hudsonrock.com/api/json/v2/search-by-domain/discovery'
$headers = @{
    'api-key' = 'ROCKHUDSONROCK'
    'Content-Type' = 'application/json'
}

$body = @{
    'domain' = $domain
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri $url -Method Post -Headers $headers -Body $body -UseBasicParsing
return $response
}

function printChoices {
Write-Host "---------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "Type the number of which domain you are interested in looking at" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "Remember, big powers bring big responsabilities`n" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "1      -      Employee Urls" -ForegroundColor Green
Write-Host "2      -      Client Urls"  -ForegroundColor Green
Write-Host "3      -      Third Party Urls"  -ForegroundColor Green
Write-Host "---------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "5      -      Dont show me, I am a bit scared of the result!"  -ForegroundColor Red
Write-Host "99     -      Close this application" -ForegroundColor Red



}
function sorry {Write-Host "I understand, sometimes its easier to look the other way..."}

function main{
if($statusCode-eq "200"){
printChoices
$choice = Read-Host "Selection"
switch($choice){
    "1"  {$choice = "employees_urls";$countSelection ="totalEmployees" }
    "2"  {$choice =  "clients_urls";$countSelection ="totalUsers"}
    "3"  {$choice = "third_party_urls";$countSelection ="total_third_parties"}

    "5"  {sorry}
    "99" {exit}
    default {exit}
}


$raw = $response.Content | ConvertFrom-Json
$output = $raw.data.$choice |Format-List

$totalCount = $raw.visualize.$countSelection
Write-Host "Total count for $countSelection is $totalCount"

$output #-------  SPILL THE BEANS ~~~

$totalCount = $raw.visualize.$countSelection
Write-Host "Total count for $countSelection is $totalCount"
$showCount = $raw.visualize.$countSelection
$showCount #------- SPILL THE NUMBERS ~~~
main
}

Else{Write-Host "[FAIL] Status Code:$statusCode`n Could not fetch data from API.`nPlease checkcavalier.hudsonrock.com for more info" -ForegroundColor Red}

}
main
