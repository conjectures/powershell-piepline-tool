# Import function with: (Or add to path)
#Import-module .\get_data.ps1 -Force

# Example usage 
# 1. <read-data> | Test-Func [-Filter,-Apply, ...]
# 2. Test-Func -Filename <filename> [-Filter, -Apply, ...]


Function Test-Func {
  [CmdletBinding(DefaultParameterSetName="Pipeline")]
  Param(
    [Parameter(ValueFromPipeline=$true, ParameterSetName="Pipeline", Position=0)] [System.Array] $Data,

    [Parameter(ParameterSetName="Direct", Position=0)] [string] $Filename,
    [Parameter()] [Alias("Where")] [ValidatePattern("^(\w+=[^\'`, ],)*(\w+=[^\'`, ]*)$")] [string[]] $Filter
  )
  
  begin {
    # Parse Filters If passed as argument
    if ($PSBoundParameters.ContainsKey('Filter')){
      Write-Verbose "Parse filter parameters"
      $filters = @()
      foreach ($string in $Filter){ 
        $field,$query = $string.Split('=')
	$filters += "(`$_.$field -match '$query')"
      }
      $fs = [scriptblock]::Create($filters -join ' -and ')
      #Write-Verbose $filters
	
    }

    if ($PSBoundParameters.ContainsKey('Filename')){
      Write-Host $Filename
      $Data = Import-Csv $Filename
    }
    # $Data.where({$_.gender -match 'M'})
  }
  Process {
    # $_.where({($_.gender -match 'M') -and ($_.name -match 'M')})
    # $_ | Where-Object { ($_.gender -match 'M') -and ($_.name -match 'M') }
    # $_ | ? $fs
    $_.where($fs)
	
    # foreach ($row in $Data){
    #   $row.where({$_.gender -match 'M'})
    # }
  }
  end {
    # $Data.where({$_.gender -match 'M'})
  }

}

# Import-Csv .\data.csv 


