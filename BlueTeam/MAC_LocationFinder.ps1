#   https://github.com/cipher387/API-s-for-OSINT/#whois
#   https://www.mylnikov.org/ 
#    https://www.youtube.com/watch?v=GkIFe681TTo
$MAC = "00:0C:42:1F:65:E9"
#$MAC = "e0:cb:bc:15:96:80"
$url = "https://api.mylnikov.org/geolocation/wifi?v=1.1&data=open&bssid=$MAC"

$res = Invoke-WebRequest $url -UseBasicParsing


$res = $res.Content | ConvertTo-Json
$pieces = $res.split(",")

$status = $pieces[0]
$lat = $pieces[1]
$pieces[2]
$pieces[3]
$lon = $pieces[4]
$pieces[5]

$res.data > "C:\temp\out.json"