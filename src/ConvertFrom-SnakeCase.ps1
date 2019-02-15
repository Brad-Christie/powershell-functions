Function ConvertFrom-SnakeCase {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$InputObject
    ,
    [Parameter(Position = 1, Mandatory)]
    [ValidateSet("Camel","CamelCase","Kebab","KebabCase")]
    [string]$To
  )
  Process {
    Switch -Wildcard ($To) {
      "Camel*" {
        $textInfo = (Get-Culture).TextInfo
        $evaluator = { $args.Groups[2].Value.ToUpper() }
        Return [regex]::Replace($InputObject, "(_)([a-z])", $evaluator)
      }
      "Kebab*" {
        Return ($InputObject -creplace "([a-z])_([a-z])", "`$1-`$2").ToLower()
      }
    }
  }
}

Function Test-IsSnakeCase {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [string]$InputObject
  )
  Process {
    $InputObject -cmatch "^[a-z]+(_[a-z]+)*$"
  }
}