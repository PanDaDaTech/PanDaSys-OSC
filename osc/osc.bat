chcp 936 > nul
setlocal EnableDelayedExpansion
@echo off
title 潇然系统优化组件 For PanDaSys XRSYS-OSC For PanDaSys
cd /d "%~dp0"
if exist "%systemdrive%\Windows\SysWOW64\wscript.exe" (
    set "PROCESSOR_ARCHITECTURE=AMD64"
    move /y "%~dp0apifiles\PECMD64.exe" "%~dp0apifiles\PECMD.exe"
    move /y "%~dp0apifiles\DrvIndex64.exe" "%~dp0apifiles\DrvIndex.exe"
)
set aria="%~dp0aria2c.exe" -c -R --retry-wait=5 --check-certificate=false --save-not-found=false --always-resume=false --auto-save-interval=10 --auto-file-renaming=false --allow-overwrite=true
set dmi="%~dp0apifiles\DMI.exe"
set netuser="%~dp0apifiles\NetUser.exe"
set nircmd="%~dp0apifiles\nircmd.exe"
set winput="%~dp0apifiles\winput.exe"
set wbox="%~dp0apifiles\wbox.exe"
set nsudo="%~dp0apifiles\NSudoLC.exe"
set pecmd="%~dp0apifiles\PECMD.exe"
set drvindex="%~dp0apifiles\DrvIndex.exe"
set srtool="%~dp0apifiles\srtool.exe"
set wlan="%~dp0apifiles\WLAN.exe"
set zip="%~dp0apifiles\7z.exe"

echo 系统版本判断
set osver=0&& set osname=Win
ver | find /i "5.1." > nul && set osver=1&& set osname=WinXP
ver | find /i "6.0." > nul && set osver=2&& set osname=Vista
ver | find /i "6.1." > nul && set osver=2&& set osname=Win7
ver | find /i "6.2." > nul && set osver=3&& set osname=Win8
ver | find /i "6.3." > nul && set osver=3&& set osname=Win8.1
ver | find /i "6.4." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0.2" > nul && set osver=4&& set osname=Win11

echo 创建相关文件夹
mkdir "%SystemDrive%\Windows\Setup"
mkdir "%SystemDrive%\Windows\Setup\Run"
echo successful>"%SystemDrive%\Windows\Setup\oscrunstate.txt"

:checkenv_generalize
echo 检测是否在部署阶段中运行
if exist "%SystemDrive%\Windows\Setup\State\State.ini" (
    find /i "IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE" "%SystemDrive%\Windows\Setup\State\State.ini" && (
        echo 不支持在部署阶段中运行
        goto endoff
    )
)

:checkenv_winpe
echo 检测是否在 PE 系统中运行
if /i "%SystemDrive%"=="x:" if exist "X:\Windows\System32\PECMD.EXE" (
    echo 不支持在 PE 系统中运行
    goto endoff
)

:mainprogram
if %osver% GEQ 3 (
    echo Win8-11 系统 APPX、WD 处理
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\WD.ps1"
    regedit /s "%~dp0apifiles\WDDisable.reg"
    "%nsudo%" -U:T -P:E -wait regedit /s "%~dp0apifiles\WDDisable.reg"
    powershell -ExecutionPolicy bypass -File "%~dp0apifiles\uninstallAppx.ps1"
    reg import "%~dp0apifiles\mspcmgr.reg" /reg:32
    
    echo 禁止自动安装微软电脑管家
    rd /s /q "%ProgramData%\Windows Master Store"
    echo noway>"%ProgramData%\Windows Master Store"
    rd /s /q "%ProgramData%\Windows Master Setup"
    echo noway>"%ProgramData%\Windows Master Setup"
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v WindowsMasterSetup /f
    rd /s /q "%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    echo noway>"%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
)

echo 创建 runonce 自删清理脚本...
if %osver% GEQ 2 (
	copy /y runonce.bat "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Startup\"
) else (
    copy /y runonce.bat "%ALLUSERSPROFILE%\「开始」菜单\程序\启动\"
)

if not exist "%SystemDrive%\Windows\Setup\Set\pandasysstepapi5.flag" (
    start "" "%pecmd%" LOAD "%~dp0apifiles\Wall.wcs"
)

:copytags
echo 拷贝相关 TAG 文件
mkdir "%SystemDrive%\Windows\Setup\"
for %%a in (C D E F G H) do (
    move /y "%%a:\zjsoft*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\pdtechrc*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\pandasys*.txt" "%SystemDrive%\Windows\Setup"
)

:oscdrivers
echo 电源选项设置
rem POWERCFG -HIBERNATE OFF
powercfg /h off
POWERCFG -CHANGE -monitor-timeout-ac 0
POWERCFG -CHANGE -monitor-timeout-dc 0
POWERCFG -CHANGE -standby-timeout-ac 0
POWERCFG -CHANGE -standby-timeout-dc 0
POWERCFG -CHANGE -hibernate-timeout-ac 0
POWERCFG -CHANGE -hibernate-timeout-dc 0
rem [监视器电源不关闭]
powercfg setactive SCHEME_BALANCED && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -monitor-timeout-ac 0
rem [磁盘电源不关闭]
powercfg setactive SCHEME_BALANCED && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -disk-timeout-ac 0
rem 安装驱动
if exist wandrv.iso (
    echo [OSC]正在应用万能驱动 wandrv.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv
    move /y "%~dp0wandrv.iso" "%~dp0wandrv\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv\DriveCleaner.exe" /wandrv
    echo wandrv.iso>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
)
if exist wandrv2.iso (
    echo [OSC]正在应用万能驱动 wandrv2.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv2
    move /y "%~dp0wandrv2.iso" "%~dp0wandrv2\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv2\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv2\DriveCleaner.exe" /wandrv
    echo wandrv2.iso>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
)
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\OSC\DriverBackup.7z" (
            echo [OSC]正在导入搜到的驱动备份%%a:\~\DriverBackup.7z...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%drvindex%" -b "%%a:\PanDaTech\OSC\DriverBackup.7z"
        )
        if exist "%%a:\PanDaTech\OSC\wandrv.iso" (
            echo [OSC]正在应用搜到的万能驱动%%a:\~\wandrv.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
            copy /y "%~dp0apifiles\DriveCleaner.exe" "%%a:\PanDaTech\OSC\DriveCleaner.exe"
            start "" /wait "%%a:\PanDaTech\OSC\DriveCleaner.exe" /wandrv
            echo %%a:\PanDaTech\OSC\wandrv.iso>>"%systemdrive%\Windows\Setup\pandasysdriverdebug.log"
        )
    )
)

:optimize
if exist "optimize\start.bat" (
    echo [OSC]正在优化系统...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /wait /min "optimize\start.bat"
)

:themerec
echo [OSC]正在恢复系统主题...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "themerec\themerec.bat" echo y | start "" /wait /min "themerec\themerec.bat"

:changepcname
echo 修改机器号
if exist "%SystemDrive%\Windows\Setup\pandasysnopcname.txt" goto changepasswd
if exist "%SystemDrive%\Windows\Setup\pandasyspcname.txt" (
    set /p pcname=<"%SystemDrive%\Windows\Setup\pandasyspcname.txt"
)
if defined pcname (
    set "pcname=%pcname: =%"
    if "!pcname!"=="%computername%" goto changepasswd
    goto :setpcname
) else (
    echo %computername% | find /i "-PC" && goto changepasswd
    echo %computername% | find /i "PC-" && goto changepasswd
    goto :genpcname
)

:genpcname
rem 生成四个随机字母
set str=ABCDEFGHIJKLMNOPQRSTUVWXYZ
for /l %%a in (1 1 4) do (
    set /a n=!random!%%26
    call set random_letters=%%str:~!n!,1%%!random_letters!
)
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" (
    set pcname=Admin-PC
) else (
    set pcname=PC-%date:~0,4%%date:~5,2%%date:~8,2%%random_letters%
)

:setpcname
if exist "%SystemDrive%\Windows\System32\wbem\WMIC.exe" (
    wmic computersystem where "caption='%computername%'" call Rename name='%pcname%'
) else (
    powershell -Command "Rename-Computer -NewName '%pcname%' -Force"
)
reg add "HKCU\Software\Microsoft\Windows\ShellNoRoam" /f /ve /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "NV Hostname" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Hostname" /t REG_SZ /d "%pcname%"
reg add "HKU\.DEFAULT\Software\Microsoft\Windows\ShellNoRoam" /f /ve /t REG_SZ /d "%pcname%"

:changepasswd
setlocal enabledelayedexpansion
if exist "%systemdrive%\Windows\Setup\pandasyspasswd.txt" (
    set /p passwd=<"%SystemDrive%\Windows\Setup\pandasyspasswd.txt"
    del /f /q "%SystemDrive%\Windows\Setup\pandasyspasswd.txt"
    if not defined passwd set passwd=1
    if defined passwd set "passwd=!passwd: =!"
    if "!passwd!"=="1" set passwd=PassWd@123
    net user %USERNAME% !passwd!
)
endlocal

:restorewifi
echo 还原备份的WIFI密码
if %osver% GEQ 2 (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\WLANPassword\*.xml" (
            FORFILES /P "%%a:\PanDaTech\WLANPassword" /M *.xml /C "cmd /c netsh wlan add profile filename=@path"
        )
        if exist "%%a:\WLANPassword\*.xml" (
            FORFILES /P "%%a:\WLANPassword" /M *.xml /C "cmd /c netsh wlan add profile filename=@path"
        )
    )
) else (
    for /f "tokens=1,2" %%i in ('%wlan% ei') DO (
        if "%%i"=="GUID:" (
            set GUID=%%j
            for %%a in (C D E F G H) do (
                for %%b in ("%%a:\PanDaTech\WLANPassword\*.xml") DO (
                    %wlan% sp !GUID! "%%b"
                )
            )
        )
    )
)

:restoreip
setlocal enabledelayedexpansion
if exist "%systemdrive%\Windows\Setup\pandasysnodhcp.txt" (
    for /f "tokens=3*" %%i in ('netsh interface show interface ^|findstr /I /R "本地.* 以太.* Local.* Ethernet" ^|findstr /I /R "已连接"') do (set EthName=%%j)
    for /f "tokens=1,2* delims==" %%i in (%systemdrive%\Windows\Setup\pandasysnodhcp.txt) do (set %%i=%%j)
    if defined EthName (
        if defined address if defined mask if defined gateway netsh -c interface ip set address name="!EthName!" source=static address=!address: =! mask=!mask: =! gateway=!gateway: =!
        if not defined dns1 set dns1=223.5.5.5& set dns2=119.29.29.29
        if defined dns set dns1=!dns!& set dns2=!dns!
        if defined dns1 netsh -c interface ip add dnsservers name="!EthName!" address=!dns1: =! index=1 validate=no
        if defined dns2 netsh -c interface ip add dnsservers name="!EthName!" address=!dns2: =! index=2 validate=no
    )
)
endlocal


:configurefirewall
if exist "%systemdrive%\Windows\Setup\pandasysfirewall.txt" (
    echo 打开防火墙
    netsh advfirewall set currentprofile state on
    netsh firewall set opmode mode=enable
    netsh advfirewall set privateprofile state on
    netsh firewall set opmode mode=enable profile=ALL
    netsh advfirewall set allprofiles state on
    netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound
    netsh advfirewall set allprofiles settings inboundusernotification enable
    netsh advfirewall set allprofiles settings unicastresponsetomulticast enable
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /f /v "EnableFirewall" /t reg_dword /d 1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /f /v "DisableNotifications" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /f /v "EnableFirewall" /t reg_dword /d 1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /f /v "DisableNotifications" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /f /v "EnableFirewall" /t reg_dword /d 1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /f /v "DisableNotifications" /t reg_dword /d 0
) else if exist "%systemdrive%\Windows\Setup\pandasysnofirewall.txt" (
    echo 关闭防火墙
    netsh advfirewall set currentprofile state off
    netsh firewall set opmode mode=disable
    netsh advfirewall set privateprofile state off
    netsh firewall set opmode mode=disable profile=ALL
    netsh advfirewall set allprofiles state disable
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /f /v "EnableFirewall" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /f /v "EnableFirewall" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /f /v "EnableFirewall" /t reg_dword /d 0
)

:configurerdp
set rdpport=3389
if exist "%systemdrive%\Windows\Setup\pandasysrdp.txt" (
    echo 打开RDP
    set /p rdpportnew=<"%SystemDrive%\Windows\Setup\pandasysrdp.txt"
    if not "!rdpportnew: =!"=="" if !rdpportnew! GEQ 2 if !rdpportnew! LEQ 65535 set rdpport=!rdpportnew!
    netsh firewall set portopening protocol=ALL port=!rdpport: =! name=RDP mode=ENABLE scope=ALL profile=ALL
    netsh firewall set portopening protocol=ALL port=!rdpport: =! name=RDP mode=ENABLE scope=ALL profile=CURRENT
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber /t reg_dword /d !rdpport: =! /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t reg_dword /d !rdpport: =! /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t reg_dword /d 0 /f
    FOR /F "tokens=2 delims=:" %%i in ('SC QUERYEX TermService ^|FINDSTR /I "PID"') do TASKKILL /F /PID %%i
    FOR /F "tokens=2 delims=:" %%i in ('SC QUERYEX UmRdpService ^|FINDSTR /I "PID"') do TASKKILL /F /PID %%i
    SC START TermService
)

:runtime
echo 应用运行库
if exist "runtime\runtime.bat" echo y | start "" /wait /min "runtime\runtime.bat"

:oscapis
echo 应用OSCAPI
if exist "%SystemDrive%\Windows\Setup\Set\osc\Office\Office_*.iso" (
    echo [OSC]正在应用 OfficeISO...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /min /wait cmd /c "%SystemDrive%\Windows\Setup\Set\osc\Office\MSOInst.bat"
)
if exist "%SystemDrive%\Windows\Setup\Run\1\api1.bat" (
    echo [OSC]正在应用DIY接口 api1.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /max /wait "%SystemDrive%\Windows\Setup\Run\1\api1.bat"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.exe) do (
    echo [OSC]正在安装 %%~nxb...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /S
    del /f /q "%%b"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.msi) do (
    echo [OSC]正在安装 %%~nxb...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /passive /qb-! /norestart
    del /f /q "%%b"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.reg) do (
    echo [OSC]正在应用 %%~nxb...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%b"
    del /f /q "%%b"
)
if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\OSC\api1.bat" (
            echo [OSC]正在应用搜到的 DIY 接口 %%a:\~\api1.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
            echo y | start "" /max /wait "%%a:\PanDaTech\OSC\api1.bat"
        )
        for %%b in (%%a:\PanDaTech\OSC\1\*.exe) do (
            echo [OSC]正在运行搜到的 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\OSC\1\*.msi) do (
            echo [OSC]正在安装搜到的 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\OSC\1\*.reg) do (
            echo [OSC]正在应用搜到的 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)

:xrkms
echo 应用 XRKMS
if exist "xrkms\xrkms.bat" (
    echo [OSC]正在智能激活系统（可能需要3min）>"%systemdrive%\Windows\Setup\wallname.txt"
    timeout /t 3
    echo y | start "" /wait "xrkms\xrkms.bat"
)

:osconline
echo 应用 OSConline
echo [OSC]正在应用 OSConline（可能需要15分钟, 请保持网络通畅）>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "online.bat" echo y | start "" /wait /min "online.bat"

:afterlife
echo [OSC] 正在处理后续事项...>"%systemdrive%\Windows\Setup\wallname.txt"
if %osver% EQU 2 (
    echo Win7系统 WU 服务处理
    echo yes>"%systemdrive%\Windows\Setup\pandasysnowu.txt"
)
if %osver% EQU 3 (
    echo Win8 启用UAC
    echo yes>"%systemdrive%\Windows\Setup\pandasysuac.txt"
    echo Win8系统WU服务处理
    echo yes>"%systemdrive%\Windows\Setup\pandasysnowu.txt"
)

if %osver% EQU 4 (
    echo Win10+ 系统WU服务处理
    echo yes>"%systemdrive%\Windows\Setup\pandasyswu.txt"
)

:disablewu
echo 按需关闭 WU
if exist "%systemdrive%\Windows\Setup\pandasyswu.txt" (
    start "" /wait /min "%~dp0apifiles\Wub.exe" /E
) else if exist "%systemdrive%\Windows\Setup\pandasysfkwu.txt" (
    start "" /wait /min "%~dp0apifiles\Wub.exe" /D /P
) else if exist "%systemdrive%\Windows\Setup\pandasysnowu.txt" (
    start "" /wait /min "%~dp0apifiles\Wub.exe" /D
)

:endosc
echo 部署完成
cd /d "%~dp0"
echo successful>"%SystemDrive%\Windows\Setup\oscstate.txt"
echo successfuldel>"%SystemDrive%\Windows\Setup\oscstate.txt"
if not exist "%SystemDrive%\Windows\Setup\Set\api.bat" (
    echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
    shutdown /r /t 5 /c "系统部署完成，重启后生效（OSC）"
)
if exist selfdel.bat start /min selfdel.bat

:endoff
exit