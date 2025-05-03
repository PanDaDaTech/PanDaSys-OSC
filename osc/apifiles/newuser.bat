@echo off
setlocal enabledelayedexpansion
chcp 936 > nul
cd /d "%~dp0"
title �����û�OOBE (Build 2025.2.5)
rem windows xp not create new user
ver | find /i "5.1." && exit
set name=User
set pcname=Admin-PC

:getpcname
rem �����ĸ������ĸ
set str=ABCDEFGHIJKLMNOPQRSTUVWXYZ
for /l %%a in (1 1 4) do (
    set /a n=!random!%%26
    call set random_letters=%%str:~!n!,1%%!random_letters!
)

rem preset pcname
if exist "%SystemDrive%\Windows\Setup\pandasyspcname.txt" (
    set /p pcname=<"%SystemDrive%\Windows\Setup\pandasyspcname.txt"
) else (
    set pcname=PC-%date:~0,4%%date:~5,2%%date:~8,2%%random_letters%
)

:getspoem
rem support oem special
if exist "%SystemDrive%\Windows\Setup\pandasysadmin.txt" (
    set name=Administrator
    del /f /q "%SystemDrive%\Windows\Setup\pandasysnewuser.txt"
    goto findok
) else if exist "%SystemDrive%\Windows\Setup\pandasysnewuser.txt" ( 
    set /P name=<"%SystemDrive%\Windows\Setup\pandasysnewuser.txt"
    del /f /q "%SystemDrive%\Windows\Setup\pandasysadmin.txt"
    goto findok
)

:getdmi
rem use dmi get motherboard info
if exist DMI.exe (
    DMI.exe>DMI.txt
    copy /y DMI.txt "%SystemDrive%\Windows\Setup\DMI.txt"
)
if not exist DMI.txt (
    set name=User
    goto findok
)

:findbios
rem get line number
FOR /F "tokens=1 delims=:" %%a IN ('findstr /i /n /c:"BIOS Information" DMI.txt') DO set l=%%a
rem get pinpai with first blank (need optimize)
FOR /F "skip=%l% tokens=1,2 delims=:" %%a IN (DMI.txt) DO (
	set biospinpai=%%b
	goto findxitong
)
:findxitong
rem get line number
FOR /F "tokens=1 delims=:" %%a IN ('findstr /i /n /c:"System Information" DMI.txt') DO set l=%%a
rem get pinpai with first blank (need optimize)
FOR /F "skip=%l% tokens=1,2 delims=:" %%a IN (DMI.txt) DO (
	set xitongpinpai=%%b
	goto findzhuban
)

:findzhuban
rem get line number
FOR /F "tokens=1 delims=:" %%a IN ('findstr /i /n /c:"Base Board Information" DMI.txt') DO set l=%%a
rem get pinpai with first blank (need optimize)
FOR /F "skip=%l% tokens=1,2 delims=:" %%a IN (DMI.txt) DO (
	set zhubanpinpai=%%b
	goto matchoem
)

:matchoem
rem delete blank
set "pinpai=%zhubanpinpai: =% %xitongpinpai: =% %biospinpai: =%"
rem debugpinpai in dmi.txt
>>DMI.txt echo debug:%pinpai%
rem match pinpai
if "%pinpai%"=="" set name=User&& goto findok
echo %pinpai% | find /i "vmware" && set name=VMware&& goto findok
echo %pinpai% | find /i "lenovo" && set name=Lenovo&& goto findok
echo %pinpai% | find /i "Think" && set name=Think&& goto findok
echo %pinpai% | find /i "dell" && set name=Dell&& goto findok
echo %pinpai% | find /i "Alienware" && set name=Alienware&& goto findok
echo %pinpai% | find /i "HP" && set name=HP&& goto findok
echo %pinpai% | find /i "Hewlett-Packard" && set name=HP&& goto findok
echo %pinpai% | find /i "Apple" && set name=Apple&& goto findok
echo %pinpai% | find /i "acer" && set name=Acer&& goto findok
echo %pinpai% | find /i "Surface" && set name=Surface&& goto findok
echo %pinpai% | find /i "HUAWEI" && set name=Huawei&& goto findok
echo %pinpai% | find /i "honor" && set name=Honor&& goto findok
echo %pinpai% | find /i "xiaomi" && set name=Xiaomi&& goto findok
echo %pinpai% | find /i "redmi" && set name=Redmi&& goto findok
echo %pinpai% | find /i "MACHENIKE" && set name=Machenike&& goto findok
echo %pinpai% | find /i "ThundeRobot" && set name=ThundeRobot&& goto findok
echo %pinpai% | find /i "HASEE" && set name=Hasee&& goto findok
echo %pinpai% | find /i "ASUS" && set name=ASUS&& goto findok
echo %pinpai% | find /i "ROG" && set name=ROG&& goto findok
echo %pinpai% | find /i "ASRock" && set name=ASRock&& goto findok
echo %pinpai% | find /i "GIGABYTE" && set name=Gigabyte&& goto findok
echo %pinpai% | find /i "msi" && set name=Msi&& goto findok
echo %pinpai% | find /i "micro-star" && set name=Msi&& goto findok
echo %pinpai% | find /i "BIOSTAR" && set name=Biostar&& goto findok
echo %pinpai% | find /i "Soyo" && set name=Soyo&& goto findok
echo %pinpai% | find /i "Colorful" && set name=Colorful&& goto findok
echo %pinpai% | find /i "MAXSUN" && set name=Maxsun&& goto findok
echo %pinpai% | find /i "ONDA" && set name=Onda&& goto findok
echo %pinpai% | find /i "AZW" && set name=Beelink&& goto findok
echo %pinpai% | find /i "FUJITSU" && set name=Fujitsu&& goto findok
echo %pinpai% | find /i "Samsung" && set name=SAMSUNG&& goto findok
echo %pinpai% | find /i "seewo" && set name=seewo&& goto findok
echo %pinpai% | find /i "HiteVision" && set name=HiteVision&& goto findok
echo %pinpai% | find /i "WenXiang" && set name=WXKJ&& goto findok
set name=User
goto findok
:findok

:oobe
@REM if exist "%systemdrive%\Windows\System32\osk.exe" start osk.exe
rem ask pcname
if not exist "%SystemDrive%\Windows\Setup\pandasyspcname.txt" if exist Winput.exe for /f "tokens=1" %%a in ('Winput.exe "OOBE - ����������" "$input" "��������Ҫ���õĻ�������^^ - �����������������/�ո�^^ - Ŀǰû�з������ƣ�������Ը� ^^ - 15s��δ������Ӧ�򱣳�Ĭ��" "%pcname%" /screen /FS^=12 /length:24 /timeout^=15s') do set "pcnameinput=%%a"
rem ask user
if not exist "%SystemDrive%\Windows\Setup\pandasysnewuser.txt" if not exist "%SystemDrive%\Windows\Setup\pandasysadmin.txt" if exist Winput.exe for /f "tokens=1" %%a in ('Winput.exe "OOBE - �û�����" "$input" "��������Ҫ�������û�����^^ - �û��������������/���/�ո�^^ - Ŀǰû�з������ƣ����ᵼ��ϵͳ��װʧ�� ^^ - 15s��δ������Ӧ�򱣳�Ĭ��" "%name%" /screen /FS^=12 /length:24 /timeout^=15') do set "nameinput=%%a"
rem ask passwd
if not exist "%SystemDrive%\Windows\Setup\pandasyspasswd.txt" if exist Winput.exe for /f "tokens=1" %%a in ('Winput.exe "OOBE - �û���������" "$input" "��������Ҫ���õ����룺^^ - ���������������/�ո�^^ - Ŀǰû�з������ƣ�������Ը� ^^ - 15s��δ������Ӧ�򱣳�Ĭ��" "" /screen /FS^=12 /length:255 /timeout^=15s') do set "passinput=%%a"
rem ask uac
if not exist "%SystemDrive%\Windows\Setup\pandasysuac.txt" if exist Winput.exe (
    wbox.exe "OOBE - UAC ����" "�Ƿ����� UAC���û��˻����ƣ���^^����UAC�ɱ����ֻ����г���^�����ܻ���������ٶȣ�^���Ҳ��������װ��^^ - 15s��δ������Ӧ�򱣳�Ĭ��" "���ֹر� -$- ;����" /TM=15 /FS=12
    if "!errorlevel!"=="2" (
        echo 1 >"%SystemDrive%\Windows\Setup\pandasysuac.txt"
    )
)
rem write pandasyspasswd tag
if defined passinput >"%SystemDrive%\Windows\Setup\pandasyspasswd.txt" echo %passinput%
rem clear passwd var
set passinput=
rem delete blank
if defined nameinput set "name=%nameinput%"
if defined pcnameinput set "pcname=%pcnameinput%"
rem backup var
if defined name >"%SystemDrive%\Windows\Setup\pandasysnewuser.txt" echo %name%
if defined pcname >"%SystemDrive%\Windows\Setup\pandasyspcname.txt" echo %pcname%
rem detect rdp
if exist "%SystemDrive%\Windows\Setup\pandasysrdp.txt" if not exist "%SystemDrive%\Windows\Setup\pandasyspasswd.txt" echo 1 >"%SystemDrive%\Windows\Setup\pandasyspasswd.txt"
goto setname

:setname
rem check var
if not defined name set name=User
rem active admin
if not "%name%"=="Administrator" (
    NET USER Administrator /ACTIVE:NO
    NET LOCALGROUP Users %name% /ADD
) else (
    NET USER Administrator /ACTIVE:yes
    echo isadmin >"%SystemDrive%\Windows\Setup\pandasysadmin.txt"
)
rem user group config
NET ACCOUNTS /MAXPWAGE:UNLIMITED
NET USERS %name% /ADD /ACTIVE:YES /EXPIRES:NEVER /PASSWORDCHG:YES /PASSWORDREQ:NO /LOGONPASSWORDCHG:NO 
NET USERS %name% /ADD 
NET USERS %name% /ACTIVE:YES
NET USERS %name% /EXPIRES:NEVER
NET USERS %name% /PASSWORDCHG:YES
NET USERS %name% /PASSWORDREQ:NO
NET USERS %name% /LOGONPASSWORDCHG:NO 
NET LOCALGROUP Administrators %name% /ADD
rem password no expiration
NetUser.exe %name% /pwnexp:y

endlocal
exit