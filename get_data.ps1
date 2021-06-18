# Import function with: (Or add to path)
#Import-module .\get_data.ps1 -Force

# Example usage 
# 1. <read-data> | Test-Func [-Filter,-Apply, ...]
# 2. Test-Func -Filename <filename> [-Filter, -Apply, ...]


Function Test-Func {
  [CmdletBinding(DefaultParameterSetName="Pipeline")]
  Param(
    [Parameter(ValueFromPipeline=$true, ParameterSetName="Pipeline", Position=0)] [System.Array] $Data

    # [Parameter(ParameterSetName="Direct", Position=0)] [string] $Filename
  )
  
  # if ($PSBoundParameters.ContainsKey('Filename')){
  #   Write-Host "TEST"
  # }
  Process {
    foreach ($row in $Data){
      $row.where({$_.gender -match 'M'})
    }
  }

}

# Import-Csv .\data.csv 


