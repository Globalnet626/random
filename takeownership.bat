:::::::::::::::::::::::::::::::::::::::::::
:: Take Ownership of UnityEngine.dll - Prevent DMM from patching your translation
:: Partly by Globalnet
:: V 1.0 - 4/17/2020
:: Requires Administrator Privileges
:: Run in your \alicegearaegisexe\alice_Data\Managed folder
::::::::::::::::::::::::::::::::::::::::::::
:: Elevate.cmd - Version 4 -Matt from StackOverflow
:: Automatically check & get admin rights
:: see "https://stackoverflow.com/a/12264592/1016343" for description and source
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 CLS
 ECHO.
 ECHO =============================
 ECHO Take Ownership of UnityEngine.dll - Prevent DMM from patching your translation
 ECHO Partly by Globalnet - V 1.0 - 4/17/2020
 ECHO UAC elevate portion by Matt from StackOverflow
 ECHO Run in your \alicegearaegisexe\alice_Data\Managed folder
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::Ownership taking code here
 ::::::::::::::::::::::::::::
takeown /F UnityEngine.dll
attrib +R UnityEngine.dll
ECHO Chainging Privileges now.
cacls UnityEngine.dll  /P Everyone:r "Authenticated Users:R" "Users:R" SYSTEM:R Administrators:R
ECHO You may now exit this program
cmd /k
