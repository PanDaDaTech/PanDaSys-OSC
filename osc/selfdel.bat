@echo off
chcp 936 > nul
title ������������״��˳����棩...
cd /d "%~dp0"

rem self kill
taskkill /f /im "�Ż�ϵͳ.exe"
taskkill /f /im "osc.exe"

rem delete desktop icons which is installed by accident and do not use anymore
rem delete third party system tools...
del /f /q "%USERPROFILE%\Desktop\��ѡ�����װ.lnk"
del /f /q "%USERPROFILE%\Desktop\��ѡ�����װ��.lnk"
del /f /q "%USERPROFILE%\Desktop\�����ѡ��װ.lnk"
del /f /q "%USERPROFILE%\Desktop\�����ѡ��װ��.lnk"
del /f /q "%USERPROFILE%\Desktop\ϵͳ�����&����.lnk"
del /f /q "%USERPROFILE%\Desktop\ϵͳ����ߣ�����.lnk"
del /f /q "%USERPROFILE%\Desktop\ϵͳ�����.lnk"
del /f /q "%USERPROFILE%\Desktop\Win10�����&����.lnk"
del /f /q "%USERPROFILE%\Desktop\Win10����ߣ�����.lnk"
del /f /q "%USERPROFILE%\Desktop\�������������.exe"
del /f /q "%USERPROFILE%\Desktop\ӥ������ܼ�.exe"
rd /s /q "%USERPROFILE%\Desktop\���ù���"
rd /s /q "%USERPROFILE%\Desktop\ʵ�ù���"
rd /s /q "%USERPROFILE%\Desktop\�����Ƽ����"
rd /s /q "%USERPROFILE%\Desktop\�Ƽ����"
rd /s /q "%USERPROFILE%\Desktop\�����ѡ��װ"
rd /s /q "%USERPROFILE%\Desktop\ϵͳ�����&����"
rd /s /q "%USERPROFILE%\Desktop\ϵͳ����ߣ�����"
rd /s /q "%USERPROFILE%\Desktop\����ߺ�����"
rd /s /q "%USERPROFILE%\Desktop\Win10�����&����"
rd /s /q "%USERPROFILE%\Desktop\Win10����ߣ�����"
rd /s /q "%USERPROFILE%\Desktop\����&����"
rd /s /q "%USERPROFILE%\Desktop\�������"
del /f /q "%PUBLIC%\Desktop\��ѡ�����װ.lnk"
del /f /q "%PUBLIC%\Desktop\��ѡ�����װ��.lnk"
del /f /q "%PUBLIC%\Desktop\�����ѡ��װ.lnk"
del /f /q "%PUBLIC%\Desktop\�����ѡ��װ��.lnk"
del /f /q "%PUBLIC%\Desktop\ϵͳ�����&����.lnk"
del /f /q "%PUBLIC%\Desktop\ϵͳ����ߣ�����.lnk"
del /f /q "%PUBLIC%\Desktop\ϵͳ�����.lnk"
del /f /q "%PUBLIC%\Desktop\Win10�����&����.lnk"
del /f /q "%PUBLIC%\Desktop\Win10����ߣ�����.lnk"
del /f /q "%PUBLIC%\Desktop\�������������.exe"
rd /s /q "%PUBLIC%\Desktop\���ù���"
rd /s /q "%PUBLIC%\Desktop\ʵ�ù���"
rd /s /q "%PUBLIC%\Desktop\�����Ƽ����"
rd /s /q "%PUBLIC%\Desktop\�Ƽ����"
rd /s /q "%PUBLIC%\Desktop\�����ѡ��װ"
rd /s /q "%PUBLIC%\Desktop\ϵͳ�����&����"
rd /s /q "%PUBLIC%\Desktop\ϵͳ����ߣ�����"
rd /s /q "%PUBLIC%\Desktop\����ߺ�����"
rd /s /q "%PUBLIC%\Desktop\Win10�����&����"
rd /s /q "%PUBLIC%\Desktop\Win10����ߣ�����"
rd /s /q "%PUBLIC%\Desktop\����&����"
rd /s /q "%PUBLIC%\Desktop\�������"
rd /s /q "%SystemDrive%\�Ƽ����"
rd /s /q "%SystemDrive%\��ѡ�����װ"
rd /s /q "%SystemDrive%\��ѡ�����װ��"
rd /s /q "%SystemDrive%\�����ѡ��װ"
rd /s /q "%SystemDrive%\�����ѡ��װ��"
rd /s /q "%SystemDrive%\ϵͳ�����&����"
rd /s /q "%SystemDrive%\ϵͳ����ߣ�����"
rd /s /q "%SystemDrive%\ϵͳ�����"
rd /s /q "%SystemDrive%\Win10�����&����"
rd /s /q "%SystemDrive%\Win10����ߣ�����"
rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\ϵͳ�����&����"
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
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v RunLoader
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /f /v RunLoader
@rem rd /s /q "%SystemDrive%\Windows\Setup\Run"
del /f /q "%SystemDrive%\Documents and Settings\All Users\����\�Ż�ϵͳ.exe"
del /f /q "%SystemDrive%\Users\Public\Desktop\�Ż�ϵͳ.exe"
del /f /q "%SystemDrive%\�Ż�ϵͳ.exe"
if not exist "%SystemDrive%\Windows\Setup\Set\apifiles\selfdel.bat" del /f /s /q "%SystemDrive%\Windows\Setup\Set\*"
attrib -s -h -r "%SystemDrive%\Windows\_temp_heu168yyds" /D
rd /s /q "%SystemDrive%\Windows\_temp_heu168yyds"
if not exist "%SystemDrive%\Windows\Temp\OSFMount.sys" reg delete "HKLM\SYSTEM\CurrentControlSet\Services\OSFMount" /f

rem get desktop path
for /f "tokens=3,*" %%i in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Common Desktop"') do (set desk=%%j)
for /f "tokens=3,*" %%i in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Common Programs"') do (set pro=%%j)

rem remove drvceo and its protect driver
if not exist "%systemdrive%\Program Files\SysCeo\Drvceo" (
    del /s /q /f "%USERPROFILE%\Desktop\�����ܲ�.lnk"
    del /s /q /f "%USERPROFILE%\Desktop\�ӿ���.lnk"
    del /s /q /f "%USERPROFILE%\Desktop\DrvCeo.lnk"
    del /s /q /f "%USERPROFILE%\����\�����ܲ�.lnk"
    del /s /q /f "%USERPROFILE%\����\�ӿ���.lnk"
    del /s /q /f "%USERPROFILE%\����\DrvCeo.lnk"
    del /s /q /f "%desk%\�����ܲ�.lnk"
    del /s /q /f "%desk%\�ӿ���.lnk"
    del /s /q /f "%desk%\DrvCeo.lnk"
    rd /s /q "%pro%\�����ܲ�"
    rd /s /q "%pro%\�ӿ���"
    rd /s /q "%pro%\DrvCeo"
)
del /q /f "%pro%\..\�����d.lnk"
del /q /f "%pro%\..\��������.lnk"

echo HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\DcProtect  [1 7 17] >reg.ini
regini.exe reg.ini
del /f /q reg.ini
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UFH\SHC" /f
attrib -s -h -r "%systemroot%\Help\dcold.exe"
del /q /f "%systemroot%\Help\dcold.exe"
sc stop DcProtect
sc delete DcProtect
reg delete HKEY_LOCAL_MACHINE\system\ControlSet001\Services\DcProtect\   /f
attrib -s -h -r "%WinDir%\System32\drivers\DcProtect_10x64.sys"
attrib -s -h -r "%WinDir%\System32\drivers\DcProtect_10x86.sys"
attrib -s -h -r "%WinDir%\System32\drivers\DcProtect_7x64.sys"
attrib -s -h -r "%WinDir%\System32\drivers\DcProtect_7x86.sys"
del /f /q "%WinDir%\System32\drivers\DcProtect_10x64.sys"
del /f /q "%WinDir%\System32\drivers\DcProtect_10x86.sys"
del /f /q "%WinDir%\System32\drivers\DcProtect_7x64.sys"
del /f /q "%WinDir%\System32\drivers\DcProtect_7x86.sys"

rem bcd timeout
bcdedit /? >nul && bcdedit /timeout 3

rem create tag log file...
echo successfuldel>"%SystemDrive%\Windows\Setup\oscstate.txt"

rem cleanup system trashes
if exist "%~dp0apifiles\cleanup.reg" regedit /s "%~dp0apifiles\cleanup.reg"
del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\*.lnk"
rd /s /q "%APPDATA%\Microsoft\Windows\Network Shortcuts"
mkdir "%APPDATA%\Microsoft\Windows\Network Shortcuts"
del /f /s /q "%LOCALAPPDATA%\ConnectedDevicesPlatform\ActivitiesCache*"
del /f /s /q "%UserProfile%\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\*.*"
del /f /s /q "%UserProfile%\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations\*.*"

ipconfig /release
ipconfig /release6
ipconfig /flushdns

rem self delete
rd /s /q "%~dp0"

start /min cmd /c del /f /q %0
exit