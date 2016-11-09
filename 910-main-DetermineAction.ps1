# If no options are specified (or more than one were specified), ask the user what to do
if (($Install.ToBool() + $Update.ToBool() + $Uninstall.ToBool() + $CheckVersion.ToBool()) -ne 1) {
  # Force all switches to $False
  $Install = $False; $Update = $False; $Uninstall = $False; $CheckVersion = $False

  myLogThis -EventId 7 -Message 'No startup switch specified - asking user'
  $title = "Application Maintenance"
  $message = "Please select an action to accomplish for ${AppName}:"
  $option1 = New-Object System.Management.Automation.Host.ChoiceDescription "&Install","Install $AppName"
  $option2 = New-Object System.Management.Automation.Host.ChoiceDescription "&Update","Update $AppName if it is already installed"
  $option3 = New-Object System.Management.Automation.Host.ChoiceDescription "U&ninstall","Uninstall $AppName from the system"
  $option4 = New-Object System.Management.Automation.Host.ChoiceDescription "&Check Version","Check the version of $AppName against $AppVersion"
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($option1,$option2,$option3,$option4)
  $result = $host.ui.PromptForChoice($title,$message,$options,0)
  switch ($result) {
    0 { $Install = $True }
    1 { $Update = $True }
    2 { $Uninstall = $True }
    3 { $CheckVersion = $True }
  }
  Write-Host "`r`n`r`n"
}

# Note in the log what we're doing
if ($Install) { myLogThis -EventId 2 -Message 'Install switch specified'; Write-Host "Working to install $AppName $AppVersion`r`n`r`n" }
if ($Update) { myLogThis -EventId 2 -Message 'Update switch specified'; Write-Host "Working to update $AppName to $AppVersion`r`n`r`n" }
if ($Uninstall) { myLogThis -EventId 2 -Message 'Uninstall switch specified' -EventType "Warning"; Write-Host -ForegroundColor Red "Working to uninstall $AppName`r`n`r`n" }
if ($CheckVersion) { myLogThis -EventId 2 -Message 'CheckVersion switch specified'; Write-Host "Checking the installed version of $AppName against $AppVersion`r`n`r`n" }
