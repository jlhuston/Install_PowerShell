$EventMessageTop = ($AppName + ' ' + $AppVersion + "`r`n`r`n")

Function myEnsureLogExists {
  if ((Get-EventLog -List | where { $_.Log -eq ($CompanyName + ' Mgmt') }).Length -eq 0) {
    New-EventLog -LogName ($CompanyName + ' Mgmt') -Source 'Install'
    Limit-EventLog -LogName ($CompanyName + ' Mgmt') -OverflowAction OverwriteAsNeeded -MaximumSize 524288
  }
  if (!([System.Diagnostics.EventLog]::SourceExists("Install"))) {
    New-EventLog -LogName ($CompanyName + ' Mgmt') -Source 'Install'
  }
}

Function myLogThis {
  param ([Int32]$EventId=0, [String]$Message="", [String]$EntryType="Information")

  Write-EventLog -LogName ($CompanyName + ' Mgmt') -Source 'Install' -EventId $EventId -EntryType $EntryType -Message ($EventMessageTop + $Message)
}
