# Calculated variables.  These are created from the above global variables.
$AppMainVersion = $AppVersion.split('.')
$InstallPackage=("jre1." + $AppMainVersion[0] + "." + $AppMainVersion[1] + "_" + $AppMainVersion[2].substring(0,($AppMainVersion[2].Length-1)) + ".msi")
