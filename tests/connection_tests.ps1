
# Install 
Install-Module WFTools

# Testing sequential vs parallel connection check to ip range in local network
# 
#

Write-Host "Testing Sequential" 
Measure-Command {
1..50 | foreach {
    If(Test-Connection "192.168.0.$_" -Count 1 -Quiet){
        Write-Host "192.168.0.$_ `n" -ForegroundColor Green -NoNewline
    } Else {
        Write-Host "192.168.0.$_ `n" -ForegroundColor Red -NoNewline
    }
}
}

Write-Host "Testing Parallel"

Measure-Command {
1..50 | Invoke-Parallel -Throttle 32 -ScriptBlock {
    If(Test-Connection "192.168.0.$_" -Count 1 -Quiet){
        Write-Host "192.168.0.$_ `n" -ForegroundColor Green -NoNewline
    } Else {
        Write-Host "192.168.0.$_ `n" -ForegroundColor Red -NoNewline
    }
}
}

