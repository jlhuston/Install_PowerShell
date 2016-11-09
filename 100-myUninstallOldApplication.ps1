# This function handles the uninstallation of the old version(s) of the application.
Function myUninstallOldApplication {
  $FunctionTop = "myUninstallOldApplication`r`n`r`n"
  myLogThis -EventId 40 -Message ($FunctionTop + 'Starting function')
  Write-Host "`r`nUninstalling old version of $AppName..."

  # Terminate Firefox processes
  myLogThis -EventId 41 -Message ($FunctionTop + 'Searching for firefox.exe processes that need to be terminated')
  $Processes = Get-Process -Name firefox -ErrorAction SilentlyContinue
  if ($Processes.Length -ne $null) {
    Write-Host -ForegroundColor Yellow "  Terminating running Firefox processes..."
    myLogThis -EventId 42 -Message ($FunctionTop + "Terminating " + $Processes.Length + " processes")
    foreach ($Process in $Processes) {
      myLogThis -EventId 43 -Message ($FunctionTop + "Terminating process ID " + $Process.Id + "`r`n" + $Process.MainModule.FileName + "`r`n" + $Process.MainWindowTitle + "`r`n" + $Process.Product + "`r`n" + $Process.ProductVersion)
      $Process.Kill()
    }
  }

  # Terminate Chrome processes
  myLogThis -EventId 41 -Message ($FunctionTop + 'Searching for chrome.exe processes that need to be terminated')
  $Processes = Get-Process -Name chrome -ErrorAction SilentlyContinue
  if ($Processes.Length -ne $null) {
    Write-Host -ForegroundColor Yellow "  Terminating running Chrome processes..."
    myLogThis -EventId 42 -Message ($FunctionTop + "Terminating " + $Processes.Length + " processes")
    foreach ($Process in $Processes) {
      myLogThis -EventId 43 -Message ($FunctionTop + "Terminating process ID " + $Process.Id + "`r`n" + $Process.MainModule.FileName + "`r`n" + $Process.MainWindowTitle + "`r`n" + $Process.Product + "`r`n" + $Process.ProductVersion)
      $Process.Kill()
    }
  }

  # Terminate Internet Explorer processes
  myLogThis -EventId 41 -Message ($FunctionTop + 'Searching for iexplore.exe processes that need to be terminated')
  $Processes = Get-Process -Name iexplore -ErrorAction SilentlyContinue
  if ($Processes.Length -ne $null) {
    Write-Host -ForegroundColor Yellow "  Terminating running Internet Explorer processes..."
    myLogThis -EventId 42 -Message ($FunctionTop + "Terminating " + $Processes.Length + " processes")
    foreach ($Process in $Processes) {
      myLogThis -EventId 43 -Message ($FunctionTop + "Terminating process ID " + $Process.Id + "`r`n" + $Process.MainModule.FileName + "`r`n" + $Process.MainWindowTitle + "`r`n" + $Process.Product + "`r`n" + $Process.ProductVersion)
      $Process.Kill()
    }
  }

  Start-Sleep -Seconds 1

  # Look through the registry and gather all installations of Java and their UninstallString
  myLogThis -EventId 44 -Message ($FunctionTop + 'Looking for MSI registered instances to uninstall...')
  Write-Host "  Looking for installed instances..."
  $qtVer = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match ".*Java.*Update.*" } | Select-Object -Property DisplayName,UninstallString
  if ($qtVer -eq $null) {
    Write-Host "    No instances found"
    myLogThis -EventId 49 -Message ($FunctionTop + "No installed instances found")
    Return 0
  }

  # Set a default return value to compare against
  $Result = 0

  # Iterate through all of the installed instances and call their uninstallstring,
  # modified to execute an uninstall quietly and without restarting.
  foreach ($ver in $qtVer) {
    if ($ver.UninstallString) {
      $uninst = $ver.UninstallString
      $uninst = $uninst -replace "/I", "/x "
      myLogThis -EventId 45 -Message ($FunctionTop + "Uninstalling " + $ver.DisplayName + " using $uninst")
      $Process = Start-Process cmd -ArgumentList "/c $uninst /quiet /norestart" -NoNewWindow -Wait -PassThru
      myLogThis -EventId 46 -Message ($FunctionTop + "Uninstall resulted in exit code " + $Process.ExitCode)
      
      # If the process exited with a code higher than our base (such as 1619 or 3010), use that as our function exit code
      if ($Process.ExitCode -gt $Result) { $Result = $Process.ExitCode }
    }
  }
  
  # Return our final result
  Return $Result
}
