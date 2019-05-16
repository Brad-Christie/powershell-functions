Function ConvertFrom-TemplatedString {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [string]$Format
    ,
    [Parameter()]
    [ValidateNotNull()]
    [System.Collections.Hashtable]$Tokens = @{}
  )
  Begin {
    $Powershell = [powershell]::Create()
  }
  Process {
    $param = "`$_"
    If ($Tokens.Count -gt 0) {
      $param += ", {0}" -f (($Tokens.Keys | ForEach-Object { "`$${_}" }) -join ", ")
    }

    [void]$Powershell.AddScript("Param(${param})`n`$ExecutionContext.InvokeCommand.ExpandString(`$_)")
    [void]$Powershell.AddParameter("_", $Format)
    [void]$Powershell.AddParameters($Tokens)

    Return $Powershell.Invoke()
  }
  End {
    $Powershell.Dispose()
  }
}