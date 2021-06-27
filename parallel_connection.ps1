
# Install required modules
Install-Module WFTools

Write-Host "Parallel Connection"

Measure-Command {
1..50 | Invoke-Parallel -Throttle 32 -ScriptBlock {
    If(Test-Connection "192.168.0.$_" -Count 1 -Quiet){
        Write-Host "192.168.0.$_ `n" -ForegroundColor Green -NoNewline
    } Else {
        Write-Host "192.168.0.$_ `n" -ForegroundColor Red -NoNewline
    }
}
}

