@echo on
setlocal

echo.
echo Building install.ps1 script from Source folder
echo.

mkdir BuildTemp
copy Source\*.ps1 BuildTemp
copy /y Source2\*.ps1 BuildTemp

if exist Install.ps1 del Install.ps1

powershell -command "& { Get-ChildItem '%CD%\BuildTemp' | foreach { $_ | Get-Content >> '%CD%\Install.ps1' }}"

rd /s /q BuildTemp
