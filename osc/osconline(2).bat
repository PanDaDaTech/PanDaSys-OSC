chcp 936 > nul
chcp 936 > nul

::
:: Author: ��Ȯ���� & PanDaTech
:: Description: ��Ȼϵͳ�Ż���� For PanDaSys osc.exe�����ƶ˿��������ļ�
:: Date: 10:06 2025/5/3
:: Note: ת��/�޸��뱣������Ϣ
::

@echo off
title ��Ȼϵͳ�Ż���� For PanDaSys osc.exe�����ƶ˿��������ļ�
if not defined url set url=https://url.xrgzs.top
setlocal enabledelayedexpansion
echo ��ֹ��������
if not exist "%SystemDrive%\Windows\Setup\Set\osc\aria2c.exe" exit
taskkill /f /im msedge.exe

echo ���ϵͳ�Ƿ�ΪXP
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
echo [OSCol]����������...>"%SystemDrive%\Windows\Setup\wallname.txt"
echo �����жϻ�����...
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
echo ����ʱ��Ϊ�й�
if exist "%SystemDrive%\Windows\System32\tzutil.exe" tzutil /s "China Standard Time"
echo У��ʱ��
if "%isoffline%"=="0" %PECMD% NTPC ntp1.aliyun.com
echo ���DNS����
ipconfig /flushdns
echo [OSCol]���ڼ�����...>"%SystemDrive%\Windows\Setup\wallname.txt"
curl.exe --version || (
    %aria% -o "curl.exe" "%url%/curlxp"
    %aria% -o "curl-ca-bundle.crt" "%url%/curlca"
)

echo [OSCol]����Ӧ�������Ż�����...>"%SystemDrive%\Windows\Setup\wallname.txt"
taskkill /f /im OfficeC2RClient.exe
goto online1

:online1
echo Win10-11ר���Ż�
ver | find /i "10.0." && (
    if "%isoffline%"=="0" (
        if exist "%LocalAppData%\Microsoft\WindowsApps\winget.exe" (
            echo WinGet ��Դ
            winget source remove winget && winget source add winget https://mirrors.cernet.edu.cn/winget-source
        )
    )
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set bigversion=%%a
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set smallversion=%%b
)

echo ��Դ����
set notebook=0
echo wxp-11�ж��Ƿ�Ϊ�ʼǱ�����
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
@rem ��ֹ���⽫Ʒ�ƻ�MoDTʶ��Ϊ�ʼǱ�
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set notebook=0

echo ������
powercfg setactive SCHEME_BALANCED

if %notebook% GEQ 1 (
    echo �ʼǱ���������
    powercfg /h on
    echo �ʼǱ�����С����
    reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 0 /f
    echo �ʼǱ������Զ�Ϣ��
    POWERCFG /x monitor-timeout-dc 5
    POWERCFG /x standby-timeout-dc 30
    echo �ʼǱ�������������
    reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
) else (
    echo ̨ʽ������С����
    reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f
    echo ��Դ��ť��������Ϊ�ػ�
    powercfg -setdcvalueindex SCHEME_MAX SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_MAX SUB_BUTTONS PBUTTONACTION 3
    powercfg -setdcvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 3
    powercfg -setdcvalueindex SCHEME_BALANCED SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_BALANCED SUB_BUTTONS PBUTTONACTION 3
    echo ����USBѡ������ͣ
    powercfg -setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
)

:online
echo �����ж����ذ�װϵͳ��ǿ���
set os_arch=%PROCESSOR_ARCHITECTURE%
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set os_arch=x64
if not exist "%SystemDrive%\Windows\Setup\pandasysnoruntime.txt" (
    if not exist "%SystemDrive%\Windows\Fonts\FZXBSK.ttf" (
        echo [OSCol]���ڰ�װϵͳ��ǿ��� xrfonts...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist xrfonts.exe if "%isoffline%"=="0" %aria% -x16 -j16 -s16 -o xrfonts.exe "%url%/xrfonts"
        if exist xrfonts.exe start /wait xrfonts.exe && del /f /q xrfonts.exe
    )
    ver | find /i "10.0." && (
        if not exist "%SystemDrive%\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App\8.*" (
            echo [OSCol]���ڰ�װϵͳ��ǿ��� .NET 8...>"%SystemDrive%\Windows\Setup\wallname.txt"
            if not exist "dotnet8-%os_arch%.exe" if "%isoffline%"=="0" %aria% -x16 -j16 -s16 -o "dotnet8-%os_arch%.exe" "%url%/dotnet8-%os_arch%"
            if exist "dotnet8-%os_arch%.exe" start "" /wait "dotnet8-%os_arch%.exe" /q /norestart && del /f /q "dotnet8-%os_arch%.exe"
        )
    )
)

:onlinefinish
echo [OSCol]���ڴ����������...>"%SystemDrive%\Windows\Setup\wallname.txt"

echo ����ж�� OneDrive
taskkill /f /im OneDrive.exe
taskkill /f /im OneDrive*.exe
for /d %%f in ("%localappdata%\Microsoft\OneDrive\*") do (if exist "%%f\OneDriveSetup.exe" "%%f\OneDriveSetup.exe" /uninstall)
echo �ر� OneDrive ��������
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
del /f /q "%SystemDrive%\Windows\System32\Tasks\OneDrive*"
echo �ɵ� OneDrive ��Դ�˵�
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
echo ɾ�� OneDrive ����
if not exist "%USERPROFILE%\Appdata\Local\Microsoft\OneDrive\OneDrive.exe" (
    del /f /q "%AppData%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
    rd /s /q "%LocalAppData%\Microsoft\OneDrive"
    rd /s /q "%ProgramData%\Microsoft OneDrive"
    rd /s /q "%SystemDrive%\OneDriveTemp"
    REG Delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
    REG Delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
)
echo �ر�������忪������
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v RTHDVCPL /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v HotKeysCmds /f
echo �ر����ſ�������
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v WeChat /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v QQ /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v QQNT /f
echo �ر�Acrobat��������
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Acrobat Assistant 8.0" /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "AdobeGCInvoker-1.0" /f
schtasks /delete /tn "\Adobe Acrobat Update Task" /f
sc delete AdobeARMservice
sc delete AGMService
sc delete AGSService
echo �ر�WPS��������
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
echo �ر�Steam��������
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Steam" /f
echo ���Office2016���°汾����δ֪�����ѿ�������
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Arial Unicode MS (TrueType)" /f
del /f /q "%SystemDrive%\Windows\Fonts\ARIALUNI.TTF"
echo ɾ��QQ������ͼ��
del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\��ѶQQ.lnk"
echo �ر�QQ��Ϸ����
sc delete QQGameService
echo �����ظ��������ͼ��
if exist "%PUBLIC%\Desktop\Microsoft Edge.lnk" (
    if exist "%USERPROFILE%\Desktop\Microsoft Edge.lnk" del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
) else if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" (
    copy /y "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" "%PUBLIC%\Desktop\Microsoft Edge.lnk"
)
if exist "%PUBLIC%\Desktop\Google Chrome.lnk" if exist "%USERPROFILE%\Desktop\Google Chrome.lnk" del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"

echo ���TAG
if not exist "%SystemDrive%\Windows\Version.txt" >"%SystemDrive%\Windows\Version.txt" echo �ֶ�����
echo zjsoft%softver% by xrosc on %date% at %time% >>"%SystemDrive%\Windows\Version.txt"
>>"%SystemDrive%\Windows\Version.txt" type Version.txt
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.exe"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"
goto onlinefinish1

:onlinefinish1
echo successful %softver%>"%SystemDrive%\Windows\Setup\oscolstate.txt"
cd /d "%~dp0"
