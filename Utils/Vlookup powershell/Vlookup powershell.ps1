$hash=@{} 
 $height=import-csv *height*
 $weight=import-csv *weight*
 $weight|%{$hash[$_.nome]=$_."weight"}  
 
$height|select-object nome,height,@{name="weight"; expression={$hash[$_."nome"];$_}},age  |export-csv TEAM.csv -NoTypeInformation