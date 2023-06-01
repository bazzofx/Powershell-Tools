function emoji ($hexValue,$fgColor,$bgColor){
#Firstly, the code below will convert the Hex value to Integer
$EmojiIcon = [System.Convert]::toInt32("$hexValue",16)
#Secondly, convert the Unicode point which is stored in $EmojiIcon to UTF-16 String
 $emoji = Write-Host -ForegroundColor $fgColor -BackgroundColor $bgColor ([System.Char]::ConvertFromUtf32($EmojiIcon)) -NoNewline
 return $emoji
 } # This adds the emojis

  emoji "1F942" red black
  emoji "1F37E" white blue
  emoji "1F967" yellow magenta
  emoji "1F435" blue white
  emoji "1F3F4" blue white
  emoji "1F964" blue white
  emoji "1F942" blue white
  emoji "1F37E" blue white
  emoji "1F967" blue white
  emoji "1F36A" blue white
  emoji "1F368" blue white
  emoji "1F366" blue white

