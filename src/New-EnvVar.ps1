Function New-EnvVar {
  [CmdletBinding(SupportsShouldProcess)]
  Param(
    [Parameter(Position = 0, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Name
    ,
    [Parameter(Position = 1, Mandatory)]
    [object]$Value
    ,
    [Parameter(Position = 2)]
    [ValidateSet("Machine", "Process", "User")]
    [string]$Scope = "Process"
  )
  Process {
    If ($PSCmdlet.ShouldProcess("Create environmental variable '${Name}' in '${Scope}' scope")) {
      $preexisting = ([System.Environment]::GetEnvironmentVariables($Scope)).GetEnumerator() | Where-Object "Key" -EQ $Name
      If ($null -ne $preexisting) {
        Throw "A variable with the name '${Name}' already exists."
      }
      [System.Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
    }
  }
}