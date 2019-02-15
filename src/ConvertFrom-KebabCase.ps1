Function ConvertFrom-KebabCase {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$InputObject
    ,
    [Parameter(Position = 1, Mandatory)]
    [ValidateSet("Camel","CamelCase","Snake","SnakeCase")]
    [string]$To
  )
  Process {
    Switch -Wildcard ($To) {
      "Camel*" {
        $textInfo = (Get-Culture).TextInfo
        $evaluator = { $args.Groups[2].Value.ToUpper() }
        Return [regex]::Replace($InputObject, "(-)([a-z])", $evaluator)
      }
      "Snake*" {
        Return ($InputObject -creplace "([a-z])-([a-z])", "`$1_`$2").ToLower()
      }
    }
  }
}

Function Test-IsKebabCase {
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [string]$InputObject
  )
  Process {
    $InputObject -cmatch "^[a-z]+(-[a-z]+)*$"
  }
}