. "${PSScriptRoot}\ConvertFrom-KebabCase.ps1"

Describe "ConvertFrom-KebabCase" -Tag "Convert", "ConvertFrom", "KebabCase" {
  Context "kebab-case to camelCase" {
    It "Should convert '<From>' to '<To>'" -TestCases @(
      @{ From = "foo-bar"; To = "fooBar" },
      @{ From = "foo-bar-baz"; To = "fooBarBaz" }
    ) {
      Param([string]$From,[string]$To)
      $From | ConvertFrom-KebabCase -To "CamelCase" | Should -BeExactly $To
    }
  }
  Context "kebab-case to snake_case" {
    It "Should convert '<From>' to '<To>'" -TestCases @(
      @{ From = "foo-bar"; To = "foo_bar" },
      @{ From = "foo-bar-baz"; To = "foo_bar_baz" }
    ) {
      Param([string]$From,[string]$To)
      $From | ConvertFrom-KebabCase -To "SnakeCase" | Should -BeExactly $To
    }
  }
}

Describe "Test-IsKebabCase" -Tag "Test", "KebabCase" {
  Context "Basic Usage" {
    It "Should consider '<Test>' a match" -TestCases @(
      @{ Test = "foo" },
      @{ Test = "foo-bar" },
      @{ Test = "foo-bar-baz" }
    ) {
      Param([string]$Test)

      Test-IsKebabCase $Test | Should -Be $true
    }
    It "Should NOT consider '<Test>' a match" -TestCases @(
      @{ Test = "Foo" }, @{ Test = "FooBar" }, # Pascal
      @{ Test = "fooBar" }, # KebabCase
      @{ Test = "foo_bar" } # snake_case
    ) {
      Param([string]$Test)

      Test-IsKebabCase $Test | Should -Be $false
    }
  }
}