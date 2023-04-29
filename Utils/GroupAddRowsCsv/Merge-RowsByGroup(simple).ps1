function Merge-RowsByGroup {
     [CmdletBinding()]
     Param([parameter(ValueFromRemainingArguments=$true)][String[]] $identifier,$mainNumber,$bonus)

$wd = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy\Github\Powershell Tools\Utils\GroupAddRowsCsv"
$data = Import-Csv "$wd\data.csv" | Sort-Object -Property $identifier
$out = "$wd\Combined.csv"
[double]$global:adjustment = $null
$total= $null
$array = @()
$currentRow = 0
#-------------------------------------------------GLOBAL VARIABLES ---------------------------

ForEach($x in $data){
    $key = ""
    $nextRow = $currentRow + 1
    $previousRow = $currentRow - 1
    $p = $data[$previousRow].$identifier
    $c = $data[$currentRow].$identifier
    $n = $data[$nextRow].$identifier
    [double]$t = $data[$currentRow].$mainNumber
    [double]$adjRaw = $data[$currentRow].$bonus 
    [double]$nextAdjRaw = $data[$nextRow].$bonus
    [double]$prevAdjRaw = $data[$previousRow].$bonus
      
    #------------------------------------------- LOCAL VARIABLES -----------------------------
          if ($c -ne $n){ #IF CURRENT ROW NOT EQUALS NEXT ROW
              if($adjRaw -eq ""){ #IF ADJUSTMENT EMPTY USE TOTAL ENTITLEMENT
                  $total = $t
                 }
               else{             #OTHERWISE ADD ADJUS + TOTAL TOGETHER
                    [double]$adj = $adjRaw
                    $total += $adj
                    $total += $t
                                   }
          #---           CALCULATION ADDING ADJUSTMENTS ON TRENT HAPPENS HERE

      $row = New-Object Object
      $row | Add-Member -MemberType NoteProperty -Name "EmployeeID" -Value $c
      $row | Add-Member -MemberType NoteProperty -Name "TotalEntiTrent" -Value $total  
      $array += $row  
      $r= "firstRow"     #SET TRIGGER TO CREATE ROW ONCE
    } #FIRST CHECK IF CURRENT ROW NOT EQUALS NEXT ROW
# ------------------- SUM FOR DUPLICATE ROWS START HERE ---------------------
          elseif($c -eq $n -or $p -eq $c -and $key -eq "") {
          $global:adjustment += $adjRaw;$key ="done";$total = $global:adjustment + $t
           Write-Host "($c) - $global:adjustment + $t ---> $total" -ForegroundColor Magenta
           #Write-Host $global:adjustment -ForegroundColor Magenta
          #sleep 1
          }  
          if($p -eq $c -and $key -eq ""){$global:adjustment += $adjRaw; $total = $global:adjustment + $t; $key ="done"

     $row | Add-Member -MemberType NoteProperty -Name "EmployeeID" -Value $c -Force # very important to use the -force flag to override value
     $row | Add-Member -MemberType NoteProperty -Name "TotalEntiTrent" -Value $total -Force # very important to use the -force flag to override value
     #$array += $row # Dont need to create a new row here
           #Write-Host $global:adjustment -ForegroundColor cyan
           #Write-Host "Previous row equals next row" -ForegroundColor Cyan
           Write-Host "Records created with the following : ($c) - $global:adjustment  + $t ---> $total" -ForegroundColor Cyan
           #Write-Host "($p) - $prevAdjRaw  + $t ---> $total" -ForegroundColor Red
           #Write-Host "($n) - $nextAdjRaw  + $t ---> $total" -ForegroundColor Green

          #sleep 5
          }
          elseif($adj -eq ""){$total = + $t}
          if($c -ne $n){$global:adjustment =""}else{}
                 
 

        
         
     $currentRow +=1
       $total =$null #reset totalAnnualLeave so it picks up the correct value on next row        
          }#cls forLoop
  
    
$array | Export-Csv -Path $out -NoTypeInformation   

    }

Merge-RowsByGroup -identifier Name -mainNumber Salary -bonus Bonus