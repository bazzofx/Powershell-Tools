﻿#powershell for hackers  https://github.com/I-Am-Jakoby/PowerShell-for-Hackers/tree/main
function speak {

[CmdletBinding()]
param (	
[Parameter (Position=0,Mandatory = $True,ValueFromPipeline=$true)]
[string]$Sentence
) 

$s.Voice = $s.GetVoices().Item(0)
$s=New-Object -ComObject SAPI.SpVoice
$s.Rate = -2
$s.Speak($Sentence)
}