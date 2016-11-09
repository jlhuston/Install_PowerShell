# Get the version number of the currently installed app.  If this isn't installed, we'll get $null back
myLogThis -EventId 10 -Message 'Calling out to myGetCurrentVersionFromMSI to get currently installed version'
$TestVer = myGetCurrentVersionFromMSI -Query "*Java*Update*" -VersionValue "DisplayVersion"
