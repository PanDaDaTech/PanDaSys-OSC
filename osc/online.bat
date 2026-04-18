chcp 936 > nul
title OSConline
cd /d "%~dp0"

if exist pack.7z (
    echo [OSC]正在解压pack...>"%systemdrive%\Windows\Setup\wallname.txt"
    %zip% x -r -y -p123 pack.7z
    del /f /q pack.7z
    echo ok >unpacked.log
)

if exist "%SystemDrive%\Windows\Setup\Set\zjsoftforceoffline.txt" goto offline
if exist "%SystemDrive%\Windows\Setup\zjsoftforceoffline.txt" goto offline
ping www.aliyun.com -4 -n 2 >nul
if %errorlevel% GEQ 1 goto offline
goto try

:try
%aria% -o checkconnect.txt "https://pan.qzyun.net/f/z6b2Uw/checkconnect.txt"
type checkconnect.txt | find /i "isconnected" > nul && goto online
goto offline

:offline
if exist oscoffline.bat (
    copy /y oscoffline.bat osconline.bat
    goto online
)
if exist pack.bat (
    copy /y pack.bat osconline.bat
    goto online
)
goto local2

:online
cd /d "%~dp0"
if exist osconline.bat (
    call osconline.bat
) else (
    %aria% -o osconline.bat "https://pan.qzyun.net/f/MlLjf0/oscoffline.bat"
    if exist osconline.bat (
        call osconline.bat
    )
)
goto local2

:local2
if exist "%SystemDrive%\Windows\Setup\Run\2\api2.bat" (
    echo [OSC] 正在应用 DIY 接口 api2.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /max /wait "%SystemDrive%\Windows\Setup\Run\2\api2.bat"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\2\*.exe) do (
    echo [OSC] 正在安装预装软件 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /S
    del /f /q "%%b"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\2\*.msi) do (
    echo [OSC] 正在安装预装软件 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /passive /qb-! /norestart
    del /f /q "%%b"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\2\*.reg) do (
    echo [OSC] 正在应用注册表 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%b"
    del /f /q "%%b"
)

if exist "%SystemDrive%\Windows\Setup\pandasyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\PanDaTech\OSC\api2.bat" (
            echo [OSC] 正在应用搜到的 DIY 接口 %%a:\~\api2.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /max /wait "%%a:\PanDaTech\OSC\api2.bat"
        )
        for %%b in (%%a:\PanDaTech\OSC\2\*.exe) do (
            echo [OSC] 正在运行搜到的 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\OSC\2\*.msi) do (
            echo [OSC] 正在安装搜到的 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\PanDaTech\OSC\2\*.reg) do (
            echo [OSC] 正在应用搜到的 %%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)
goto end

:end
exit