$stringx = Import-Csv 'C:\Users\paulo.bazzo\OneDrive - NEC Software Solutions\Documents\Projects\Auto-Diagram\ProcessMap\v_5.6\data\simple__.csv'

function carveString ($string) {
$pattern = "[^\\]+$"

    if ($string -match $pattern) {
      $captured= $matches[0]
    }
return $captured
}

forEach ($x in $stringx){
$name = carveString $x.parentFilePath

}



