@echo off

:: Original registry cleanup operations
echo Delete HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium\Update
reg delete HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium\Update /f
echo Delete HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium\Registration[version and language]
for /f %%i in ('"REG QUERY "HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium" /s | findstr /L Registration"') do (
    reg delete %%i /va /f
)

echo Delete Info and ShellFolder under HKEY_CURRENT_USER\Software\Classes\CLSID
for /f "tokens=*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Classes\CLSID"') do (
  for /f "tokens=*" %%l in ('reg query "%%a" /f "Info" /s /e ^| findstr /i "Info"') do (
    echo Delete: %%a
    reg delete %%a /f
  )
  for /f "tokens=*" %%l in ('reg query "%%a" /f "ShellFolder" /s /e ^| findstr /i "ShellFolder"') do (
    echo Delete: %%a
    reg delete %%a /f
  )
)

:: Create a scheduled task to run this script daily
echo Creating a scheduled task to run this script daily...
schtasks /create /tn "CleanupTask" /tr "%~dp0cleanup.bat" /sc daily /st 10:00 /f

echo Task created successfully.
