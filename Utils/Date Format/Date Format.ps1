function stringToTime($dateString){
    $dateFormat = "dd/MM/yyyy"  # Specify the format of your date string -- it needs to match what you are passing as an argument
    $datetime = [DateTime]::ParseExact($dateString, $dateFormat, $null)
    return $datetime
}

stringToTime "20/10/2023"
