<#
  .SYNOPSIS
    Tests if a property exists on the provided object.
  .DESCRIPTION
    Often times you may want to check (esp. when dealing with JSON/XML)
    if a proeprty exists on an object. By accessing a missing property
    (specifically, in strict mode) you're receive back an error:
      The property 'Foo' cannot be found on this object. Verify that the
      property exists.

    This helper is designed to avoid this.
  .PARAMETER InputObject
    The object to examine.
  .PARAMETER PropertyName
    The name of the property to test for.
#>
Function Test-Property {
  [CmdletBinding()]
  [OutputType([boolean])]
  Param(
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [psobject]$InputObject
    ,
    [Parameter(Position = 1, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias("Name")]
    [string]$PropertyName
    ,
    [Parameter()]
    [type]$OfType = $null
  )
  Process {
    If ($InputObject -is [System.Collections.Hashtable]) {
      $result = ([System.Collections.Hashtable]$InputObject).ContainsKey($PropertyName)
    } ElseIf ($InputObject -is [System.Collections.IDictionary]) {
      $result = ([System.Collections.IDictionary]$InputObject).Contains($PropertyName)
    } Else {
      $result = $PropertyName -in ($InputObject | Get-Member -MemberType NoteProperty).Name
    }
    If ($result -and $OfType -ne $null) {
      $result = $InputObject.$PropertyName -is $OfType
    }
    Return $result
  }
}