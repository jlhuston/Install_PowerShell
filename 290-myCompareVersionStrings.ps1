# This function parses two dotted version strings and returns a value, -1, 0, 1, depending if the values are less, equal, or greater than each other.
# -1 = A newer version is installed
#  0 = The same version is installed
#  1 = An older version is installed; should upgrade in this instance.
Function myCompareVersionStrings {
  param ([Parameter(Mandatory=$True)][String]$MinVer, [Parameter(Mandatory=$True)][String]$TestVer)
  $FunctionTop = "myCompareVersionStrings`r`n`r`n"
  myLogThis -EventId 30 -Message ($FunctionTop + 'MinVer : ' + $MinVer + "`r`n" + 'TestVer : ' + $TestVer)

  # Split the two version strings into version parts, based on the period as a separator
  $VMin = $MinVer.split('.')
  $VTest = $TestVer.split('.')
  myLogThis -EventId 31 -Message ($FunctionTop + 'Split MinVer into ' + $VMin.Length + ' parts - ' + $MinVer + "`r`n" + 'Split TestVer into ' + $VTest.Length + ' parts - ' + $TestVer)

  # Iterate through each part of MinVer, stacking on padded string values
  $SMin = ""; $STest = ""
  for ($i = 0; $i -lt $VMin.Length; $i++) {
    if ($i -lt $VTest.Length) {
      myLogThis -EventId 32 -Message ($FunctionTop + "Padding version parts from both strings`r`n`r`nVMin[" + $i + "] : " + $VMin[$i] + "`r`nVTest[" + $i + "] : " + $VTest[$i])
      $PartLength=[Math]::Max($VMin[$i].Length,$VTest[$i].Length)
      $SMin+=(' ' * ($PartLength - $VMin[$i].Length)) + $VMin[$i]
      $STest+=(' ' * ($PartLength - $VTest[$i].Length)) + $VTest[$i]
      myLogThis -EventId 35 -Message ($FunctionTop + "Padding Progress`r`n`r`nSMin : |" + $SMin + "|`r`nSTest : |" + $STest + "|")
    } else {
      myLogThis -EventId 33 -Message ($FunctionTop + "Padding version parts that don't exist in Test`r`n`r`nVMin[" + $i + "] : " + $VMin[$i])
      $SMin+=$VMin[$i]
      $STest+=(' ' * $VMin[$i].Length)
      myLogThis -EventId 35 -Message ($FunctionTop + "Padding Progress`r`n`r`nSMin : |" + $SMin + "|`r`nSTest : |" + $STest + "|")
    }
  }

  # Iterate through any additional parts of TestVer if there are more of them than MinVer parts
  for ($i = $VMin.Length; $i -lt $VTest.Length; $i++) {
    myLogThis -EventId 34 -Message ($FunctionTop + "Padding version parts that don't exist in Min`r`n`r`nVTest[" + $i + "] : " + $VTest[$i])
    $SMin+=(' ' * $VTest[$i].Length)
    $STest+=$VTest[$i]
    myLogThis -EventId 35 -Message ($FunctionTop + "Padding Progress`r`n`r`nSMin : |" + $SMin + "|`r`nSTest : |" + $STest + "|")
  }

  Write-Host ("  Comparing Minimum Version : |" + $SMin + "|")
  Write-Host ("       to Installed Version : |" + $STest + "|")
  $Result = [String]::Compare($SMin,$STest,$True)
  myLogThis -EventId 36 -Message ($FunctionTop + "Comparing SMin to STest resulted in code " + $Result)
  if ($Result -lt 1) {
    Write-Host -ForegroundColor Green "  The current or a newer version is installed."
  } else {
    Write-Host -ForegroundColor Yellow "  An older version is installed."
  }
  Return $Result
}
