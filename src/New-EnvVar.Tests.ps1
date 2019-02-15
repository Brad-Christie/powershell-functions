. "${PSScriptRoot}\New-EnvVar.ps1"

Describe "New-EnvVar" -Tag "New", "EnvVar", "Docker" {
  BeforeAll {
    $script:OriginalPSDefaultParameterValues = $Global:PSDefaultParameterValues.Clone()

    If (!(Test-Path env:\APPVEYOR)) {
      $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
      If ($currentUser.Name -ne 'ContainerAdministrator') {
        $Global:PSDefaultParameterValues["It:Skip"] = $true
      }
    }
  }
  AfterAll{
    $Global:PSDefaultParameterValues = $script:OriginalPSDefaultParameterValues
  }

  @(
    [System.EnvironmentVariableTarget]::Process,
    [System.EnvironmentVariableTarget]::User,
    [System.EnvironmentVariableTarget]::Machine
  ) | ForEach-Object {
    $scope = $_
    Context "[System.EnvironmentVariableTarget]::${scope}" {
      $name = ([System.Environment]::GetEnvironmentVariables($scope)).GetEnumerator() | Select-Object -First 1 -ExpandProperty "Key"
      $value = [System.Environment]::GetEnvironmentVariable($name, $scope)
      It "Should not create '${name}', it already exists" {
        { New-EnvVar -Name $name -Value $value -Scope $scope } | Should -Throw
      }

      $name = "${name}_COPY"
      It "Should create '${name}' variable" {
        { New-EnvVar -Name $name -Value $value -Scope $scope } | Should -Not -Throw
        [System.Environment]::GetEnvironmentVariable($name, $scope) | Should -Be $value
      }
    }
  }
}