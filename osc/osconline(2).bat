chcp 936 > nul
chcp 936 > nul

::
:: Author: 狂犬主子 & PanDaTech
:: Description: 潇然系统优化组件 For PanDaSys osc.exe——云端控制配置文件
:: Date: 10:06 2025/5/3
:: Note: 转载/修改请保留此信息
::

@echo off
title 潇然系统优化组件 For PanDaSys osc.exe——云端控制配置文件
if not defined url set url=https://url.xrgzs.top
setlocal enabledelayedexpansion
echo 防止错误运行
if not exist "%SystemDrive%\Windows\Setup\Set\osc\aria2c.exe" exit
taskkill /f /im msedge.exe

echo 检测系统是否为XP
set isxp=no
ver | find /i "5.0." > nul && set isxp=yes
ver | find /i "5.1." > nul && set isxp=yes
ver | find /i "6.0." > nul && set isxp=yes

if exist "%SystemDrive%\Windows\Setup\Set\zjsoftforceoffline.txt" (
    set isoffline=1
    goto onlinepatch
)
if exist "%SystemDrive%\Windows\Setup\zjsoftforceoffline.txt" (
    set isoffline=1
    goto onlinepatch
)
echo [OSCol]正在联网中...>"%SystemDrive%\Windows\Setup\wallname.txt"
echo 正在判断互联网...
set isoffline=1
set %errorlevel%=
ping www.aliyun.com -4 -n 2 >nul
if %errorlevel% EQU 0 (
    %aria% -o checkinternet.txt "%url%/checkconnect"
    if not exist checkinternet.txt (
        set isoffline=1
    ) else (
        type checkinternet.txt | find /i "isconnected" > nul && set isoffline=0
    )
)
goto onlinepatch

:onlinepatch
echo 设置时区为中国
if exist "%SystemDrive%\Windows\System32\tzutil.exe" tzutil /s "China Standard Time"
echo 校对时间
if "%isoffline%"=="0" %PECMD% NTPC ntp1.aliyun.com
echo 清除DNS缓存
ipconfig /flushdns
echo [OSCol]正在检测组件...>"%SystemDrive%\Windows\Setup\wallname.txt"
curl.exe --version || (
    %aria% -o "curl.exe" "%url%/curlxp"
    %aria% -o "curl-ca-bundle.crt" "%url%/curlca"
)

echo [OSCol]正在应用在线优化补丁...>"%SystemDrive%\Windows\Setup\wallname.txt"
taskkill /f /im OfficeC2RClient.exe
goto online1

:online1
echo Win10-11专用优化
ver | find /i "10.0." && (
    if "%isoffline%"=="0" (
        if exist "%LocalAppData%\Microsoft\WindowsApps\winget.exe" (
            echo WinGet 换源
            winget source remove winget && winget source add winget https://mirrors.cernet.edu.cn/winget-source
        )
    )
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set bigversion=%%a
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set smallversion=%%b
)

echo 电源处理
set notebook=0
echo wxp-11判断是否为笔记本电脑
if exist "%SystemDrive%\Windows\System32\wbem\WMIC.exe" (
    for /f "tokens=2 delims={}" %%a in ('wmic PATH Win32_SystemEnclosure get ChassisTypes /value') do (
        if %%a GEQ 8 (
            for /f "tokens=2 delims==" %%b in ('wmic path Win32_Battery get BatteryStatus /value') do (
                if %%b GEQ 1 set notebook=1
            )
        )
    )
) else (
    if defined PSModulePath (
        for /f "tokens=*" %%a in ('PowerShell "(Get-WmiObject Win32_SystemEnclosure).ChassisTypes"') do (
            if %%a GEQ 8 (
                for /f "tokens=*" %%b in ('PowerShell "(Get-WmiObject Win32_Battery).BatteryStatus"') do (
                    if %%b GEQ 1 set notebook=1
                )
            )
        )
    )
)
@rem 防止意外将品牌机MoDT识别为笔记本
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set notebook=0

echo 防缩肛
powercfg setactive SCHEME_BALANCED

if %notebook% GEQ 1 (
    echo 笔记本启用休眠
    powercfg /h on
    echo 笔记本禁用小键盘
    reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 0 /f
    echo 笔记本开启自动息屏
    POWERCFG /x monitor-timeout-dc 5
    POWERCFG /x standby-timeout-dc 30
    echo 笔记本开启快速启动
    reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
) else (
    echo 台式机开启小键盘
    reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f
    echo 电源按钮功能设置为关机
    powercfg -setdcvalueindex SCHEME_MAX SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_MAX SUB_BUTTONS PBUTTONACTION 3
    powercfg -setdcvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 3
    powercfg -setdcvalueindex SCHEME_BALANCED SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_BALANCED SUB_BUTTONS PBUTTONACTION 3
    echo 禁用USB选择性暂停
    powercfg -setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
)

:online
echo 正在判断下载安装系统增强组件
set os_arch=%PROCESSOR_ARCHITECTURE%
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set os_arch=x64
if not exist "%SystemDrive%\Windows\Setup\pandasysnoruntime.txt" (
    if not exist "%SystemDrive%\Windows\Fonts\FZXBSK.ttf" (
        echo [OSCol]正在安装系统增强组件 xrfonts...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist xrfonts.exe if "%isoffline%"=="0" %aria% -x16 -j16 -s16 -o xrfonts.exe "%url%/xrfonts"
        if exist xrfonts.exe start /wait xrfonts.exe && del /f /q xrfonts.exe
    )
    ver | find /i "10.0." && (
        if not exist "%SystemDrive%\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App\8.*" (
            echo [OSCol]正在安装系统增强组件 .NET 8...>"%SystemDrive%\Windows\Setup\wallname.txt"
            if not exist "dotnet8-%os_arch%.exe" if "%isoffline%"=="0" %aria% -x16 -j16 -s16 -o "dotnet8-%os_arch%.exe" "%url%/dotnet8-%os_arch%"
            if exist "dotnet8-%os_arch%.exe" start "" /wait "dotnet8-%os_arch%.exe" /q /norestart && del /f /q "dotnet8-%os_arch%.exe"
        )
    )
)

:onlinefinish
echo [OSCol]正在处理后续事项...>"%SystemDrive%\Windows\Setup\wallname.txt"

echo 尝试卸载 OneDrive
taskkill /f /im OneDrive.exe
taskkill /f /im OneDrive*.exe
for /d %%f in ("%localappdata%\Microsoft\OneDrive\*") do (if exist "%%f\OneDriveSetup.exe" "%%f\OneDriveSetup.exe" /uninstall)
echo 关闭 OneDrive 开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
del /f /q "%SystemDrive%\Windows\System32\Tasks\OneDrive*"
echo 干掉 OneDrive 资源菜单
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
echo 删除 OneDrive 残留
if not exist "%USERPROFILE%\Appdata\Local\Microsoft\OneDrive\OneDrive.exe" (
    del /f /q "%AppData%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
    rd /s /q "%LocalAppData%\Microsoft\OneDrive"
    rd /s /q "%ProgramData%\Microsoft OneDrive"
    rd /s /q "%SystemDrive%\OneDriveTemp"
    REG Delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
    REG Delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
)
echo 关闭驱动面板开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v RTHDVCPL /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v HotKeysCmds /f
echo 关闭腾信开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v WeChat /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v QQ /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v QQNT /f
echo 关闭Acrobat开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Acrobat Assistant 8.0" /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "AdobeGCInvoker-1.0" /f
schtasks /delete /tn "\Adobe Acrobat Update Task" /f
sc delete AdobeARMservice
sc delete AGMService
sc delete AGSService
echo 关闭WPS开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
echo 关闭Steam开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Steam" /f
echo 解决Office2016以下版本中文未知字体难看的问题
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Arial Unicode MS (TrueType)" /f
del /f /q "%SystemDrive%\Windows\Fonts\ARIALUNI.TTF"
echo 删除QQ任务栏图标
del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\腾讯QQ.lnk"
echo 关闭QQ游戏自启
sc delete QQGameService
echo 清理重复的浏览器图标
if exist "%PUBLIC%\Desktop\Microsoft Edge.lnk" (
    if exist "%USERPROFILE%\Desktop\Microsoft Edge.lnk" del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
) else if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" (
    copy /y "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" "%PUBLIC%\Desktop\Microsoft Edge.lnk"
)
if exist "%PUBLIC%\Desktop\Google Chrome.lnk" if exist "%USERPROFILE%\Desktop\Google Chrome.lnk" del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"

echo 输出TAG
if not exist "%SystemDrive%\Windows\Version.txt" >"%SystemDrive%\Windows\Version.txt" echo 手动运行
echo zjsoft%softver% by xrosc on %date% at %time% >>"%SystemDrive%\Windows\Version.txt"
>>"%SystemDrive%\Windows\Version.txt" type Version.txt
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.exe"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"
goto onlinefinish1

:onlinefinish1
echo successful %softver%>"%SystemDrive%\Windows\Setup\oscolstate.txt"
cd /d "%~dp0"
