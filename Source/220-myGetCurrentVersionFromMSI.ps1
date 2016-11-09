# This function returns the version string from the MSI registry database. If not found to be installed, returns $null.
Function myGetCurrentVersionFromMSI {
  param ([Parameter(Mandatory=$True)][String]$Query, [Parameter(Mandatory=$True)][String]$VersionValue)
  $FunctionTop = "myGetCurrentVersionFromMSI`r`n`r`n"
  myLogThis -EventId 11 -Message ($FunctionTop + "Query : " + $Query + "`r`n" + "VersionValue : " + $VersionValue)
  Write-Host -NoNewLine "Looking for installation evidence in MSI database, matching query "
  Write-Host -ForegroundColor White $Query ":" $VersionValue

  # Attempt to determine if we're 64-bit, 32-bit, or not installed at all
  myLogThis -EventId 12 -Message ($FunctionTop + "Testing for 64-bit MSI database existence")
  $Apps = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty -Name DisplayName,$VersionValue -ErrorAction SilentlyContinue | where { $_.DisplayName -like $Query }
  if ($Apps) {
    myLogThis -EventId 13 -Message ($FunctionTop + 'Found key in 64-bit registry')
    Write-Host "  Found installation evidence in 64-bit MSI database"
    $RawValue = $Apps.$VersionValue
  } else {
    myLogThis -EventId 12 -Message ($FunctionTop + "Testing for 32-bit MSI database existence")
    $Apps = Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty -Name DisplayName,$VersionValue -ErrorAction SilentlyContinue | where { $_.DisplayName -like $Query }
    if ($Apps) {
      myLogThis -EventId 13 -Message ($FunctionTop + 'Found key in 32-bit registry')
      Write-Host "  Found installation evidence in 32-bit MSI database"
      $RawValue = $Apps.$VersionValue
    } else {
      myLogThis -EventId 13 -Message ($FunctionTop + 'Unable to find key') -EntryType "Warning"
      Write-Host "  Could not find installation evidence in MSI database"
      Return $null
    }
  }
  
  myLogThis -EventId 15 -Message ($FunctionTop + "Raw Value : " + $RawValue)

  myLogThis -EventId 16 -Message ($FunctionTop + 'Calling out to myVersionCleanup')
  $CleanValue = myVersionCleanup -Version $RawValue

  myLogThis -EventId 19 -Message ($FunctionTop + 'Returning found version number as string : ' + $CleanValue)
  Write-Host -NoNewLine "  Version number from registry: "
  Write-Host -ForegroundColor White $RawValue
  Write-Host -NoNewLine "                 Cleaned up to: "
  Write-Host -ForegroundColor White $CleanValue
  Return $CleanValue
}
