function get-AllHeadersCsv {
    $file1Headers = $data | gm | Where-Object{$_.Name -ne "Equals"} |
                  Where-Object{$_.Name -ne "GetHashCode"} |
                  Where-Object{$_.Name -ne "GetType"} |
                  Where-Object{$_.Name -ne "ToString"}

    $fileHeaders = $file1Headers.Name -join ","
    $fileHeaders = $fileHeaders.split(",")
    return $fileHeaders

}
get-AllHeadersCsv