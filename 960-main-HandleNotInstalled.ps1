# Handle the case where the app isn't already installed.
if ($TestVer -eq $null) {

  # The app doesn't appear to be installed
  # NOTE: If further tests for other locations are necessary, perform them here until we get the version data

  myLogThis -EventId 3 -Message 'No application version currently installed'
  Write-Host -ForegroundColor Green "  The application does not appear to be installed."

  if ($CheckVersion) { $InstallResult = 2 }		#Return 2 like the old CheckVersion.vbs script to indicate not installed

  if ($Update) {
    Write-Host -ForegroundColor Yellow ("We're only performing updates to systems where " + $AppName + " is already installed.")
    myLogThis -EventId 4 -Message 'UPDATE parameter specified; nothing major to do'
    myLogThis -EventId 15 -Message 'Calling out to myStampRegistry'
    myStampRegistry

  } else {

    if ($Install) {
      myLogThis -EventId 13 -Message 'Calling out to myInstallNewApplication'
      $InstallResult = myInstallNewApplication

      if (($InstallResult -eq 0) -or ($InstallResult -eq 3010)) {
        myLogThis -EventId 14 -Message 'Calling out to myConfigureApplication'
        myConfigureApplication
      }

      myLogThis -EventId 15 -Message 'Calling out to myStampRegistry'
      myStampRegistry
    } else {
      Write-Host -ForegroundColor Yellow "$AppName isn't installed; nothing to do."
    }
  }

  # NOTE: If our option was -Uninstall, then there's nothing to do; the app already isn't installed.
}
