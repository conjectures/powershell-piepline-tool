# Import function with: (Or add to path)
#Import-module .\get_data.ps1 -Force

# Example usage 
# 1. <read-data> | Test-Func [-Filter,-Apply, ...]
# 2. Test-Func -Filename <filename> [-Filter, -Apply, ...]


Function Apply-Filter{
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

# Function credit to https://gist.github.com/marcgeld/4891bbb6e72d7fdb577920a6420c1dfb
Function Get-RandomAlphanumericString {
  [CmdletBinding()] [alias("Get-Alphanumeric")]
  Param( [int] $length = 8)
  Process{
    # Create a list of available characters in hex  - feed into get random to choose $lenght characters and output
    Write-Output ( -join ((0x30..0x39) + (0x41..0x5A) + (0x61..0x7a) | Get-Random -Count $length | % {[char]$_}) )
  }
}

# Function to hash a
Function Get-HashValue {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]] $Data,

    [Parameter()] [string] $Algorithm = 'sha256'
  )
  Begin { 
    $HashingAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create($Algorithm)
    $result = New-Object System.Collections.ArrayList
    
  }
  Process {
      # Generate salt
      $salt = Get-RandomAlphanumericString -Length 10
      Write-Verbose "salt: $salt"
      # Hash string
      Write-Verbose "data: $Data"
      $hash = $HashingAlgorithm.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Data + $salt))
      $hashString = [System.BitConverter]::ToString($hash).Replace('-','')
      Write-Verbose "hash: $hashString"


      $result.Add([PSCustomObject]@{
          HashValue = $hashString
          Salt = $salt
        }) 2>&1 >> $null

      #$result += @{
      #  HashValue=$hashString
      #  Salt=$salt
      #}
  }
  End {
    $result
  }
}

