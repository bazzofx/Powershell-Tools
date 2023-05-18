function generate-randomPassword($times) {
    function GeneratePassword {
        $r1 = Get-Random -Maximum 10
        $r2 = Get-Random -Maximum 10
        $r3 = Get-Random -Maximum 30
        $r4 = Get-Random -Maximum 10
        $r5 = Get-Random -Maximum 30
        $r6 = Get-Random -Maximum 10
        $t1 = @("Blue","Red","Green","Silver","Purple","Golden","Pink","Brown","White","Black")
        $t2 = @("Ocean","Fire","Lake","River","Grass","Bird","Tiger","Fish","Thunder","Car","Hammer")
        $t3 = @("3","22","33","55","33","55","76","55","23","78","54","23","45","77","88","33","23","99","89","76","55","34","12","34","12","34","23","44","999","888")
        $t4 = @("UK","BR","CH","US","TW","KK","ZE","AU","PK","RX")
        $t6 = @("$","#","@","!","%","+","&","%%","@@","##")
        $pw1 = $t1[$r1]
        $pw2 = $t2[$r2]
        $pw3 = $t3[$r3]
        $pw4 = $t4[$r4]
        $pw5 = $t3[$r5]
        $pw6 = $t6[$r6]
        $tempPass = $pw3 + $pw1 + $pw2 + $pw5 + $pw4 + $pw6

        return $tempPass
    }
    if($times -lt 0){$times = 1;}
    $i = 0
    while ($i -lt $times) {
        GeneratePassword
        $i++
    }
}

generate-randomPassword
