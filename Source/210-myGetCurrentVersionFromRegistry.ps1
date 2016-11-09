# This function gets the version string from the registry.  If not found to be installed, returns $null
Function myGetCurrentVersionFromRegistry {
  param ([Parameter(Mandatory=$True)][String]$KeyName, [Parameter(Mandatory=$True)][String]$VersionValue)
  $FunctionTop = "myGetCurrentVersionFromRegistry`r`n`r`n"
  myLogThis -EventId 11 -Message ($FunctionTop + 'KeyName : ' + $KeyName + "`r`n" + 'VersionValue : ' + $VersionValue)
  Write-Host -NoNewLine "Looking for installation evidence in registry under software key "
  Write-Host -ForegroundColor White $KeyName ":" $VersionValue

  # Attempt to determine if we're 64-bit, 32-bit, or not installed at all
  myLogThis -EventId 12 -Message ($FunctionTop + 'Testing for 64-bit registry key existence')
  $Result = Test-Path ('HKLM:\SOFTWARE\' + $KeyName)
  if ($Result) {
    myLogThis -EventId 13 -Message ($FunctionTop + 'Found key in 64-bit registry')
    Write-Host "  Found installation evidence in 64-bit registry"
    $Base = ('HKLM:\SOFTWARE\' + $KeyName)
  } else {
    myLogThis -EventId 12 -Message ($FunctionTop + 'Testing for 32-bit registry key existence')
    $Result = Test-Path ('HKLM:\SOFTWARE\Wow6432Node\' + $KeyName)
    if ($Result) {
      myLogThis -EventId 13 -Message ($FunctionTop + 'Found key in 32-bit registry')
      Write-Host "  Found installation evidence in 32-bit registry"
      $Base = ('HKLM:\SOFTWARE\Wow6432Node\' + $KeyName)
    } else {
      myLogThis -EventId 13 -Message ($FunctionTop + 'Unable to find key') -EntryType "Warning"
      Write-Host "  Could not find installation evidence in registry"
      Return $null
    }
  }

  myLogThis -EventId 14 -Message ($FunctionTop + 'Getting version from registry')
  $RawValue = (Get-ItemProperty -Path $Base -ErrorAction SilentlyContinue).$VersionValue
  myLogThis -EventId 15 -Message ($FunctionTop + 'Raw Value : ' + $RawValue)

  myLogThis -EventId 16 -Message ($FunctionTop + 'Calling out to myVersionCleanup')
  $CleanValue = myVersionCleanup -Version $RawValue

  myLogThis -EventId 19 -Message ($FunctionTop + 'Returning found version number as string : ' + $CleanValue)
  Write-Host -NoNewLine "  Version number from registry: "
  Write-Host -ForegroundColor White $RawValue
  Write-Host -NoNewLine "                 Cleaned up to: "
  Write-Host -ForegroundColor White $CleanValue
  Return $CleanValue
}
