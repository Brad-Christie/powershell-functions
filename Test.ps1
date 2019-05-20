[CmdletBinding(DefaultParameterSetName = "__local")]
Param(
  [Parameter(ParameterSetName = "__local")]
  [string[]]$Filter = $null,
  [Parameter(ParameterSetName = "__local")]
  [switch]$SkipAnalysis,
  [Parameter(ParameterSetName = "__docker")]
  [switch]$Docker
)
$ErrorActionPreference = "Stop"

If ($PSCmdlet.ParameterSetName -eq "__docker") {
  docker build .
} Else {
  $src = "${PSScriptRoot}\src"
  $test = "${PSScriptRoot}\test"

  If (!$SkipAnalysis) {
    Invoke-ScriptAnalyzer -Path $src -Fix
    Invoke-ScriptAnalyzer -Path $test -Fix
  }

  $pesterParams = @{
    Script = $test
    ExcludeTag = "Docker"
  }
  If ($null -ne $Filter) {
    $pesterParams.Add("TestName", $Filter)
  }
  Invoke-Pester @pesterParams
}