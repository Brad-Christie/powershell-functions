. "${PSScriptRoot}\Test-Property.ps1"

Describe "Test-Property" -Tag "Test", "Property" {
  Context "Basic Usage" {
    BeforeAll {
      $obj = @{ Foo = "Bar" }
    }
    It "Should accept named parameters" {
      Test-Property -InputObject $obj -PropertyName "Foo" | Should -Be $true
    }
    It "Should accept ordered parameters" {
      Test-Property $obj "Foo" | Should -Be $true
    }
    It "Should accept pipeline parameters" {
      $obj | Test-Property -PropertyName "Foo" | Should -Be $true
    }
  }
  Context "IDictionary" {
    BeforeAll {
      $obj = New-Object "System.Collections.Generic.Dictionary[string,object]"
      $obj.Add("Make", "Ford")
      $obj.Add("Model", "Mustang")
      $obj.Add("Year", 2008)
    }
    It "Should have <PropertyName> [of type <OfType>]" -TestCases @(
      @{ PropertyName = "Make"; OfType = [string] },
      @{ PropertyName = "Model"; OfType = [string] },
      @{ PropertyName = "Year"; OfType = [int] }
    ) {
      Param([string]$PropertyName,[type]$OfType)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $true
      Test-Property $obj -PropertyName $PropertyName -OfType $OfType | Should -Be $true
    }
    It "Shouldn't have <PropertyName>" -TestCases @(
      @{ PropertyName = "VIN" },
      @{ PropertyName = "Mileage" }
    ) {
      Param([string]$PropertyName)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $false
    }
    It "Should acknowledge <PropertyName> was added" -TestCases @(
      @{ PropertyName = "VIN"; PropertyValue = "1HGBH41JXMN109186" },
      @{ PropertyName = "Mileage"; PropertyValue = 12345 }
    ) {
      Param([string]$PropertyName,[psobject]$PropertyValue)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $false
      $obj.Add($PropertyName, $PropertyValue)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $true
    }
  }
  Context "HashTable" {
    BeforeEach {
      $obj = @{
        Make = "Ford"
        Model = "Mustang"
        Year = 2008
      }
    }
    It "Should have <PropertyName> [of type <OfType>]" -TestCases @(
      @{ PropertyName = "Make"; OfType = [string] },
      @{ PropertyName = "Model"; OfType = [string] },
      @{ PropertyName = "Year"; OfType = [int] }
    ) {
      Param([string]$PropertyName,[type]$OfType)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $true
      Test-Property $obj -PropertyName $PropertyName -OfType $OfType | Should -Be $true
    }
    It "Shouldn't have <PropertyName>" -TestCases @(
      @{ PropertyName = "VIN" },
      @{ PropertyName = "Mileage" }
    ) {
      Param([string]$PropertyName)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $false
    }
    It "Should acknowledge <PropertyName> was added" -TestCases @(
      @{ PropertyName = "VIN"; PropertyValue = "1HGBH41JXMN109186" },
      @{ PropertyName = "Mileage"; PropertyValue = 12345 }
    ) {
      Param([string]$PropertyName,[psobject]$PropertyValue)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $false
      $obj.Add($PropertyName, $PropertyValue)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $true
    }
  }
  Context "PSCustomObject" {
    BeforeEach {
      $obj = "{`"Make`":`"Ford`",`"Model`":`"Mustang`",`"Year`":2008}" | ConvertFrom-Json
    }
    It "Should have <PropertyName> [of type <OfType>]" -TestCases @(
      @{ PropertyName = "Make"; OfType = [string] },
      @{ PropertyName = "Model"; OfType = [string] },
      @{ PropertyName = "Year"; OfType = [int] }
    ) {
      Param([string]$PropertyName,[type]$OfType)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $true
      Test-Property $obj -PropertyName $PropertyName -OfType $OfType | Should -Be $true
    }
    It "Shouldn't have <PropertyName>" -TestCases @(
      @{ PropertyName = "VIN" },
      @{ PropertyName = "Mileage" }
    ) {
      Param([string]$PropertyName)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $false
    }
    It "Should acknowledge <PropertyName> was added" -TestCases @(
      @{ PropertyName = "VIN"; PropertyValue = "1HGBH41JXMN109186" },
      @{ PropertyName = "Mileage"; PropertyValue = 12345 }
    ) {
      Param([string]$PropertyName,[psobject]$PropertyValue)
      Test-Property $obj -PropertyName $PropertyName | Should -Be $false
      $obj | Add-Member -NotePropertyName $PropertyName -NotePropertyValue $PropertyValue
      Test-Property $obj -PropertyName $PropertyName | Should -Be $true
    }
  }
}