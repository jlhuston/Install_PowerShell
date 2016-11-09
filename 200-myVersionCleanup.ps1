# This function cleans up version strings into decimal separated sections.
Function myVersionCleanup {
  param ([Parameter(Mandatory=$True)][String]$Version)
  $FunctionTop = "myVersionCleanup`r`n`r`n"
  myLogThis -EventId 21 -Message ($FunctionTop + 'Version : ' + $Version)

  myLogThis -EventId 22 -Message 'Converting spaces to periods'
  $Cleaned = $Version -replace(" ", ".")

  myLogThis -EventId 29 -Message ('Returning cleaned version string : ' + $Cleaned)
  Return $Cleaned
}
