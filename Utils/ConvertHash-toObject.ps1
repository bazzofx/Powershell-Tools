function ConvertTo-Object($hashtable) 
{
   $object = New-Object PSObject
   $hashtable.GetEnumerator() | 
      ForEach-Object { Add-Member -inputObject $object `
	  	-memberType NoteProperty -name $_.Name -value $_.Value }
   $object
}

$hash = @{Name='Tobias'; Age=66; Status='Online'}
$hash
ConvertTo-Object $hash