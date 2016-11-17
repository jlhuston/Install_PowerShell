# This function installs the new application.
Function myInstallNewApplication {
  $FunctionTop = "myInstallNewApplication`r`n`r`n"
  myLogThis -EventId 50 -Message ($FunctionTop + 'Starting function')

  # Ensure that we can get to the actual installer file
  if ((Test-Path -Path $InstallPackage) -eq $False) {
    myLogThis -EventId 59 -Message ($FunctionTop + "Unable to find $InstallPackage") -EventType "Error"
    Return 2
  }

  # Perform the main app installation and return the result code
  myLogThis -EventId 51 -Message ($FunctionTop + "Calling out to $InstallPackage to install $AppName")
  Write-Host "`r`nInstalling $AppName..."
  $Process = Start-Process -FilePath cmd -ArgumentList "/c msiexec /i $InstallPackage /quiet /norestart JU=0 JAVAUPDATE=0 AUTOUPDATECHECK=0 RebootYesNo=No WEB_JAVA=1" -Wait -PassThru -NoNewWindow
  myLogThis -EventId 52 -Message ($FunctionTop + "Install resulted in exit code " + $Process.ExitCode)
  Write-Host ("  Install completed with exit code " + $Process.ExitCode)
  Return $Process.ExitCode
}
