# Toss up a banner and retitle the main window.
$Host.UI.RawUI.WindowTitle=($CompanyName + ' Management of ' + $AppName + ' ' + $AppVersion)
Clear-Host
Write-Host
Write-Host -ForegroundColor Blue (' Computer Management Script for ' + $CompanyName + ' computers')
Write-Host
Write-Host -ForegroundColor Green (' **' + ('*' * $AppName.Length) + '*' + ('*' * $AppVersion.Length) + '**')
Write-Host -ForegroundColor Green -NoNewline ' * '
Write-Host -ForegroundColor Yellow -NoNewline ($AppName + ' ' + $AppVersion)
Write-Host -ForegroundColor Green ' *'
Write-Host -ForegroundColor Green (' **' + ('*' * $AppName.Length) + '*' + ('*' * $AppVersion.Length) + '**')
Write-Host

# Ensure that we have an event log available
myEnsureLogExists

# Record startup
myLogThis -EventId 1 -Message 'Start of Install.ps1'
