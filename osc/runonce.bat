powershell -window minimized -command "" >nul
@echo off
chcp 936 > nul
title 清理部署残留（第二次进桌面）...
tasklist | find /i "PECMD.exe" && exit
type "%SystemDrive%\Windows\Setup\oscstate.txt" | find /i "successfuldel" || exit

rem if uac is to be enabled, disable desktop and do reboot
if exist "%systemdrive%\Windows\Setup\pandasysuac.txt" (
    taskkill /f /im explorer.exe
)
rem delete desktop icons which is installed by accident and do not use anymore
rem delete third party system tools...
del /f /q "%USERPROFILE%\Desktop\自选软件安装.lnk"
del /f /q "%USERPROFILE%\Desktop\自选软件安装器.lnk"
del /f /q "%USERPROFILE%\Desktop\软件自选安装.lnk"
del /f /q "%USERPROFILE%\Desktop\软件自选安装器.lnk"
del /f /q "%USERPROFILE%\Desktop\系统激活工具^&驱动.lnk"
del /f /q "%USERPROFILE%\Desktop\系统激活工具＆驱动.lnk"
del /f /q "%USERPROFILE%\Desktop\系统激活工具.lnk"
del /f /q "%USERPROFILE%\Desktop\Win10激活工具^&驱动.lnk"
del /f /q "%USERPROFILE%\Desktop\Win10激活工具＆驱动.lnk"
del /f /q "%USERPROFILE%\Desktop\常用软件工具箱.exe"
del /f /q "%USERPROFILE%\Desktop\鹰王软件管家.exe"
rd /s /q "%USERPROFILE%\Desktop\常用工具"
rd /s /q "%USERPROFILE%\Desktop\实用工具"
rd /s /q "%USERPROFILE%\Desktop\冰封推荐软件"
rd /s /q "%USERPROFILE%\Desktop\推荐软件"
rd /s /q "%USERPROFILE%\Desktop\软件自选安装"
rd /s /q "%USERPROFILE%\Desktop\系统激活工具^&驱动"
rd /s /q "%USERPROFILE%\Desktop\系统激活工具＆驱动"
rd /s /q "%USERPROFILE%\Desktop\激活工具和驱动"
rd /s /q "%USERPROFILE%\Desktop\Win10激活工具^&驱动"
rd /s /q "%USERPROFILE%\Desktop\Win10激活工具＆驱动"
rd /s /q "%USERPROFILE%\Desktop\激活^&驱动"
rd /s /q "%USERPROFILE%\Desktop\激活＆驱动"
del /f /q "%PUBLIC%\Desktop\自选软件安装.lnk"
del /f /q "%PUBLIC%\Desktop\自选软件安装器.lnk"
del /f /q "%PUBLIC%\Desktop\软件自选安装.lnk"
del /f /q "%PUBLIC%\Desktop\软件自选安装器.lnk"
del /f /q "%PUBLIC%\Desktop\系统激活工具^&驱动.lnk"
del /f /q "%PUBLIC%\Desktop\系统激活工具＆驱动.lnk"
del /f /q "%PUBLIC%\Desktop\系统激活工具.lnk"
del /f /q "%PUBLIC%\Desktop\Win10激活工具^&驱动.lnk"
del /f /q "%PUBLIC%\Desktop\Win10激活工具＆驱动.lnk"
del /f /q "%PUBLIC%\Desktop\常用软件工具箱.exe"
rd /s /q "%PUBLIC%\Desktop\常用工具"
rd /s /q "%PUBLIC%\Desktop\实用工具"
rd /s /q "%PUBLIC%\Desktop\冰封推荐软件"
rd /s /q "%PUBLIC%\Desktop\推荐软件"
rd /s /q "%PUBLIC%\Desktop\软件自选安装"
rd /s /q "%PUBLIC%\Desktop\系统激活工具^&驱动"
rd /s /q "%PUBLIC%\Desktop\系统激活工具＆驱动"
rd /s /q "%PUBLIC%\Desktop\激活工具和驱动"
rd /s /q "%PUBLIC%\Desktop\Win10激活工具^&驱动"
rd /s /q "%PUBLIC%\Desktop\Win10激活工具＆驱动"
rd /s /q "%PUBLIC%\Desktop\激活^&驱动"
rd /s /q "%PUBLIC%\Desktop\激活＆驱动"
rd /s /q "%SystemDrive%\推荐软件"
rd /s /q "%SystemDrive%\自选软件安装"
rd /s /q "%SystemDrive%\自选软件安装器"
rd /s /q "%SystemDrive%\软件自选安装"
rd /s /q "%SystemDrive%\软件自选安装器"
rd /s /q "%SystemDrive%\系统激活工具^&驱动"
rd /s /q "%SystemDrive%\系统激活工具＆驱动"
rd /s /q "%SystemDrive%\系统激活工具"
rd /s /q "%SystemDrive%\Win10激活工具^&驱动"
rd /s /q "%SystemDrive%\Win10激活工具＆驱动"
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\系统激活工具^&驱动"
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\系统激活工具＆驱动"

rem delete third party system sysprep files...
attrib -s -h -r "%SystemDrive%\Windows\Microsoft.NET\Framework\1069" /D
rd /s /q "%SystemDrive%\Windows\Microsoft.NET\Framework\1069"
attrib -s -h -r "%SystemDrive%\Windows\soft" /D
rd /s /q "%SystemDrive%\Windows\soft"
attrib -s -h -r "%SystemDrive%\Windows\SDATA" /D
rd /s /q "%SystemDrive%\Windows\SDATA"
attrib -s -h -r "%SystemDrive%\soft" /D
rd /s /q "%SystemDrive%\soft"
attrib -s -h -r "%SystemDrive%\wandrv" /D
rd /s /q "%SystemDrive%\wandrv"

rem delete cxsoft xiaoranosc heu...
del /f /s /q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"
del /f /q "%SystemDrive%\Windows\Setup\oscrunstate.txt"
del /f /q "%SystemDrive%\Windows\Setup\pandasyspasswd.txt"
del /f /q "%SystemDrive%\Windows\CxSoftQii.ini"
rd /s /q "%SystemDrive%\Windows\OsConfig"
rd /s /q "%SystemDrive%\Windows\Setup\Run"
del /f /q "%SystemDrive%\Documents and Settings\All Users\桌面\优化系统.exe"
del /f /q "%SystemDrive%\Users\Public\Desktop\优化系统.exe"
del /f /q "%SystemDrive%\优化系统.exe"
if not exist "%SystemDrive%\Windows\Setup\Set\apifiles\selfdel.bat" del /f /s /q "%SystemDrive%\Windows\Setup\Set\*"
attrib -s -h -r "%SystemDrive%\Windows\_temp_heu168yyds" /D
rd /s /q "%SystemDrive%\Windows\_temp_heu168yyds"

rem delete system deploy or drivers temp
rd /s /q "%SystemDrive%\AMD"
rd /s /q "%SystemDrive%\NVIDIA"
rd /s /q "%SystemDrive%\Drivers"
rd /s /q "%SystemDrive%\DrvPath"
del /f /s /q "%SystemDrive%\sysprep\*"
rd /s /q "%SystemDrive%\sysprep"
del /f /s /q "%SystemDrive%\wandrv\*"
rd /s /q "%SystemDrive%\wandrv"
del /f /q "%SystemDrive%\Windows\CxSoftQii.ini"
del /f /q "%SystemDrive%\Windows\KillPE.dat"
del /f /q "%SystemDrive%\Windows\PETime.dat"
del /f /q "%SystemDrive%\Windows\NoRun.log"
del /f /q "%SystemDrive%\Windows\reg.ini"
del /f /q "%SystemDrive%\Windows\regini.ini"
for /f "delims=" %%a in ('dir /b /a %systemdrive%\~EasyDrv.Temp.*') do rd /s /q "%systemdrive%\%%a"

del /f /s /q "%SystemDrive%\Windows\Setup\Set\*"
rd /s /q "%SystemDrive%\Windows\Setup\Set"
del /f /q "%SystemDrive%\Windows\Panther\unattend.xml"
del /f /q "%SystemDrive%\Windows\Panther\unattend1.xml"

rem rebuild temp folders
for /f "tokens=*" %%a in ('dir /a:D /b "%temp%"') do rd /s /q "%%~a"
for /f "tokens=*" %%a in ('dir /a:-D /b "%temp%"') do del /f /q "%%~a"
for /f "tokens=*" %%a in ('dir /a:D /b "%SystemDrive%\Windows\Temp"') do rd /s /q "%%~a"
for /f "tokens=*" %%a in ('dir /a:-D /b "%SystemDrive%\Windows\Temp"') do del /f /q "%%~a"

rem cleanup system trashes
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16
for /f "delims=" %%i in ('WEvtUtil el') do (WEvtUtil cl "%%i")

rem delete history
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched /f

rem clean up duplicate browser icons
if exist "%PUBLIC%\Desktop\Microsoft Edge.lnk" if exist "%USERPROFILE%\Desktop\Microsoft Edge.lnk" del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
if exist "%PUBLIC%\Desktop\Google Chrome.lnk" if exist "%USERPROFILE%\Desktop\Google Chrome.lnk" del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"

rem bcd timeout
bcdedit /? >nul && bcdedit /timeout 3

echo successfulrunonce>"%SystemDrive%\Windows\Setup\oscstate.txt"

rem enable uac
if exist "%systemdrive%\Windows\Setup\pandasysuac.txt" (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d 1 /f
    shutdown /r /t 5 /c "系统部署完成，重启后生效（OSC）"
)

start /min cmd /c del /f /q %0