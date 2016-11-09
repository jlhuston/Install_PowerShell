# Determine the final exit code to be returned.
if ($UninstallResult -eq 3010) {
  $FinalResult = 3010
} else {
  $FinalResult = $InstallResult
}

Write-Host "`r`n`r`nFinal result being returned is code $FinalResult"
myLogThis -EventId 9 -Message "Final result being returned is $FinalResult"

Start-Sleep -Seconds 5

$Host.SetShouldExit($FinalResult)
exit $FinalResult
