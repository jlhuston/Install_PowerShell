# This function stamps the registry to indicate that this script has been run.
# Use this stamp with SCCM when targeting blanket -Update runs.
Function myStampRegistry {
  $FunctionTop = "myStampRegistry`r`n`r`n"
  myLogThis -EventId 70 -Message ($FunctionTop + 'Start of function')

  $Path = ("HKLM:\SOFTWARE\PrivateData\" + $AppName)
  if (Test-Path -Path $Path) { 
    myLogThis -EventId 71 -Message ($FunctionTop + 'Removing old stamp at ' + $Path)
    Remove-Item -Path $Path -Recurse -Force
  }

  myLogThis -EventId 72 -Message ($FunctionTop + 'Stamping registry at ' + $Path)
  New-Item -Path $Path -Force | Out-Null

  $Path+="\" + $AppVersion
  myLogThis -EventId 73 -Message ($FunctionTop + 'Stamping registry at ' + $Path)
  New-Item -Path $Path -Force | Out-Null

  myLogThis -EventId 74 -Message ($FunctionTop + 'Setting (default) value')
  New-ItemProperty -Path $Path -Name '(Default)' -Value 'InTune' | Out-Null
}
