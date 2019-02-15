Function ConvertFrom-CamelCase {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$InputObject
    ,
    [Parameter(Position = 1, Mandatory)]
    [ValidateSet("Kebab","KebabCase","Snake","SnakeCase")]
    [string]$To
  )
  Process {
    Switch -Wildcard ($To) {
      "Kebab*" {
        Return ($InputObject -creplace "([a-z])([A-Z])", "`$1-`$2").ToLower()
      }
      "Snake*" {
        Return ($InputObject -creplace "([a-z])([A-Z])", "`$1_`$2").ToLower()
      }
    }
  }
}

Function Test-IsCamelCase {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [string]$InputObject
  )
  Process {
    $InputObject -cmatch "^[a-z]+([A-Z][a-z]+)*$"
  }
}