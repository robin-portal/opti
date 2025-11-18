@echo off
title Automatisation des manips et optimisations pour Windows 11 - Robin
mode con: cols=120 lines=40
echo ================================================================
echo Automatisation des manips et optimisations pour Windows 11
echo  - Robin
echo ================================================================
echo.
set /p LAUNCH="Entrez ok pour executer : "
if /i not "%LAUNCH%"=="ok" (
    echo.
    echo Annulation.
    pause
    exit /b
)
echo.
echo Execution en cours...
echo.

:: -----------------------------------------------------------
:: CREATION DU .REG INTERNE
:: -----------------------------------------------------------
set "REGFILE=%TEMP%\config_opti.reg"
(
    echo Windows Registry Editor Version 5.00
    echo.
    echo [HKEY_CURRENT_USER\Control Panel\Desktop]
    echo "AutoEndTasks"="1"
    echo "HungAppTimeout"="1000"
    echo "MenuShowDelay"="8"
    echo "WaitToKillAppTimeout"="2000"
    echo.
    echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control]
    echo "WaitToKillServiceTimeout"="2000"
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
    echo "HideFileExt"=dword:00000000
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching]
    echo "SearchOrderConfig"=dword:00000000
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
    echo "GlobalUserDisabled"=dword:00000001
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search]
    echo "BackgroundAppGlobalToggle"=dword:00000000
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy]
    echo "LetAppsRunInBackground"=dword:00000002
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance]
    echo "MaintenanceDisabled"=dword:00000001
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR]
    echo "value"="00000000"
    echo.
    echo [HKEY_CURRENT_USER\System\GameConfigStore]
    echo "GameDVR_Enabled"=dword:00000000
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR]
    echo "AllowGameDVR"=dword:00000000
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR]
    echo "AppCaptureEnabled"=dword:00000000
    echo.
    echo [HKEY_CURRENT_USER\Control Panel\Mouse]
    echo "MouseSensitivity"="10"
    echo "SmoothMouseXCurve"=hex:00,00,00,00,00,00,00,00,C0,CC,0C,00,00,00,00,00,80,99,19,00,00,00,00,00,40,66,26,00,00,00,00,00,00,33,33,00,00,00,00,00
    echo "SmoothMouseYCurve"=hex:00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00
    echo.
    echo [HKEY_USERS\.DEFAULT\Control Panel\Mouse]
    echo "MouseSpeed"="0"
    echo "MouseThreshold1"="0"
    echo "MouseThreshold2"="0"
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games]
    echo "Affinity"=dword:00000000
    echo "Background Only"="False"
    echo "Clock Rate"=dword:00002710
    echo "GPU Priority"=dword:00000008
    echo "Priority"=dword:00000006
    echo "Scheduling Category"="High"
    echo "SFIO Priority"="High"
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
    echo "ShowTaskViewButton"=dword:00000000
    echo "ShowSearchBoxTaskbarMode"=dword:00000000
    echo "TaskbarDa"=dword:00000000
    echo "TaskbarSi"=dword:00000000
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications]
    echo "ToastEnabled"=dword:00000000
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PenWorkspace]
    echo "PenWorkspaceButtonDesiredVisibility"=dword:00000000
    echo.
    echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
    echo "SubscribedContent-310093Enabled"=dword:00000000
    echo "SubscribedContent-338388Enabled"=dword:00000000
    echo "SubscribedContent-338389Enabled"=dword:00000000
    echo "SubscribedContent-353694Enabled"=dword:00000000
    echo "SubscribedContent-353696Enabled"=dword:00000000
    echo "SystemPaneSuggestionsEnabled"=dword:00000000
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
    echo "AllowTelemetry"=dword:00000000
    echo "MaxTelemetryAllowed"=dword:00000000
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search]
    echo "AllowCortana"=dword:00000000
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds]
    echo "EnableFeeds"=dword:00000000
) > "%REGFILE%"
echo Importation du fichier .reg...
reg import "%REGFILE%" >nul 2>&1
del "%REGFILE%" >nul 2>&1
echo OK.
echo.

:: -----------------------------------------------------------
:: DESACTIVER DISCORD AU DEMARRAGE
:: -----------------------------------------------------------
echo Desactivation de Discord au demarrage...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "com.squirrel.Discord.Discord" /f >nul 2>&1
echo Discord desactive au demarrage.
echo.

:: -----------------------------------------------------------
:: SERVICES
:: -----------------------------------------------------------
echo Desactivation des services...
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc stop DPS >nul 2>&1
sc config DPS start= disabled >nul 2>&1
sc stop TabletInputService >nul 2>&1
sc config TabletInputService start= disabled >nul 2>&1
sc stop RmSvc >nul 2>&1
sc config RmSvc start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
echo Services desactives.
echo.

:: -----------------------------------------------------------
:: EFFETS VISUELS
:: -----------------------------------------------------------
echo Optimisation des effets visuels...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ExtendedUIHoverTime /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f >nul
echo Effets visuels optimises.
echo.

:: -----------------------------------------------------------
:: ULTIMATE PERFORMANCE
:: -----------------------------------------------------------
echo Activation du plan Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
for /f "tokens=3" %%p in ('powercfg /list ^| findstr /i e9a42b02-d5df') do set "UP=%%p"
if defined UP powercfg /setactive %UP% >nul
echo Plan de puissance Ultimate Performance active.
echo.

:: -----------------------------------------------------------
:: MENU CONTEXTUEL WIN10
:: -----------------------------------------------------------
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /d "" /f >nul
echo Menu contextuel Windows 10 active.
echo.

echo ================================================================
echo        Optimisation terminee ! (Robin Edition)
echo  Redemarrez votre PC pour appliquer tous les changements.
echo ================================================================
echo.
pause
