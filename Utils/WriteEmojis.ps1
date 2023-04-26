#From HEX to Io 
function emoji ($hexValue,$fgColor,$bgColor){
#Firstly, the code below will convert the Hex value to Integer
$EmojiIcon = [System.Convert]::toInt32("$hexValue",16)
#Secondly, convert the Unicode point which is stored in $EmojiIcon to UTF-16 String
 $emoji = Write-Host -ForegroundColor $fgColor -BackgroundColor $bgColor ([System.Char]::ConvertFromUtf32($EmojiIcon)) -NoNewline
 return $emoji
 }
 
 Write-Host "lovely day " -NoNewline; emoji 1F600 white red
