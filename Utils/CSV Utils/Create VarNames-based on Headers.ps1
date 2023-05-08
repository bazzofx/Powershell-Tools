$x = "AnnualLeave_Adjust","AnnualLeave_Trent","Available balance","Balance used","ContHours_Trent","DOB_Trent","Email_Trent","Employee type","Entitlement Units:Holiday Entitlement","First name","FirstName_Trent","Gender","Gender_Trent","Hired date","Holiday Year End Date:Holiday Entitlement","Hours per week","Job Title","JobTitle_Trent","PositionStatus_Trent","Postcode_Trent","Primary department","Salary identifier","Service_Trent","StartDate_Trent","Surname","Surname_Trent","Title","Username","FinalBalance_Trent"

ForEach ($word in $x) {
Write-Host "`$$word = '`$x.$word'"
}