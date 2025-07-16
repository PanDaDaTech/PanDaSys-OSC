chcp 936 > nul

::
:: Author: 狂犬主子 & PanDaTech
:: Description: PanDaSys 优化组件 osc.exe——云端控制配置文件
:: Date: 6:13 2025/6/15
:: Note: 转载/修改请保留此信息
::

@echo off
title PanDaSys 优化组件 osc.exe——云端控制配置文件
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
echo 自动安装 ToDesk
if exist "%SystemDrive%\Windows\Setup\zjsofttodesk.txt" if exist "%SystemDrive%\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (
    powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadString('http://td.rjxz.win/ps') | Invoke-Expression"
)

echo Win10-11专用优化
ver | find /i "10.0." && (
    if "%isoffline%"=="0" (
        if exist "%LocalAppData%\Microsoft\WindowsApps\winget.exe" (
            echo WinGet 换源
            winget source remove winget && winget source add winget https://mirrors.cernet.edu.cn/winget-source
        )
    )
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

rem 防止意外将品牌机MoDT识别为笔记本
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


:online2
echo 正在判断需要下载安装的装机软件类型
set softver=onlinepandasys
if exist "%SystemDrive%\Windows\Setup\zjsoftpdtechrc.txt" set softver=onlinepdtechrc
if exist "%SystemDrive%\Windows\Setup\zjsoftoffice.txt" set softver=onlineoffice
if exist "%SystemDrive%\Windows\Setup\zjsoftonlinepandasys.txt" set softver=onlinepandasys
if exist "%SystemDrive%\Windows\Setup\zjsoftonlineno.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\pdtechrcnoad.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\zjsoftpure.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\zjsoftforce.txt" set softver=onlinepdtechrc
if exist "%SystemDrive%\Windows\Setup\zjsoftforcepure.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set softver=onlinespoem
goto online3

:online3
echo 正在根据装机软件类型判断需要安装的基础软件
if %softver%==onlineno (
    set zjsoftpdtech=no
    set zjsoftzip=no
    set zjsoftpinyin=no
    set zjsoftoffice=no
    set zjsofttxt=no
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=no
    set zjsoftchat=no
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==onlinepandasys (
    set zjsoftpdtech=yes
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=no
    set zjsofttxt=no
    set zjsoftbrowser=yes
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=no
    set zjsoftchat=no
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==onlineoffice (
    set zjsoftpdtech=yes
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=yes
    set zjsofttxt=yes
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=no
    set zjsoftchat=no
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==onlinepdtechrc (
    set zjsoftpdtech=yes
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=yes
    set zjsofttxt=yes
    set zjsoftbrowser=yes
    set zjsoftdown=yes
    set zjsoftmusic=yes
    set zjsoftplayer=yes
    set zjsoftchat=yes
    set zjsoftsafe=yes
    echo test startup >"%SystemDrive%\Windows\Setup\zjsoftHR.txt"
    set zjsoftextra=yes
) else if %softver%==onlinespoem (
    set zjsoftpdtech=no
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=yes
    set zjsofttxt=no
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=yes
    set zjsoftchat=no
    set zjsoftsafe=yes
    set zjsoftextra=no
    echo oem special do not 360 >"%SystemDrive%\Windows\Setup\zjsoftHR.txt"
)

:online4
echo 正在判断下载安装系统增强组件
set os_arch=%PROCESSOR_ARCHITECTURE%
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set os_arch=x64
if not exist "%SystemDrive%\Windows\Setup\xrsysnoruntime.txt" (
    if not exist "%SystemDrive%\Windows\Fonts\FZXBSK.ttf" (
        echo [OSCol]正在安装系统增强组件 xrfonts...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist xrfonts.exe if "%isoffline%"=="0" %aria% -x16 -j16 -s16 -o xrfonts.exe "%url%/xrfonts"
        if exist xrfonts.exe start /wait xrfonts.exe && del /f /q xrfonts.exe
    )
    ver | find /i "10.0." && (
        if not exist "%SystemDrive%\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App\8.*" (
            echo [OSCol]正在安装系统增强组件.NET 8...>"%SystemDrive%\Windows\Setup\wallname.txt"
            if not exist "dotnet8-%os_arch%.exe" if "%isoffline%"=="0" %aria% -x16 -j16 -s16 -o "dotnet8-%os_arch%.exe" "%url%/dotnet8-%os_arch%"
            if exist "dotnet8-%os_arch%.exe" start "" /wait "dotnet8-%os_arch%.exe" /q /norestart && del /f /q "dotnet8-%os_arch%.exe"
        )
    )
)

:online5
echo [OSCol]正在安装软件...>"%SystemDrive%\Windows\Setup\wallname.txt"
echo 正在读取注册表，获取软件安装列表
for /f "tokens=1,2*" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products /s /v DisplayName^|find /i "DisplayName"') do (
    echo %%k >>softlist.txt
)
for %%a in (HKLM\Software,HKCU\Software,HKCU\Software\Wow6432Node,HKLM\SOFTWARE\Wow6432Node) do (
    for /f "tokens=1,2*" %%i in ('reg query "%%a\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName^|find /i "DisplayName"^|find /v "KB"') do (
        echo %%k >>softlist.txt
    )
)
copy /y softlist.txt "%SystemDrive%\Windows\Setup\softlist.txt"

if exist pack.7z (
    echo [OSCol]正在解压 pack.7z...>"%SystemDrive%\Windows\Setup\wallname.txt"
    %zip% x -r -y -p123 pack.7z
    del /f /q pack.7z
    echo ok >unpacked.log
)

if not exist oscsoft.txt if "%isoffline%"=="0" (
    %aria% -o oscsoftol.txt "%url%/oscsoft"
    if exist oscsoftol.txt copy /y oscsoftol.txt oscsoft.txt
)
if not exist oscsoft.txt if exist oscsoftof.txt copy /y oscsoftof.txt oscsoft.txt
if not exist oscsoft.txt goto online6

echo 正在判断是否已安装办公软件（增强）
find /i "Microsoft 365" softlist.txt && set zjsoftoffice=no
find /i "Office 16" softlist.txt && set zjsoftoffice=no
find /i "Microsoft Office" softlist.txt && set zjsoftoffice=no
find /i "WPS Office" softlist.txt && set zjsoftoffice=no
find /i "WPS 365" softlist.txt && set zjsoftoffice=no
find /i "永中" softlist.txt && set zjsoftoffice=no

echo 正在判断是否需要安装浏览器
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" set zjsoftbrowser=no
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Firefox.lnk" set zjsoftbrowser=no
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" set zjsoftbrowser=no

echo 正在判断是否需要安装输入法
ver | find /i "10.0.1" > nul && set zjsoftpinyin=no
ver | find /i "10.0.2" > nul && set zjsoftpinyin=no

echo 正在安装低配机器优化组件...
if not "%isxp%"=="yes" if not "%isoffline%"=="1" if "%zjsoftpdtech%"=="yes" (
    if defined PSModulePath (
        for /f %%a in ('powershell "(Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB -le 4 -or (Get-WmiObject -Class Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum -le 2"') do (
            if "%%a"=="True" (
                ver | find /i "10.0." > nul && (
                    echo [OSCol]正在对低配机器做界面调整...>"%SystemDrive%\Windows\Setup\wallname.txt"
                    echo 关闭透明效果...
                    reg.exe add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /f /v EnableTransparency /t REG_DWORD /d 0
                    echo 关闭动画效果...
                    reg.exe add HKCU\Control Panel\Desktop /f /v UserPreferencesMask /t REG_BINARY /d "9012038010000000"
                    reg.exe add HKCU\Control Panel\Desktop\WindowMetrics /f /v MinAnimate /t REG_SZ /d 0
                    reg.exe add HKCU\SOFTWARE\Microsoft\Windows\DWM /v EnableAeroPeek /t REG_DWORD /d 0 /f
                    reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
                    reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarAnimations /t REG_DWORD /d 0 /f
                    reg.exe add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects /f /v VisualFXSetting /t REG_DWORD /d 0x2
                )
            )
        )
    )
)

echo 正在遍历 oscsoft.txt 安装软件
set | find /i "zjsoft" >>Version.txt
FOR /F "eol=; tokens=1,2,3,4,5,6,7,8 delims=|" %%i in (oscsoft.txt) do (
    echo 1.软件类型:%%i 2.安装程序:%%j 3.下载地址:%%k 4.运行参数:%%l 5.关键词:%%m 6.指定不安装版本:%%n 7.指定安装位数:%%o
    set isinstall=yes
    if not "!%%i!"=="no" (
        if not "%%n"==" " (
            if "%%n"=="xp" (
                echo XP不安装
                ver | find /i "5.0." > nul && set isinstall=no
                ver | find /i "5.1." > nul && set isinstall=no
            )
            if "%%n"=="onlyxp" (
                echo 除了XP外都不安装（仅XP安装）
                set isinstall=no
                ver | find /i "5.0." > nul && set isinstall=yes
                ver | find /i "5.1." > nul && set isinstall=yes
            )
            if "%%n"=="11xp" (
                echo 11 和 XP不安装
                ver | find /i "5.0." > nul && set isinstall=no
                ver | find /i "5.1." > nul && set isinstall=no
                ver | find /i "10.0.19" > nul && set isinstall=no
                ver | find /i "10.0.2" > nul && set isinstall=no
            )
            if "%%n"=="7" (
                echo 7 不安装
                ver | find /i "6.0." > nul && set isinstall=no
                ver | find /i "6.1." > nul && set isinstall=no
            )
            if "%%n"=="only7" (
                echo 除了 7 外都不安装（仅 7 安装）
                set isinstall=no
                ver | find /i "6.0." > nul && set isinstall=yes
                ver | find /i "6.1." > nul && set isinstall=yes
            )
            if "%%n"=="only710" (
                echo 除了 7 和 10 外都不安装（仅 7 和 10 安装）
                set isinstall=no
                ver | find /i "6.0." > nul && set isinstall=yes
                ver | find /i "6.1." > nul && set isinstall=yes
                ver | find /i "10.0." > nul && set isinstall=yes
            )
            if "%%n"=="only10" (
                echo 除了 10 外都不安装（仅 10 安装）
                set isinstall=no
                ver | find /i "10.0." > nul && set isinstall=yes
            )
            if "%%n"=="710" (
                echo 7 和 10 不安装（WPS）
                ver | find /i "6.0." > nul && set isinstall=no
                ver | find /i "6.1." > nul && set isinstall=no
                ver | find /i "10.0." > nul && set isinstall=no
            )
            if "%%n"=="10" (
                echo 10 不安装
                ver | find /i "6.4." > nul && set isinstall=no
                ver | find /i "10.0." > nul && set isinstall=no
            )
            if "%%n"=="11" (
                echo 11 不安装
                ver | find /i "10.0.2" > nul && set isinstall=no
            )
        )
        echo 已存在关键词不安装
        findstr /i "%%m" softlist.txt && set isinstall=no
        if not "%%o"==" " (
            if not "%PROCESSOR_ARCHITECTURE%"=="%%o" set isinstall=no
        )
    ) else (
        set isinstall=no
    )
    if not exist "%%j" (
        echo 不存在文件且未联网不安装
        if "%isoffline%"=="1" set isinstall=no
    )
    if not "!isinstall!"=="no" (
        echo 需要安装
        echo [OSCol]正在安装 %%~nj...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist "%%j" (
            echo 不存在文件，开始下载
            echo [notice]"%%j":file not exist once, downloading... >>Version.txt
            %aria% -x16 -j16 -s16 -o "%%j" "%%k"
        )
        if not exist "%%j" (
            echo 二次不存在文件，开始下载
            echo [error]"%%j":file not exist twice, try to download again... >>Version.txt
            %aria% -x8 -o "%%j" "%%k"
        )
        if not exist "%%j" (
            echo 三次不存在文件，开始下载
            echo [error]"%%j":file not exist 3 times, try to download again... >>Version.txt
            %aria% -x1 -o "%%j" "%%k"
        )
        if exist "%%j" (
            echo 存在文件，运行并等待安装
            start "" /wait "%%j" %%l >>Version.txt
            del /f /q "%%j"
            echo "%%j":install successfully >>Version.txt
        ) else (
            echo 不存在文件
            echo [error]"%%j":final file not exist, can not inst >>Version.txt
        )
    ) else (
        echo 不需要安装
        echo [notice]"%%j":isinstall=no, do nothing with >>Version.txt
    )
)

:online6
echo 软件安装完成，正在跳转到对应的类型装机软件安装环节>"%SystemDrive%\Windows\Setup\wallname.txt"
goto %softver%
goto onlinefinish

:onlinepandasys
goto onlinefinish

:onlinepdtechrc
goto onlinefinish

:onlineno
goto onlinefinish

:onlinespoem
goto onlinefinish

:onlinefinish
echo [OSCol]软件安装完成，正在处理已安装软件...>"%SystemDrive%\Windows\Setup\wallname.txt"

echo 尝试卸载OneDrive
taskkill /f /im OneDrive.exe
taskkill /f /im OneDrive*.exe
for /d %%f in ("%localappdata%\Microsoft\OneDrive\*") do (if exist "%%f\OneDriveSetup.exe" "%%f\OneDriveSetup.exe" /uninstall)
echo 关闭OneDrive开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
del /f /q "%SystemDrive%\Windows\System32\Tasks\OneDrive*"
echo 干掉OneDrive资源菜单
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
echo 删除OneDrive残留
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
echo 删除腾信任务栏图标
del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\腾讯QQ.lnk"
del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\微信.lnk"
echo 关闭QQ游戏自启
sc delete QQGameService
echo 按需清理书签
if %softver%==onlinepandasys set zjsoftbrowser=no
if "%softver%"=="onlineno" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks"
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks.bak"
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks.msbak"
    del /f /q "%LOCALAPPDATA%\360ChromeX\Chrome\User Data\Default\360Bookmarks"
    del /f /q "%LOCALAPPDATA%\360ChromeX\Chrome\User Data\Default\Bookmarks"
    del /f /q "%APPDATA%\360se6\User Data\Default\360Bookmarks"
    del /f /q "%APPDATA%\360se6\User Data\Default\Bookmarks"
)
echo 清理重复的浏览器图标
if exist "%PUBLIC%\Desktop\Microsoft Edge.lnk" (
    if exist "%USERPROFILE%\Desktop\Microsoft Edge.lnk" del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
) else if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" (
    copy /y "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" "%PUBLIC%\Desktop\Microsoft Edge.lnk"
)
if exist "%PUBLIC%\Desktop\Google Chrome.lnk" if exist "%USERPROFILE%\Desktop\Google Chrome.lnk" del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"

echo 输出TAG
if not exist "%SystemDrive%\Windows\Version.txt" >"%SystemDrive%\Windows\Version.txt" echo 手动运行
echo zjsoft%softver% by pandasys-osc on %date% at %time% >>"%SystemDrive%\Windows\Version.txt"
>>"%SystemDrive%\Windows\Version.txt" type Version.txt
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.exe"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"
goto onlinefinish1

:onlinefinish1
echo successful %softver%>"%SystemDrive%\Windows\Setup\oscolstate.txt"
cd /d "%~dp0"
