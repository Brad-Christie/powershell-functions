. "${PSScriptRoot}\ConvertFrom-SnakeCase.ps1"

Describe "ConvertFrom-SnakeCase" -Tag "Convert", "ConvertFrom", "SnakeCase" {
  Context "snake_case to camelCase" {
    It "Should convert '<From>' to '<To>'" -TestCases @(
      @{ From = "foo_bar"; To = "fooBar" },
      @{ From = "foo_bar_baz"; To = "fooBarBaz" }
    ) {
      Param([string]$From,[string]$To)
      $From | ConvertFrom-SnakeCase -To "CamelCase" | Should -BeExactly $To
    }
  }
  Context "snake_case to kebab-case" {
    It "Should convert '<From>' to '<To>'" -TestCases @(
      @{ From = "foo_bar"; To = "foo-bar" },
      @{ From = "foo_bar_baz"; To = "foo-bar-baz" }
    ) {
      Param([string]$From,[string]$To)
      $From | ConvertFrom-SnakeCase -To "KebabCase" | Should -BeExactly $To
    }
  }
}

Describe "Test-IsSnakeCase" -Tag "Test", "SnakeCase" {
  Context "Basic Usage" {
    It "Should consider '<Test>' a match" -TestCases @(
      @{ Test = "foo" },
      @{ Test = "foo_bar" },
      @{ Test = "foo_bar_baz" }
    ) {
      Param([string]$Test)

      Test-IsSnakeCase $Test | Should -Be $true
    }
    It "Should NOT consider '<Test>' a match" -TestCases @(
      @{ Test = "Foo" }, @{ Test = "FooBar" }, # Pascal
      @{ Test = "fooBar" }, # camelCase
      @{ Test = "foo-bar-baz" } # kebab-case
    ) {
      Param([string]$Test)

      Test-IsSnakeCase $Test | Should -Be $false
    }
  }
}