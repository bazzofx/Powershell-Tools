function get-sandman {
    $name = Read-Host "What is your name? "
    Write-Host "Hello $name, I am the sandman"

}

Export-ModuleMember -Function get-sandman

