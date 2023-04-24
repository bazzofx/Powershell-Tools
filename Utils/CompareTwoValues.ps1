$out = (1,2,3,4,5,5,6,6,7,7,7,7,7)
    $a = @($out)
    $b=$a | Select -unique
    Compare-object –referenceobject $b –differenceobject $a
      