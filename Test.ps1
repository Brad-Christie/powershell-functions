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
  If (!$SkipAnalysis) {
    Invoke-ScriptAnalyzer -Path $src -Fix
  }

  $pesterParams = @{
    Script = $src
    ExcludeTag = "Docker"
  }
  If ($null -ne $Filter) {
    $pesterParams.Add("TestName", $Filter)
  }
  Invoke-Pester @pesterParams
}