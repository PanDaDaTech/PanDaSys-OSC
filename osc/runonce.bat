@rem %1(start /min cmd.exe /c %0 :& exit )
powershell -window minimized -command "" >nul
@echo off
chcp 936 > nul
title ������������ڶ��ν����棩...
tasklist | find /i "PECMD.exe" && exit
type "%SystemDrive%\Windows\Setup\oscstate.txt" | find /i "successfuldel" || exit

rem delete desktop icons which is installed by accident and do not use anymore
rem delete third party system tools...
del /f /q "%USERPROFILE%\Desktop\��ѡ�����װ.lnk"
del /f /q "%USERPROFILE%\Desktop\��ѡ�����װ��.lnk"
del /f /q "%USERPROFILE%\Desktop\�����ѡ��װ.lnk"
del /f /q "%USERPROFILE%\Desktop\�����ѡ��װ��.lnk"
del /f /q "%USERPROFILE%\Desktop\ϵͳ�����^&����.lnk"
del /f /q "%USERPROFILE%\Desktop\ϵͳ����ߣ�����.lnk"
del /f /q "%USERPROFILE%\Desktop\ϵͳ�����.lnk"
del /f /q "%USERPROFILE%\Desktop\Win10�����^&����.lnk"
del /f /q "%USERPROFILE%\Desktop\Win10����ߣ�����.lnk"
del /f /q "%USERPROFILE%\Desktop\�������������.exe"
del /f /q "%USERPROFILE%\Desktop\ӥ������ܼ�.exe"
rd /s /q "%USERPROFILE%\Desktop\���ù���"
rd /s /q "%USERPROFILE%\Desktop\ʵ�ù���"
rd /s /q "%USERPROFILE%\Desktop\�����Ƽ����"
rd /s /q "%USERPROFILE%\Desktop\�Ƽ����"
rd /s /q "%USERPROFILE%\Desktop\�����ѡ��װ"
rd /s /q "%USERPROFILE%\Desktop\ϵͳ�����^&����"
rd /s /q "%USERPROFILE%\Desktop\ϵͳ����ߣ�����"
rd /s /q "%USERPROFILE%\Desktop\����ߺ�����"
rd /s /q "%USERPROFILE%\Desktop\Win10�����^&����"
rd /s /q "%USERPROFILE%\Desktop\Win10����ߣ�����"
rd /s /q "%USERPROFILE%\Desktop\����^&����"
rd /s /q "%USERPROFILE%\Desktop\�������"
del /f /q "%PUBLIC%\Desktop\��ѡ�����װ.lnk"
del /f /q "%PUBLIC%\Desktop\��ѡ�����װ��.lnk"
del /f /q "%PUBLIC%\Desktop\�����ѡ��װ.lnk"
del /f /q "%PUBLIC%\Desktop\�����ѡ��װ��.lnk"
del /f /q "%PUBLIC%\Desktop\ϵͳ�����^&����.lnk"
del /f /q "%PUBLIC%\Desktop\ϵͳ����ߣ�����.lnk"
del /f /q "%PUBLIC%\Desktop\ϵͳ�����.lnk"
del /f /q "%PUBLIC%\Desktop\Win10�����^&����.lnk"
del /f /q "%PUBLIC%\Desktop\Win10����ߣ�����.lnk"
del /f /q "%PUBLIC%\Desktop\�������������.exe"
rd /s /q "%PUBLIC%\Desktop\���ù���"
rd /s /q "%PUBLIC%\Desktop\ʵ�ù���"
rd /s /q "%PUBLIC%\Desktop\�����Ƽ����"
rd /s /q "%PUBLIC%\Desktop\�Ƽ����"
rd /s /q "%PUBLIC%\Desktop\�����ѡ��װ"
rd /s /q "%PUBLIC%\Desktop\ϵͳ�����^&����"
rd /s /q "%PUBLIC%\Desktop\ϵͳ����ߣ�����"
rd /s /q "%PUBLIC%\Desktop\����ߺ�����"
rd /s /q "%PUBLIC%\Desktop\Win10�����^&����"
rd /s /q "%PUBLIC%\Desktop\Win10����ߣ�����"
rd /s /q "%PUBLIC%\Desktop\����^&����"
rd /s /q "%PUBLIC%\Desktop\�������"
rd /s /q "%SystemDrive%\�Ƽ����"
rd /s /q "%SystemDrive%\��ѡ�����װ"
rd /s /q "%SystemDrive%\��ѡ�����װ��"
rd /s /q "%SystemDrive%\�����ѡ��װ"
rd /s /q "%SystemDrive%\�����ѡ��װ��"
rd /s /q "%SystemDrive%\ϵͳ�����^&����"
rd /s /q "%SystemDrive%\ϵͳ����ߣ�����"
rd /s /q "%SystemDrive%\ϵͳ�����"
rd /s /q "%SystemDrive%\Win10�����^&����"
rd /s /q "%SystemDrive%\Win10����ߣ�����"
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\ϵͳ�����^&����"
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\ϵͳ����ߣ�����"

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
del /f /q "%SystemDrive%\Windows\Setup\xrsyspasswd.txt"
del /f /q "%SystemDrive%\Windows\CxSoftQii.ini"
rd /s /q "%SystemDrive%\Windows\OsConfig"
rd /s /q "%SystemDrive%\Windows\Setup\Run"
del /f /q "%SystemDrive%\Documents and Settings\All Users\����\�Ż�ϵͳ.exe"
del /f /q "%SystemDrive%\Users\Public\Desktop\�Ż�ϵͳ.exe"
del /f /q "%SystemDrive%\�Ż�ϵͳ.exe"
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

@rem for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
@rem     attrib -s -h -r "%%a:\~WTDR.Pack_Temp" /D
@rem     rd /s /q "%%a:\~WTDR.Pack_Temp"
@rem )
del /f /s /q "%SystemDrive%\Windows\Setup\Set\*"
rd /s /q "%SystemDrive%\Windows\Setup\Set"
del /f /q "%SystemDrive%\Windows\Panther\unattend.xml"
del /f /q "%SystemDrive%\Windows\Panther\unattend1.xml"

rem rebuild temp folders
rd /s /q "%TEMP%"
MKDIR "%TEMP%"
rd /s /q "%SystemDrive%\Windows\Temp"
MKDIR "%SystemDrive%\Windows\Temp"

rem cleanup system trashes
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16
for /f "delims=" %%i in ('WEvtUtil el') do (WEvtUtil cl "%%i")

rem delete history
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched /f

rem bcd timeout
bcdedit /? >nul && bcdedit /timeout 3

rem enable uac
if exist "%systemdrive%\Windows\Setup\xrsysuac.txt" (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d 1 /f
)

echo successfulrunonce>"%SystemDrive%\Windows\Setup\oscstate.txt"
start /min cmd /c del /f /q %0