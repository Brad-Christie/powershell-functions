. "${PSScriptRoot}\..\src\ConvertFrom-CamelCase.ps1"

Describe "ConvertFrom-CamelCase" -Tag "Convert", "ConvertFrom", "CamelCase" {
  Context "camelCase to kebab-case" {
    It "Should convert '<From>' to '<To>'" -TestCases @(
      @{ From = "fooBar"; To = "foo-bar" },
      @{ From = "fooBarBaz"; To = "foo-bar-baz" }
    ) {
      Param([string]$From,[string]$To)
      $From | ConvertFrom-CamelCase -To "KebabCase" | Should -BeExactly $To
    }
  }
  Context "camelCase to snake_case" {
    It "Should convert '<From>' to '<To>'" -TestCases @(
      @{ From = "fooBar"; To = "foo_bar" },
      @{ From = "fooBarBaz"; To = "foo_bar_baz" }
    ) {
      Param([string]$From,[string]$To)
      $From | ConvertFrom-CamelCase -To "SnakeCase" | Should -BeExactly $To
    }
  }
}

Describe "Test-IsCamelCase" -Tag "Test", "CamelCase" {
  Context "Basic Usage" {
    It "Should consider '<Test>' a match" -TestCases @(
      @{ Test = "foo" },
      @{ Test = "fooBar" },
      @{ Test = "fooBarBaz" }
    ) {
      Param([string]$Test)

      Test-IsCamelCase $Test | Should -Be $true
    }
    It "Should NOT consider '<Test>' a match" -TestCases @(
      @{ Test = "Foo" }, @{ Test = "FooBar" }, # Pascal
      @{ Test = "foo_bar" } # snake_case
      @{ Test = "foo-bar-baz" } # kebab-case
    ) {
      Param([string]$Test)

      Test-IsCamelCase $Test | Should -Be $false
    }
  }
}