@echo off
@chcp 936 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
set officeiso=Office.iso
set officever=
set officevernum=
set officeverarch=
set officevertype=
set officeforwin7=no

:readargs
cls
echo ��������ļ���Ϣ��ȡ
if not "%1"=="" if exist "%1" (
  set "officeiso=%1"
  set "officeisoread=%1"
  if not "%2"=="" (
    set "officeisoread=%2"
  ) else (
    set "errorreason=Office ISO �ļ���ȡʧ�ܡ�"
    goto error
  )
  for %%i in (!officeisoread!) do (
    for /f "delims=_ tokens=2,3,4,5" %%a in ("%%~ni") do (
      set "officever=%%a"
      set "officevernum=%%b"
      set "officeverarch=%%c"
      set "officevertype=%%d"
      goto main
    )
  )
)

:readiso
cls
echo Office ISO �ļ���Ϣ��ȡ
for %%i in (*.iso.iso) do move /y "%%i" "%%~ni"
for /r %%i in (Office_*.iso) do (
  set "officeiso=%%i"
  for /f "delims=_ tokens=2,3,4,5" %%a in ("%%~ni") do (
    set "officever=%%a"
    set "officevernum=%%b"
    set "officeverarch=%%c"
    set "officevertype=%%d"
    goto main
  )
)
if not exist "%officeiso%" (
  set "errorreason=Office ISO �ļ������ڡ�"
  goto error
)
if "%officeverarch%"=="x64" set officeverarch=AMD64
:main
title Office %officever% Installer By Xiaoran Studio

:readosver
cls
echo ϵͳ�汾��ȡ
set osver=0
ver | find /i "5.1." > nul && set osver=1
ver | find /i "6.0." > nul && set osver=2
ver | find /i "6.1." > nul && set osver=2
ver | find /i "6.2." > nul && set osver=3
ver | find /i "6.3." > nul && set osver=3
ver | find /i "6.4." > nul && set osver=4
ver | find /i "10.0." > nul && set osver=4
ver | find /i "10.0.2" > nul && set osver=4

:readosarch
cls
echo ϵͳ�ܹ���ȡ(Ӧ��RARSFX)
if exist "%systemdrive%\Windows\SysWOW64\wscript.exe" (
  if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set "PROCESSOR_ARCHITECTURE=AMD64"
  )
)

:findisomount
cls
echo OSFMount �������
if not exist OSFMount.sys (
  if not exist OSFMount.com (
    if not exist OSFMount.exe (
      set "errorreason=OSFMount ��������ڡ�"
      goto error
    )
  )
)
copy /y "OSFMount.sys" "%TEMP%\OSFMount.sys"
copy /y "OSFMount.com" "%TEMP%\OSFMount.com"
copy /y "OSFMount.exe" "%TEMP%\OSFMount.com"

:judgeosarch
cls
echo ϵͳ�ܹ��ж�
if not "%officeverarch%"=="%PROCESSOR_ARCHITECTURE%" (
  if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if "%officeverarch%"=="AMD64" (
      set "errorreason=ϵͳ�ܹ��밲װ����ܹ���ƥ�䡣"
      goto error
    )
  )
)

:judgeosver
cls
echo ϵͳ�汾�ж�
if %officevernum% GEQ 15 (
  if %osver% LEQ 1 (
    set "errorreason=WinXP ϵͳ�汾��֧�֡�"
    goto error
  )
  if %officevernum% GEQ 16 (
    if %osver% LEQ 3 (
      if not "%officever%"=="2016" (
        if not "%officeforwin7%"=="yes" (
          set "errorreason=ϵͳ�汾��֧�����°汾 Office��"
          goto error
        )
      )
    )
  )
)

:finddriveletter
cls
echo ����һ��δʹ�õ��̷�
for %%d in (Z Y X W V U T S R Q P O N M L K J I H G F E) do (
  vol %%d: >nul 2>&1 || (
    set "mountdrive=%%d"
    goto :mount
  )
)
set "errorreason=No available drive letter found."
goto error

:mount
cls
echo ���� Office ISO ��ָ�����̷�
"%TEMP%\OSFMount.com" -a -t file -m %mountdrive%: -f "%officeiso%"

:install
cls
echo ���� Office Setup
if "%officevertype%"=="MSI" (
  if exist "%mountdrive%:\setup.exe" (
 "%mountdrive%:\setup.exe" /config "%~dp0config\%officever%_MSI.xml"
  ) else (
    set "errorreason=δ�ҵ� MSI ��װ����"
    goto error
  )
) else if "%officevertype%"=="C2R" (
  if exist "%mountdrive%:\Office\setup.exe" (
    "%mountdrive%:\Office\setup.exe" /configure "%~dp0config\%officever%_%officeverarch%.xml"
  ) else if exist "%mountdrive%:\setup.exe" (
    "%mountdrive%:\setup.exe" /configure "%~dp0config\%officever%_%officeverarch%.xml"
  ) else (
    set "errorreason=δ�ҵ� C2R ��װ����"
    goto error
  )
)

:unmount
cls
echo ж�� Office ISO
"%TEMP%\OSFMount.com" -d -m %mountdrive%:
del /f /q "%officeiso%"

:pdfandxps
cls
echo ��װ SaveAsPDFandXPS �����Office 2007��
if exist SaveAsPDFandXPS.exe start /wait SaveAsPDFandXPS.exe /quiet

:createdesktoplnk
cls
echo ���������ݷ�ʽ
if %osver% LEQ 1 (
    set "stmenupath=%ALLUSERSPROFILE%\����ʼ���˵�\����"
    set "deskpath=%ALLUSERSPROFILE%\����"
) else (
    set "stmenupath=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs"
    set "deskpath=%PUBLIC%\Desktop"
)
copy /y "%stmenupath%\Microsoft Office\Microsoft Office Word 2007.lnk" "%deskpath%\Word 2007.lnk"
copy /y "%stmenupath%\Microsoft Office\Microsoft Office PowerPoint 2007.lnk" "%deskpath%\PowerPoint 2007.lnk"
copy /y "%stmenupath%\Microsoft Office\Microsoft Office Excel 2007.lnk" "%deskpath%\Excel 2007.lnk"
copy /y "%stmenupath%\Microsoft Office\Microsoft Word 2010.lnk" "%deskpath%\Word 2010.lnk"
copy /y "%stmenupath%\Microsoft Office\Microsoft PowerPoint 2010.lnk" "%deskpath%\PowerPoint 2010.lnk"
copy /y "%stmenupath%\Microsoft Office\Microsoft Excel 2010.lnk" "%deskpath%\Excel 2010.lnk"
copy /y "%stmenupath%\Microsoft Office 2013\Excel 2013.lnk" "%deskpath%\Excel 2013.lnk"
copy /y "%stmenupath%\Microsoft Office 2013\PowerPoint 2013.lnk" "%deskpath%\PowerPoint 2013.lnk"
copy /y "%stmenupath%\Microsoft Office 2013\Word 2013.lnk" "%deskpath%\Word 2013.lnk"
copy /y "%stmenupath%\Excel 2016.lnk" "%deskpath%\Excel 2016.lnk"
copy /y "%stmenupath%\PowerPoint 2016.lnk" "%deskpath%\PowerPoint 2016.lnk"
copy /y "%stmenupath%\Word 2016.lnk" "%deskpath%\Word 2016.lnk"
copy /y "%stmenupath%\Excel.lnk" "%deskpath%\Excel.lnk"
copy /y "%stmenupath%\PowerPoint.lnk" "%deskpath%\PowerPoint.lnk"
copy /y "%stmenupath%\Word.lnk" "%deskpath%\Word.lnk"

:fixoffice2013
cls
if %officevernum% EQU 15 (
  echo ɾ�� Office2013 SkyDrive �Ҽ��˵�
  reg delete "HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\SPFS.ContextMenu" /f
  echo ���� Office2013 �״���������
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\FirstRun" /f /v "BootedRTM" /t REG_DWORD /d 1
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Common\General" /f /v "FirstRun" /t REG_DWORD /d 0
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Common\General" /f /v "ShownFirstRunOptin" /t REG_DWORD /d 1
)
if %officevernum% EQU 16 (
  echo ���� Office2016 �״���������
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\General" /f /v "FirstRun" /t REG_DWORD /d 0
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\General" /f /v "ShownFirstRunOptin" /t REG_DWORD /d 1
)
:fixarialfont
cls
if %officevernum% LEQ 15 (
  echo ��� Office2016 ���°汾����δ֪�����ѿ�������
  reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /f /v "Arial Unicode MS (TrueType)"
  del /f /q "%SystemDrive%\Windows\Fonts\ARIALUNI.TTF"
)

:activeoffice
cls
echo ʹ�� KMS ���� Office
if %officevernum% GEQ 14 (
  if exist "%systemdrive%\Program Files\Microsoft Office\Office%officevernum%\OSPP.VBS" (
      set "officepath=%systemdrive%\Program Files\Microsoft Office\Office%officevernum%"
  ) else (
      set "officepath=%systemdrive%\Program Files (x86)\Microsoft Office\Office%officevernum%"
  )
  cd /d "!officepath!"
  if "%officever%"=="365" (
    echo Office 365 ת MondoVL
    cscript //Nologo ospp.vbs /inslic:"..\root\Licenses16\MondoVL_KMS_Client-ppd.xrm-ms"
    cscript //Nologo ospp.vbs /inslic:"..\root\Licenses16\MondoVL_KMS_Client-ul-oob.xrm-ms"
    cscript //Nologo ospp.vbs /inslic:"..\root\Licenses16\MondoVL_KMS_Client-ul.xrm-ms"
    cscript //Nologo ospp.vbs /inslic:"..\root\Licenses16\MondoVL_MAK-pl.xrm-ms"
    cscript //Nologo ospp.vbs /inslic:"..\root\Licenses16\MondoVL_MAK-ppd.xrm-ms"
    cscript //Nologo ospp.vbs /inslic:"..\root\Licenses16\MondoVL_MAK-ul-phn.xrm-ms"
    cscript //Nologo ospp.vbs /inpkey:HFTND-W9MK4-8B7MJ-B6C4G-XQBR2
    echo ���ڴ��� KMS ���� Office �ĵ��浯������...
    if exist "%SystemDrive%\Windows\System32\wbem\WMIC.exe" (
      for /f "tokens=2 delims==" %%G in ('"wmic path SoftwareLicensingProduct where (ApplicationID='0ff1ce15-a989-479d-af46-f275c6370663' and Description like '%%KMSCLIENT%%' and not Description like '%%Office 15%%' and PartialProductKey is not NULL) get ID /VALUE" 2^>nul') do (if defined SKUID (call set "SKUID=!SKUID! %%G") else (call set "SKUID=%%G"))
    ) else (
      for /f "tokens=2 delims==" %%G in ('powershell -EncodedCommand "KABHAGUAdAAtAEMAaQBtAEkAbgBzAHQAYQBuAGMAZQAgAC0AQwBsAGEAcwBzAE4AYQBtAGUAIABTAG8AZgB0AHcAYQByAGUATABpAGMAZQBuAHMAaQBuAGcAUAByAG8AZAB1AGMAdAAgAC0ARgBpAGwAdABlAHIAIAAiAEEAcABwAGwAaQBjAGEAdABpAG8AbgBJAEQAPQAnADAAZgBmADEAYwBlADEANQAtAGEAOQA4ADkALQA0ADcAOQBkAC0AYQBmADQANgAtAGYAMgA3ADUAYwA2ADMANwAwADYANgAzACcAIABhAG4AZAAgAEQAZQBzAGMAcgBpAHAAdABpAG8AbgAgAGwAaQBrAGUAIAAnACUAJQBLAE0AUwBDAEwASQBFAE4AVAAlACUAJwAgAGEAbgBkACAAbgBvAHQAIABEAGUAcwBjAHIAaQBwAHQAaQBvAG4AIABsAGkAawBlACAAJwAlACUATwBmAGYAaQBjAGUAIAAxADUAJQAlACcAIABhAG4AZAAgAFAAYQByAHQAaQBhAGwAUAByAG8AZAB1AGMAdABLAGUAeQAgAGkAcwAgAG4AbwB0ACAATgBVAEwATAAiACAALQBQAHIAbwBwAGUAcgB0AHkAIABJAEQAKQAuAEkARAA="') do (if defined SKUID (call set "SKUID=!SKUID! %%G") else (call set "SKUID=%%G"))
    )
    for %%# in (%SKUID%) do (
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\0ff1ce15-a989-479d-af46-f275c6370663\%%#" /f /v KeyManagementServiceName /t REG_SZ /d "kms.03k.org"
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\0ff1ce15-a989-479d-af46-f275c6370663\%%#" /f /v KeyManagementServicePort /t REG_SZ /d "1688"
    )
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /f /v KeyManagementServiceName /t REG_SZ /d "kms.03k.org"
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /f /v KeyManagementServicePort /t REG_SZ /d "1688"
    reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /f /v KeyManagementServiceName /t REG_SZ /d "kms.03k.org"
    reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /f /v KeyManagementServicePort /t REG_SZ /d "1688"
  )
  if %officevernum% EQU 14 cscript //B //T:15 ospp.vbs /osppsvcrestart
  cscript //B //Nologo ospp.vbs /sethst:kms.03k.org
  cscript //B //Nologo ospp.vbs /setprt:1688
  cscript //B //Nologo ospp.vbs /act
)
cd /d "%~dp0"

:installok
cls
echo Office ��װ���

:selfdelete
taskkill /f /im OfficeC2RClient.exe
exit /b

:error
cls
echo ����%errorreason%
echo �������: %errorlevel%
echo ����%errorreason% >"%temp%\xrofficeerror.log"
echo �������: %errorlevel% >"%temp%\xrofficeerror.log"
goto selfdelete