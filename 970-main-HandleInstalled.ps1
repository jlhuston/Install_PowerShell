# Handle the case where a version of the app is already installed.
if ($TestVer -ne $null) {
  if ($Uninstall) {
    # Uninstall the installed version
    myLogThis -EventId 12 -Message 'Calling out to myUninstallOldApplication'
    $UninstallResult = myUninstallOldApplication
    $InstallResult = $UninstallResult
  } else {
    
    Write-Host ("`r`nComparing " + $TestVer + " to the package version of " + $AppVersion)
    myLogThis -EventId 11 -Message 'Calling out to myCompareVersionStrings to determine if the installed version is newer than the one we wish to install'
    $CompareResult = myCompareVersionStrings -MinVer $AppVersion -TestVer $TestVer

    if ($CompareResult -lt 1) {

      if ($CheckVersion) {
        $InstallResult = 4	# Return 4 like the old CheckVersion.vbs script to indicate that the current or newer version is installed
      }
      # The current or a newer version is installed, so just place the registry marker and "go home"
      myLogThis -EventId 5 -Message 'Current or newer version is installed; nothing to do'
      if ($Install -or $Update) {
        myLogThis -EventId 15 -Message 'Calling out to myStampRegistry'
        myStampRegistry
      }
 
    } else {

      if ($CheckVersion) {
        $InstallResult = 3	# Return 3 like the old CheckVersion.vbs script to indicate that an older version is installed
      }

      # An existing version is getting replaced with the latest version, so uninstall it and then install and configure the new one.
      if ($Install -or $Update) {
        myLogThis -EventId 12 -Message 'Calling out to myUninstallOldApplication'
        $UninstallResult = myUninstallOldApplication

        myLogThis -EventId 13 -Message 'Calling out to myInstallNewApplication'
        $InstallResult = myInstallNewApplication

        if (($InstallResult -eq 0) -or ($InstallResult -eq 3010)) {
          myLogThis -EventId 14 -Message 'Calling out to myConfigureApplication'
          myConfigureApplication
        }

        myLogThis -EventId 15 -Message 'Calling out to myStampRegistry'
        myStampRegistry
      }
    }
  }
}
