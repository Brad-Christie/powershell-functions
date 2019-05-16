. "${PSScriptRoot}\ConvertFrom-TemplatedString.ps1"

Describe "ConvertFrom-TemplatedString" -Tag "Convert", "ConvertFrom", "TemplatedString" {
  Context "Basic Usage" {
    It "Should translate '<Format>' into '<Expected>'" -TestCases @(
      @{
        Expected = "Hello, world!"
        Format = 'Hello, ${name}!'
        Tokens = @{ Name = "world"}
      },
      @{
        Expected = "The quick brown fox jumped over the lazy dog."
        Format = 'The quick brown ${noun} ${verb} over the lazy dog.'
        Tokens = @{ noun = "fox"; verb = "jumped" }
      }
    ) {
      Param($Expected, $Format, $Tokens)
      ConvertFrom-TemplatedString $Format -Tokens $Tokens | Should -BeExactly $Expected
    }
  }
  Context "Advanced Usage" {
    It "Should see environmental variables" {
      ConvertFrom-TemplatedString '${env:TEMP}' | Should -BeExactly $env:TEMP
    }
  }
}