####BUILD  CAPTURE BASE64



function imageToBase64($imagePath){

$imageBytes = [System.IO.File]::ReadAllBytes($ImagePath)
$base64Encoded = [System.Convert]::ToBase64String($imageBytes)
return $base64Encoded
}


imageToBase64 "C:\Users\Joker\Downloads\images\exe.png" | Set-Clipboard