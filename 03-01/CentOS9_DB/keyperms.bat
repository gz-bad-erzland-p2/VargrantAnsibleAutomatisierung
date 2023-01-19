@ECHO OFF

SETLOCAL 

:: # set machines path to lnxhost as example
Set "Machines=%~dp0.vagrant\machines\lnxhost"

:: # call function to remove unwanted permissions
Call :RemACLs %machines%\vmware_desktop\private_key
		
pause
EXIT /B %ERRORLEVEL%

:RemACLs
IF EXIST %~1 (
   rem echo %~1
   
   :: # Remove Inheritance:
    Icacls %~1 /c /t /Inheritance:d > nul

   :: # Set Ownership
    rem # Key's within "%UserProfile%":
    Icacls %~1 /c /t /Grant %UserName%:F > nul

    rem # Key's outside of "%UserProfile%":
    TakeOwn /F %~1 > nul
    Icacls %~1 /c /t /Grant:r %UserName%:F > nul

   :: # Remove All Users, except for Owner:
    Icacls %~1 /c /t /Remove:g "VORDEFINIERT\Administratoren" > nul
    Icacls %~1 /c /t /Remove:g "VORDEFINIERT\Benutzer" > nul

    Icacls %~1 /c /t /Remove:g "Authentifizierte Benutzer" > nul
    Icacls %~1 /c /t /Remove:g "SYSTEM" > nul

   :: # Verify:
    Icacls %~1
   ) ELSE ( 
   echo File "%~1" doesn't exist.
   )

EXIT /B 0
