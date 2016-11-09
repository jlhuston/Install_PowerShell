# Be sure that we're running as an elevated admin account; if not, elevate us.
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the admin role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running as admin
if ($myWindowsPrincipal.IsInRole($adminRole)) {
  # We are elevated - nothing more to do
} else {
  # We are not running as admin - relaunch as admin

  # Create a new process object that starts PowerShell
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"

  # Specify the current script path and name as a parameter
  $newProcess.Arguments = $myInvocation.MyCommand.Definition

  # Indicate that the process should be elevated
  $newProcess.Verb = "runas"

  # Start the new process
  $Process = [System.Diagnostics.Process]::Start($newProcess);
  $Process.WaitForExit()
  $EC = $Process.ExitCode

  # Exit from the current, unelevated process
  $Host.SetShouldExit($EC)
  exit $EC
}
