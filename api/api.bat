chcp 936 > nul
setlocal enabledelayedexpansion
@echo off
color 1f
cd /d "%~dp0"
if exist "%SystemDrive%\Windows\SysWOW64\wscript.exe" (
    set "PROCESSOR_ARCHITECTURE=AMD64"
    move /y "%~dp0apifiles\PECMD64.EXE" "%~dp0apifiles\PECMD.EXE"
)
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
::系统版本判断
set osver=0&& set osname=Win
::上面一行可根据系统情况手动填写系统版本，并将下面全部注释掉
ver | find /i "5.1." > nul && set osver=1&& set osname=WinXP
ver | find /i "6.0." > nul && set osver=2&& set osname=Vista
ver | find /i "6.1." > nul && set osver=2&& set osname=Win7
ver | find /i "6.2." > nul && set osver=3&& set osname=Win8
ver | find /i "6.3." > nul && set osver=3&& set osname=Win8.1
ver | find /i "6.4." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0.2" > nul && set osver=4&& set osname=Win11
if not exist apifiles\DriveCleaner.exe (
    shutdown -s -t 30 -c "系统部署文件损坏，即将关机终止部署（API）"
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
if "%1"=="/1" goto BeforeDeploy
if "%1"=="/2" goto InDeploy
if "%1"=="/3" goto SetupCompete
if "%1"=="/4" goto FirstLogin
if "%1"=="/5" goto ToDesktop
goto end

:BeforeDeploy
title 部署前系统处理（请勿关闭此窗口）
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
    echo 关闭保留储存
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f
    
    echo 处理 OneDriveSetup 开机启动项
    reg delete HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
    reg delete HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
    SCHTASKS /Change /DISABLE /TN "\Microsoft\OneDrive\OneDrive Per-Machine First Setup Task"
    
    echo 禁止自动安装微软电脑管家
    rd /s /q "%ProgramData%\Windows Master Store"
    echo noway>"%ProgramData%\Windows Master Store"
    rd /s /q "%ProgramData%\Windows Master Setup"
    echo noway>"%ProgramData%\Windows Master Setup"
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v WindowsMasterSetup /f
    rd /s /q "%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    echo noway>"%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    reg import "%~dp0apifiles\mspcmgr.reg" /reg:32

    echo 关闭显示你的数据将在你所在的国家或地区之外进行处理
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    
    echo 避免自动安装 Outlook、DevHome、微软电脑管家、MS Edge 游戏助手
	reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\CrossDeviceUpdate" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.OutlookForWindows_8wekyb3d8bbwe" /f
    reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Windows.DevHome_8wekyb3d8bbwe" /f
    reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MicrosoftPCManager_8wekyb3d8bbwe" /f
    reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\PCManagerUpdate" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Edge.GameAssist_8wekyb3d8bbwe" /f
)

:: 禁用 UCPD 驱动
if exist "%SystemDrive%\Windows\System32\drivers\ucpd.sys" (
    echo 禁用 UCPD 驱动
    sc stop ucpd
    sc config ucpd start= disabled
    schtasks /delete /tn "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" /f
)
if not exist "%SystemDrive%\Windows\Setup\Scripts\ispandasys.txt" rd /s /q "%SystemDrive%\Windows\Setup\Scripts"

:: 扩展分区...
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
echo [API] 正在等待 windeploy 进入下一个阶段...>"%systemdrive%\Windows\Setup\wallname.txt"
goto end

:InDeploy
title 部署中系统处理（请勿关闭此窗口）

::应用系统驱动
if exist wandrv.iso if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
    echo [API] 正在解压驱动.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo %zip% e -r -y wandrv.iso >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    %zip% e -r -y wandrv.iso >>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    del /f /q wandrv.iso
)
if %osver% GEQ 2 if exist CeoMSX.wim (
    echo [API] 正在应用 CeoMSX...>"%systemdrive%\Windows\Setup\wallname.txt"
    mkdir CeoMSX
    DISM.exe /Mount-Wim /WimFile:CeoMSX.wim /index:1 /MountDir:CeoMSX
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" if exist "%CD%\CeoMSX\CeoMSXx64.exe" start "" /wait "%CD%\CeoMSX\CeoMSXx64.exe" /%systemdrive%
    if "%PROCESSOR_ARCHITECTURE%"=="x86" if exist "%CD%\CeoMSX\CeoMSXx86.exe" start "" /wait "%CD%\CeoMSX\CeoMSXx86.exe" /%systemdrive%
    DISM.exe /Unmount-Image /MountDir:CeoMSX /Discard
    del /f /q CeoMSX.wim
)
if exist "%SystemDrive%\WINDOWS\WinDrive\DcLoader.exe" (
    echo [API] 正在应用驱动总裁...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%SystemDrive%\WINDOWS\WinDrive\DcLoader.exe"
    echo %SystemDrive%\WINDOWS\WinDrive\DcLoader.exe>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
)

if exist wandrv.iso (
    echo [API] 正在应用万能驱动 wandrv.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    rd /s /q "%SystemDrive%\WINDOWS\WinDrive\"
    md wandrv
    move /y "%~dp0wandrv.iso" "%~dp0wandrv\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv\DriveCleaner.exe" /wandrv
    echo wandrv.iso>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
    del /f /q "%~dp0wandrv\wandrv.iso"
)
if exist wandrv2.iso (
    echo [API] 正在应用万能驱动 wandrv2.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
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
    echo [API] 正在部署中应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /S
    del /f /q "%%a"
)
for %%a in (InDeploy\*.msi) do (
    echo [API] 正在部署中应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /passive /qb-! /norestart
    del /f /q "%%a"
)
for %%a in (InDeploy\*.reg) do (
    echo [API] 正在部署中应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%a"
    del /f /q "%%a"
)
cd /d "%~dp0"
if exist api2_bsz.bat (
    echo [API] 正在应用 DIY 接口 api2_bsz.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
    call api2_bsz.bat
)
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api2_bsz.bat" (
            echo [API] 正在应用DIY接口 %%a:\~\api2_bsz.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api2_bsz.bat"
        )
        for %%b in (%%a:\PanDaTech\API\InDeploy\*.exe) do (
            echo [API] 正在部署中应用 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\InDeploy\*.msi) do (
            echo [API] 正在部署中应用 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\InDeploy\*.reg) do (
            echo [API] 正在部署中应用 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)
goto end

:SetupCompete
title 部署后系统处理（请勿关闭此窗口）
echo [API] 正在处理后续事项...>"%systemdrive%\Windows\Setup\wallname.txt"
echo 禁止 Win10 大版本系统更新
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
    echo Win8-11 系统 WD、WU 驱动处理
    Dism /online /Disable-Feature /featurename:Windows-Defender-ApplicationGuard /NoRestart
    Dism /online /Disable-Feature /featurename:Windows-Defender-Default-Definitions /NoRestart
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\WD.ps1"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-disable.reg"
    start "" /wait /min "%~dp0apifiles\Wub.exe" /D /P
    
    if exist "%systemdrive%\Windows\Setup\pandasysfkvbs.txt" (
        echo 强制禁用 VBS 及内存完整性检查
        DISM.exe /Online /Disable-Feature:Containers-DisposableClientVM /NoRestart
        DISM.exe /Online /Disable-Feature:VirtualMachinePlatform /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V-Management-Clients /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V-Services /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V-Hypervisor /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V-Management-PowserShell /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V-Tools-All /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V /NoRestart
        DISM.exe /Online /Disable-Feature:HypervisorPlatform /NoRestart
        DISM.exe /Online /Disable-Feature:Microsoft-Hyper-V-Online /NoRestart
        DISM.exe /Online /Disable-Feature:IsolatedUserMode /NoRestart

        reg add "HKLM\system\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /f /v "enabled" /t REG_DWORD /d 0
        reg add "HKLM\system\ControlSet001\Control\DeviceGuard" /f /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 0
        reg add "HKLM\system\ControlSet001\Control\DeviceGuard" /f /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0
        reg add "HKLM\system\ControlSet001\Control\DeviceGuard" /f /v "SecureBiometrics" /t REG_DWORD /d 0
        reg add "HKLM\system\ControlSet001\Control\DeviceGuard" /f /v "WindowsHello" /t REG_DWORD /d 0
        reg add "HKLM\system\ControlSet001\Services\HvHost" /f /v "Start" /t REG_DWORD /d 4
    ) else (
        bcdedit /set hypervisorlaunchtype off
    )

    echo 关闭显示首次登录动画
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f

    echo 禁用 BitLocker 自动加密
    reg add "HKLM\SYSTEM\CurrentControlSet\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f 
)
if %osver% GEQ 2 (
    bcdedit /timeout 3
    bcdedit /set {current} default
    echo 禁止开机弹出启动故障界面
    bcdedit /set {current} bootstatuspolicy ignoreallfailures
    if exist "%SystemDrive%\Windows\System32\wbem\WMIC.exe" (
        wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
    ) else (
        powershell -Command "Get-WmiObject -Class Win32_computersystem | Set-WmiInstance -Property @{AutomaticManagedPagefile=$false}"
    )
)

echo 创建用户
if exist "%SystemDrive%\Users\Default\NTUSER.DAT" (
    echo y | start "" /wait /min "%~dp0apifiles\newuser.bat"
)

echo [API] 正在应用 DIY 接口 api3_bsh.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist api3_bsh.bat call api3_bsh.bat
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api3_bsh.bat" (
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api3_bsh.bat"
        )
    )
)
echo 清除装机软件接口
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v RunLoader
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /f /v RunLoader
echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
goto end

:FirstLogin
title 登录时系统处理（请勿关闭此窗口）
taskkill /f /im explorer.exe
if %osver% GEQ 3 (
    echo Win8-11 系统 WD、WU 驱动处理
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\WD.ps1"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    echo 关闭保留储存
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v ShippedWithReserves /t REG_DWORD /d 0 /f
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-disable.reg"
    start "" /wait "%~dp0apifiles\Wub.exe" /D /P
    echo 关闭显示你的数据将在你所在的国家或地区之外进行处理
    taskkill /f /im WWAHost.exe
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
    reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\PersonalDataExport" /f /v "PDEShown" /t REG_DWORD /d 2
)
echo Login
for %%a in (Login\*.exe) do (
    echo [API] 正在登录时应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /S
    del /f /q "%%a"
)
for %%a in (Login\*.msi) do (
    echo [API] 正在登录时应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /passive /qb-! /norestart
    del /f /q "%%a"
)
for %%a in (Login\*.reg) do (
    echo [API] 正在登录时应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
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

:ToDesktop
title 桌面环境系统处理（请勿关闭此窗口）
start "" "%pecmd%" LOAD "%~dp0apifiles\Wall.wcs"
echo [API]正在进行桌面环境系统处理...>"%systemdrive%\Windows\Setup\wallname.txt"
echo win8-11系统APPX、WD、WU驱动处理
if %osver% GEQ 3 (
    regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\uninstallAppx.ps1"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-disable.reg"
)

echo 关闭 Edge OneDrive
if %osver% GEQ 4 (
    taskkill /f /im msedge.exe
    taskkill /f /im msedgewebview2.exe
    taskkill /f /im MicrosoftEdgeUpdate.exe
    taskkill /f /im onedrive.exe
    taskkill /f /im onedrivesetup.exe
)

echo 修复双用户问题
if /i not "%USERNAME%"=="Administrator" (
    NET USER Administrator /ACTIVE:NO
)

echo 修复用户密码过期问题
Net Accounts /MaxPwAge:Unlimited
%netuser% %USERNAME% /pwnexp:y
wmic useraccount where "name='%username%'" set PasswordExpires=FALSE
powershell -Command "Set-LocalUser -Name '%username%' -PasswordNeverExpires $true"

echo 恢复环境配置
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /f
if exist "%SystemDrive%\windows\system32\srclient.dll" (
    "%~dp0apifiles\srtool.exe" /off
    "%~dp0apifiles\srtool.exe" /reset
)
label %SystemDrive% %osname%_OS

if %osver% GEQ 2 (
    bcdedit /timeout 3
)

echo 删除残留的系统启动项
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v "PanDaSysAPI"
for /f "delims= " %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /t REG_EXPAND_SZ ^| find /i "Unattend"') do reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v %%i /f
del /f /q "%SystemDrive%\Windows\System32\deploy.exe"

echo 删除装机助理残留
del /q /f "%SystemDrive%\Users\Public\Desktop\Internet Explorer.lnk"
del /q /f "%SystemDrive%\Users\Public\Desktop\网址导航.lnk"

cd /d "%~dp0"
echo Run
for %%a in (Run\*.exe) do (
    echo [API] 正在桌面环境下应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /S
    del /f /q "%%a"
)
for %%a in (Run\*.msi) do (
    echo [API] 正在桌面环境下应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%a" /passive /qb-! /norestart
    del /f /q "%%a"
)
for %%a in (Run\*.reg) do (
    echo [API] 正在桌面环境下应用 %%a...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%a"
    del /f /q "%%a"
)
echo [API] 正在应用 DIY 接口 api5_jzm.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist api5_jzm.bat call api5_jzm.bat
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\API\api5_jzm.bat" (
            echo y | start "" /max /wait "%%a:\PanDaTech\API\api5_jzm.bat"
        )
        for %%b in (%%a:\PanDaTech\API\Run\*.exe) do (
            echo [API] 正在桌面环境下应用 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\Run\*.msi) do (
            echo [API] 正在桌面环境下应用 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\API\Run\*.reg) do (
            echo [API] 正在桌面环境下应用 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)
echo [API] 正在应用 OSC 系统优化组件...>"%systemdrive%\Windows\Setup\wallname.txt"
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
echo [API] 正在处理后续事项...>"%systemdrive%\Windows\Setup\wallname.txt"

if %osver% GEQ 3 (
    echo Win8-11 系统 WU 驱动处理
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WUdrivers-enable.reg"
)

echo 输出 TAG
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.exe"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"

echo 清理残留
regedit /s "%~dp0apifiles\cleanup.reg"
echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "%~dp0apifiles\selfdel.bat" start "" /min "%~dp0apifiles\selfdel.bat"
shutdown /r /t 5 /c "系统部署完成，重启后生效（API）"
goto end

:end
exit