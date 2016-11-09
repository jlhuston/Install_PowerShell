# This function configures the application; only called if the install succeeded.
Function myConfigureApplication {
  $FunctionTop = "myConfigureApplication`r`n`r`n"
  myLogThis -EventId 60 -Message ($FunctionTop + 'Starting function')

  Write-Host "`r`nConfiguring $AppName..."
  
  # Add policy to prevent update to 64-bit registry
  $RegistryPath = "HKLM:\SOFTWARE\JavaSoft\Java Update\Policy"; $Name = "EnableJavaUpdate"; $Value = 0
  if (!(Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
  New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force | Out-Null

  # Add policy to prevent update to 32-bit registry
  $RegistryPath = "HKLM:\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy"
  if (!(Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
  New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force | Out-Null

  # Remove update reminder applet from 64-bit registry
  $RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; $Name = "SunJavaUpdateSched"
  if (Test-Path $RegistryPath) {
    $Task = Get-ItemProperty -Path $RegistryPath -Name $Name -ErrorAction SilentlyContinue
    if ($Task -ne $null) { Remove-ItemProperty -Path $RegistryPath -Name $Name -Force }
  }

  # Remove update reminder applet from 32-bit registry
  $RegistryPath = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run"
  if (Test-Path $RegistryPath) {
    $Task = Get-ItemProperty -Path $RegistryPath -Name $Name -ErrorAction SilentlyContinue
    if ($Task -ne $null) { Remove-ItemProperty -Path $RegistryPath -Name $Name -Force }
  }
}
