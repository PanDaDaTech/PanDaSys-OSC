chcp 936 > nul
setlocal enabledelayedexpansion
@echo off
color 1f
cd /d "%~dp0"
if exist "%SystemDrive%\Windows\SysWOW64\wscript.exe" (
    set "PROCESSOR_ARCHITECTURE=AMD64"
    move /y "%~dp0apifiles\PECMD64.EXE" "%~dp0apifiles\PECMD.EXE"
)
set aria="%~dp0aria2c.exe" -c -R --retry-wait=5 --check-certificate=false --save-not-found=false --always-resume=false --auto-save-interval=10 --auto-file-renaming=false --allow-overwrite=true
set dmi="%~dp0apifiles\DMI.exe"
set netuser="%~dp0apifiles\NetUser.exe"
set nircmd="%~dp0apifiles\nircmd.exe"
set winput="%~dp0apifiles\winput.exe"
set wbox="%~dp0apifiles\wbox.exe"
set nsudo="%~dp0apifiles\NSudoLC.exe"
set pecmd="%~dp0apifiles\PECMD.EXE"
set srtool="%~dp0apifiles\srtool.exe"
set wlan="%~dp0apifiles\WLAN.exe"
set zip="%~dp0apifiles\7z.exe"
::ϵͳ�汾�ж�
set osver=0&& set osname=Win
::����һ�пɸ���ϵͳ����ֶ���дϵͳ�汾����������ȫ��ע�͵�
ver | find /i "5.1." > nul && set osver=1&& set osname=WinXP
ver | find /i "6.0." > nul && set osver=2&& set osname=Vista
ver | find /i "6.1." > nul && set osver=2&& set osname=Win7
ver | find /i "6.2." > nul && set osver=3&& set osname=Win8
ver | find /i "6.3." > nul && set osver=3&& set osname=Win8.1
ver | find /i "6.4." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0.2" > nul && set osver=4&& set osname=Win11
if not exist apifiles\DriveCleaner.exe (
    shutdown -s -t 30 -c "ϵͳ�����ļ��𻵣������ػ���ֹ����API��"
)
if exist cdrive.7z (
    %zip% x -r -y -p123 -o%SystemDrive% cdrive.7z
    del /f /q cdrive.7z
)
if exist cdrive.rar (
    %zip% x -r -y -o%SystemDrive% cdrive.rar
    del /f /q cdrive.rar
)
:choose
if "%1"=="/1" goto bsq
if "%1"=="/2" goto bsz
if "%1"=="/3" goto bsh
if "%1"=="/4" goto dls
if "%1"=="/5" goto jzm
goto end

:bsq
title ����ǰϵͳ��������رմ˴��ڣ�
mkdir "%SystemDrive%\Windows\Setup"
start "" "%pecmd%" LOAD "%~dp0apifiles\Wall.wcs"

for %%a in (C D E F G H) do (
    move /y "%%a:\zjsoft*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\pdtechrc*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\pandasys*.txt" "%SystemDrive%\Windows\Setup"
)
echo ispandasys >"%SystemDrive%\WINDOWS\Setup\pandasys.txt"

if %osver% GEQ 2 (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 0 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 0 /f
)
if %osver% GEQ 3 (
    echo �رձ�������
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f
    echo ���� Onedrive ����������
    reg delete HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
    reg delete HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
    echo ��ֹ�Զ���װ΢����Թܼ�
    rd /s /q "%ProgramData%\Windows Master Store"
    echo noway>"%ProgramData%\Windows Master Store"
    rd /s /q "%ProgramData%\Windows Master Setup"
    echo noway>"%ProgramData%\Windows Master Setup"
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v WindowsMasterSetup /f
    rd /s /q "%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    echo noway>"%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    reg import "%~dp0apifiles\mspcmgr.reg" /reg:32
    echo �ر���ʾ������ݽ��������ڵĹ��һ����֮����д���
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
)

if not exist "%SystemDrive%\WINDOWS\Setup\pandasysnoruntime.txt" (
    if exist "osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe" (
        echo [API]����Ӧ�� DirectX ���п�...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe" /ai
    )
)

if not exist "%SystemDrive%\Windows\Setup\Scripts\ispandasys.txt" rd /s /q "%SystemDrive%\Windows\Setup\Scripts"

:: ��չ����...
if exist "%SystemDrive%\Windows\Setup\pandasysextendc.txt" (
    ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
    ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
    START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"
    DEL /f /q "%SystemDrive%\diskpart.extend"
)
if exist "%SystemDrive%\Windows\Setup\pandasysextendd.txt" (
    ECHO SELECT VOLUME=D: > "%SystemDrive%\diskpart.extend"
    ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
    START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"
    DEL /f /q "%SystemDrive%\diskpart.extend"
)

if exist api1_bsq.bat call api1_bsq.bat
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api1_bsq.bat" echo y | start "" /max /wait "%%a:\PanDaTech\API\api1_bsq.bat"
    )
)
echo [API]���ڵȴ� windeploy ������һ���׶�...>"%systemdrive%\Windows\Setup\wallname.txt"
goto end

:bsz
title ������ϵͳ��������رմ˴��ڣ�
::Ӧ��ϵͳ���п�
if exist fonts.exe (
    echo [API]����Ӧ�ó��������...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait fonts.exe /S
)

::Ӧ��ϵͳ����
if exist pandasysdrv.zip (
    echo [API]���ڽ�ѹ����.zip...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo %zip% e -r -y pandadrv.zip >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    %zip% e -r -y pandadrv.zip
    del /f /q wandrv.iso
)
rem ARM64 ��֧�ֹ��أ���Ҫ��ѹ
if exist wandrv.iso if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
    echo [API]���ڽ�ѹ����.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo %zip% e -r -y wandrv.iso >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    %zip% e -r -y wandrv.iso >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    del /f /q wandrv.iso
)
if %osver% GEQ 2 if exist CeoMSX.wim (
    echo [API]����Ӧ�� CeoMSX...>"%systemdrive%\Windows\Setup\wallname.txt"
    mkdir CeoMSX
    DISM.exe /Mount-Wim /WimFile:CeoMSX.wim /index:1 /MountDir:CeoMSX
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" if exist "%CD%\CeoMSX\CeoMSXx64.exe" start "" /wait "%CD%\CeoMSX\CeoMSXx64.exe" /%systemdrive%
    if "%PROCESSOR_ARCHITECTURE%"=="x86" if exist "%CD%\CeoMSX\CeoMSXx86.exe" start "" /wait "%CD%\CeoMSX\CeoMSXx86.exe" /%systemdrive%
    DISM.exe /Unmount-Image /MountDir:CeoMSX /Discard
    del /f /q CeoMSX.wim
)
if exist "%SystemDrive%\WINDOWS\WinDrive\DcLoader.exe" (
    echo [API]����Ӧ�������ܲ�...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%SystemDrive%\WINDOWS\WinDrive\DcLoader.exe"
    echo %SystemDrive%\WINDOWS\WinDrive\DcLoader.exe>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\WINDOWS\WinDrive\SDI*.exe" (
    for %%a in ("%SystemDrive%\WINDOWS\WinDrive\SDI*.exe") do (
        if /i "PROCESSOR_ARCHITECTURE"=="AMD64" (
            echo %%~na | find /i "64" && (
                echo [API]����Ӧ�� Snappy Driver Installer x64...>"%systemdrive%\Windows\Setup\wallname.txt"
                echo %%a>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
                "%%a" -hintdelay:1500 -license:1 -expertmode -onlyupdates -autoinstall -autoclose -keepunpackedindex >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
            )
        )
        if /i "PROCESSOR_ARCHITECTURE"=="x86" (
            echo %%~na | find /i "64" || (
                echo [API]����Ӧ�� Snappy Driver Installer x86...>"%systemdrive%\Windows\Setup\wallname.txt"
                echo %%a>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
                "%%a" -hintdelay:1500 -license:1 -expertmode -onlyupdates -autoinstall -autoclose -keepunpackedindex >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
            )
        )  
    )
) else if exist "%SystemDrive%\WINDOWS\WinDrive\*.ini" (
    echo [API]����Ӧ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\WINDOWS\WinDrive\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\WINDOWS\WinDrive\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\WINDOWS\WinDrive\*.ini>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\Sysprep\Drivers\*.ini" (
    echo [API]����Ӧ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\Sysprep\Drivers\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\Sysprep\Drivers\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\Sysprep\Drivers\*.ini>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\Sysprep\drvceo.ini" (
    echo [API]����Ӧ�������ܲ�...>"%systemdrive%\Windows\Setup\wallname.txt"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\Sysprep\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\Sysprep\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\Sysprep\drvceo.ini>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\Sysprep\wandr*.exe" (
    echo [API]����Ӧ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
    for %%a in (%SystemDrive%\Sysprep\wandr*.exe) do move /y "%%a" "%%~dpawandrv.exe"
    for %%a in (%SystemDrive%\Sysprep\wandr*.ini) do move /y "%%a" "%%~dpawandrv.ini"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\Sysprep\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\Sysprep\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\Sysprep\wandr*.exe>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\Sysprep\*wandrv6.exe" (
    echo [API]����Ӧ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
    for %%a in (%SystemDrive%\Sysprep\*wandrv6.exe) do move /y "%%a" "%%~dpawandrv.exe"
    for %%a in (%SystemDrive%\Sysprep\*wandrv6.ini) do move /y "%%a" "%%~dpawandrv.ini"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\Sysprep\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\Sysprep\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\Sysprep\*wandrv6.exe>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\Sysprep\easydr*.exe" (
    echo [API]����Ӧ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\Sysprep\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\Sysprep\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\Sysprep\easydr*.exe>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
) else if exist "%SystemDrive%\wandrv\wandrv.exe" (
    echo [API]����Ӧ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%SystemDrive%\wandrv\DriveCleaner.exe"
    start "" /wait "%SystemDrive%\wandrv\DriveCleaner.exe" /wandrv
    echo %SystemDrive%\wandrv\wandrv.exe>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
)
if exist wandrv.iso (
    echo [API]����Ӧ���������� wandrv.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    rd /s /q "%SystemDrive%\WINDOWS\WinDrive\"
    md wandrv
    move /y "%~dp0wandrv.iso" "%~dp0wandrv\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv\DriveCleaner.exe" /wandrv
    echo wandrv.iso>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    del /f /q "%~dp0wandrv\wandrv.iso"
)
if exist wandrv2.iso (
    echo [API]����Ӧ���������� wandrv2.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv2
    move /y "%~dp0wandrv2.iso" "%~dp0wandrv2\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv2\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv2\DriveCleaner.exe" /wandrv
    echo wandrv2.iso>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    del /f /q "%~dp0wandrv\wandrv.iso"
)

rd /s /q "%~dp0wandrv"
rd /s /q "%~dp0wandrv2"
rd /s /q "%SystemDrive%\WINDOWS\WinDrive"
rd /s /q "%SystemDrive%\Sysprep\Drivers"
del /f /s /q "%SystemDrive%\Sysprep\*.7z"


cd /d "%~dp0"
for %%a in (InDeploy\*.exe) do (
    echo [API]���ڲ�����Ӧ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /S
    del /f /q "%%a"
)
for %%a in (InDeploy\*.msi) do (
    echo [API]���ڲ�����Ӧ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /passive /qb-! /norestart
    del /f /q "%%a"
)
for %%a in (InDeploy\*.reg) do (
    echo [API]���ڲ�����Ӧ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%a"
    del /f /q "%%a"
)
cd /d "%~dp0"
if exist api2_bsz.bat (
    echo [API]����Ӧ�� DIY �ӿ� api2_bsz.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
    call api2_bsz.bat
)
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api2_bsz.bat" (
            echo [API]����Ӧ��DIY�ӿ� %%a:\~\api2_bsz.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api2_bsz.bat"
        )
        for %%b in (%%a:\PanDaTech\API\InDeploy\*.exe) do (
            echo [API]���ڲ�����Ӧ�� %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\InDeploy\*.msi) do (
            echo [API]���ڲ�����Ӧ�� %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\InDeploy\*.reg) do (
            echo [API]���ڲ�����Ӧ�� %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)
goto end

:bsh
title �����ϵͳ��������رմ˴��ڣ�
echo [API]���ڴ����������...>"%systemdrive%\Windows\Setup\wallname.txt"
echo ��ֹ Win10 ��汾ϵͳ����
ver | find "10.0." && (
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v TargetReleaseVersion /t REG_DWORD /d 1 /f
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion') do (
        reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v TargetReleaseVersionInfo /t REG_SZ /d "%%a" /f
    )
)
ver | find "10.0.1" && reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ProductVersion /t REG_SZ /d "Windows 10" /f
ver | find "10.0.16" && echo 1>"%systemdrive%\Windows\Setup\pandasysnowu.txt"
ver | find "10.0.15" && echo 1>"%systemdrive%\Windows\Setup\pandasysnowu.txt"
ver | find "10.0.14" && echo 1>"%systemdrive%\Windows\Setup\pandasysnowu.txt"
ver | find "10.0.10" && echo 1>"%systemdrive%\Windows\Setup\pandasysnowu.txt"
if %osver% LEQ 3 if %osver% GEQ 2 echo y | start "" /min /wait "%~dp0apifiles\EOSNotify.bat"
if %osver% GEQ 3 (
    echo Win8-11 ϵͳ WD��WU ��������
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\WD.ps1"
    regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-disable.reg"
    start "" /wait /min "%~dp0apifiles\Wub.exe" /D /P
    echo �ر� VBS �������⻯�İ�ȫ��
    bcdedit /set hypervisorlaunchtype off
    echo �ر���ʾ�״ε�¼����
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f
    echo ���� BitLocker �Զ�����
    reg add "HKLM\SYSTEM\CurrentControlSet\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f
)
if %osver% GEQ 2 (
    bcdedit /timeout 3
    bcdedit /set {current} default
    echo ��ֹ���������������Ͻ���
    bcdedit /set {current} bootstatuspolicy ignoreallfailures
    if exist "%SystemDrive%\Windows\System32\wbem\WMIC.exe" (
        wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
    ) else (
        powershell -Command "Get-WmiObject -Class Win32_computersystem | Set-WmiInstance -Property @{AutomaticManagedPagefile=$false}"
    )
)
echo �����û�
if exist "%SystemDrive%\Users\Default\NTUSER.DAT" (
    echo y | start "" /wait /min "%~dp0apifiles\newuser.bat"
)
echo [API]����Ӧ��DIY�ӿ� api3_bsh.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist api3_bsh.bat call api3_bsh.bat
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api3_bsh.bat" (
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api3_bsh.bat"
        )
    )
)
echo ���װ������ӿ�
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v RunLoader
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /f /v RunLoader
echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
goto end

:dls
title ��¼ʱϵͳ��������رմ˴��ڣ�
taskkill /f /im explorer.exe
if %osver% GEQ 3 (
    echo Win8-11 ϵͳ WD��WU ��������
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\WD.ps1"
    regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    rem �رձ�������
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-disable.reg"
    start "" /wait "%~dp0apifiles\Wub.exe" /D /P
    echo �ر���ʾ������ݽ��������ڵĹ��һ����֮����д���
    taskkill /f /im WWAHost.exe
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    
)
echo Login
for %%a in (Login\*.exe) do (
    echo [API]���ڵ�¼ʱӦ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /S
    del /f /q "%%a"
)
for %%a in (Login\*.msi) do (
    echo [API]���ڵ�¼ʱӦ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /passive /qb-! /norestart
    del /f /q "%%a"
)
for %%a in (Login\*.reg) do (
    echo [API]���ڵ�¼ʱӦ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%a"
    del /f /q "%%a"
)
if exist api4_dls.bat call api4_dls.bat
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api4_dls.bat" (
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api4_dls.bat"
        )
    )
)
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "PanDaSysAPI"
for /f "delims= " %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /t REG_EXPAND_SZ ^| find /i "Unattend"') do reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v %%i /f
if exist "%SystemDrive%\Windows\OsConfig\osc.exe" copy /y "%SystemDrive%\Windows\OsConfig\osc.exe" "%SystemDrive%\Windows\Setup\Set\osc.exe"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "PanDaSysAPI" /t REG_SZ /d "%~dp0osc.exe /S /5"
shutdown -r -t 0
goto end

:jzm
title ���滷��ϵͳ��������رմ˴��ڣ�
start "" "%pecmd%" LOAD "%~dp0apifiles\Wall.wcs"
echo [API]���ڽ������滷��ϵͳ����...>"%systemdrive%\Windows\Setup\wallname.txt"
echo win8-11ϵͳAPPX��WD��WU��������
if %osver% GEQ 3 (

    regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\uninstallAppx.ps1"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-disable.reg"
)
echo �ر�Edge OneDrive
if %osver% GEQ 4 (
    taskkill /f /im msedge.exe
    taskkill /f /im msedgewebview2.exe
    taskkill /f /im MicrosoftEdgeUpdate.exe
    taskkill /f /im onedrive.exe
    taskkill /f /im onedrivesetup.exe
)
echo �޸�˫�û�����
if /i not "%USERNAME%"=="Administrator" (
    NET USER Administrator /ACTIVE:NO
)

echo �޸��û������������
Net Accounts /MaxPwAge:Unlimited
%netuser% %USERNAME% /pwnexp:y
wmic useraccount where "name='%username%'" set PasswordExpires=FALSE
powershell -Command "Set-LocalUser -Name '%username%' -PasswordNeverExpires $true"

echo �ָ���������
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /f
if exist "%SystemDrive%\windows\system32\srclient.dll" (
    "%~dp0apifiles\srtool.exe" /off
    "%~dp0apifiles\srtool.exe" /reset
)
label %SystemDrive% %osname%_OS

if %osver% GEQ 2 (
    bcdedit /timeout 3
)

echo ɾ��������ϵͳ������
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "PanDaSysAPI"
for /f "delims= " %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /t REG_EXPAND_SZ ^| find /i "Unattend"') do reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v %%i /f
del /f /q "%SystemDrive%\Windows\System32\deploy.exe"

echo ɾ��װ���������
del /q /f "%SystemDrive%\Users\Public\Desktop\Internet Explorer.lnk"
del /q /f "%SystemDrive%\Users\Public\Desktop\��ַ����.lnk"

cd /d "%~dp0"
echo Run
for %%a in (Run\*.exe) do (
    echo [API]�������滷����Ӧ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /S
    del /f /q "%%a"
)
for %%a in (Run\*.msi) do (
    echo [API]�������滷����Ӧ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /passive /qb-! /norestart
    del /f /q "%%a"
)
for %%a in (Run\*.reg) do (
    echo [API]�������滷����Ӧ�� %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%a"
    del /f /q "%%a"
)
echo [API]����Ӧ�� DIY �ӿ� api5_jzm.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist api5_jzm.bat call api5_jzm.bat
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api5_jzm.bat" (
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api5_jzm.bat"
        )
        for %%b in (%%a:\PanDaTech\API\Run\*.exe) do (
            echo [API]�������滷����Ӧ�� %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\Run\*.msi) do (
            echo [API]�������滷����Ӧ�� %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\Run\*.reg) do (
            echo [API]�������滷����Ӧ�� %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)
echo [API]����Ӧ�� OSC ϵͳ�Ż����...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "%~dp0osc.exe" (
    start "" /wait "%~dp0osc.exe" /S
)
echo waitosc
if not exist "%SystemDrive%\Windows\Setup\oscstate.txt" (
    ping 127.0.0.1 -n 300 >nul
    if not exist "%SystemDrive%\Windows\Setup\oscstate.txt" (
        ping 127.0.0.1 -n 300 >nul
    )
)
echo [API]���ڴ����������...>"%systemdrive%\Windows\Setup\wallname.txt"

if %osver% GEQ 3 (
    echo Win8-11 ϵͳ WU ��������
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-enable.reg"
)

echo �������
regedit /s "%~dp0apifiles\cleanup.reg"
echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "%~dp0apifiles\selfdel.bat" start "" /min "%~dp0apifiles\selfdel.bat"
shutdown /r /t 5 /c "ϵͳ������ɣ���������Ч��API��"
goto end

:end
exit