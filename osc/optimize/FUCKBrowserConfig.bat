@echo off
chcp 936 > nul
set ver=FUCK Browser Config by Xiaoran Studio V2.15 (Build 2025.4.19)
title %ver%
mode con:cols=64
@rem  lines=25
color 1f

:silentset
rem ���������������������������޸ĵ���ҳ��������������������
set homepage=http://www.baidu.com
rem ���������������������������޸ĵ���ҳ��������������������
rem ����������������������װ/��Ĭ��ȥ��ע�͡�������������������
rem set slientmode=true
rem ����������������������װ/��Ĭ��ȥ��ע�͡�������������������
rem ��������������������PE��������Ԥ�������̷���������������������
rem set SystemDrive=C:
rem ��������������������PE��������Ԥ�������̷���������������������
rem ����ֱ��ͨ��/S������Ĭ���У�
if /i "%1"=="/s" (
    set slientmode=true
)

:main
if "%slientmode%"=="true" (
    set mode=2
    goto run
)

cls
echo.
echo %ver%
echo.
echo ע�⣺
echo 1.�˽ű��ļ���ɾ������������ĵ������ļ��������ղؼУ�, 
echo   �Դﵽ������å��ǩ�����ƹ��Ч����
echo 2.Ŀǰ֧�������������������á�ע���IE�ղص���å�ƹ㡣
echo 3.��ȷ�����Ѿ����ղؼе���Ϊhtml�ļ����Ա�֮��ָ��ղؼС�
echo 4.�����û��ִ�й��������ݲ��������д˽ű����㽫�ᶪʧ���ݡ�
echo 5.����ȫ�˳���ȫ�����������360��2345�������������ؽ��̣�
echo   ж��2345��ȫ�����������ɸ��š�
echo 6.���農Ĭ���ã��������޸Ĵ˽ű��ļ���
echo.
echo ����ģʽ��
echo 1.��ȫģʽ����ɾ�������������Ŀ¼�������ƻ�������ı������, 
echo   �������Ѿ���װ��������󱻴۸ĵ������
echo 2.����ģʽ(�Ƽ�)��������������йص�Ŀ¼��ע��������
echo   ����ǿ��ж���������������ԭ����û�а�װ������������
echo     ǿ��֢������
if "%pemode%"=="" echo 3.PEģʽ���ֶ�����ϵͳ�̷���������ϵͳ�̷�����Ĭ�ϱ��������
echo   ��ǰϵͳ�̷�Ϊ��%SystemDrive%
echo.
echo.
echo ����������ģʽ����ţ������س���ȷ�ϣ�
set /p mode=
goto run

:peset
cls
echo.
echo ������ϵͳ�̷��������س���ȷ�ϣ������磺C:��
set /p SystemDrive=
set pemode=1
set mode=2
goto run

:run
mode con:cols=64
cls
if "%mode%"=="1" (
    set clean="115chrome\User Data","360Chrome\Chrome\User Data","360Chrome\User Data","360ChromeX\Chrome\User Data","360ChromeX\User Data","360se6\User Data",360se5,360se,2345chrome,2345Explorer,"Apple Computer",Baidu\BaiduBrowser,DCBrowser,"Microsoft\Edge\User Data",hao123JuziBrowser,JuziBrowser,"Google\Chrome\User Data","Google\Chrome Dev\User Data","Google\Chrome SxS\User Data","Chrome\User Data","Google Chrome",liebao,liebao7,TaoBrowser,"Tencent\QQBrowser","TheWorld7\User Data","TheWorld6\User Data",UCBrowser,YYExplorer,Maxthon6,Maxthon5,Maxthon4,Maxthon3,Maxthon,Mozilla,"Opera Software",Shouxin,"SogouExplorer\User Data","Sogou\SogouExplorer\User Data","CentBrowser\User Data","User Data",secoresdk,"IQIYI Video","Qingniao Chrome\User Data","TSBrowser\User Data","ChromeCore\User Data",CEF,"BaiBeiBrowser\User Data","Chromium\User Data","Chromium\GbrowserData","Huawei\HuaweiBrowser\User Data","Lenovo\SLBrowser\User Data","Twinkstar\User Data","xbbrowser\User Data","���������\User Data","360gt\User Data"
    set "cleans=rd /s /q %clean%"
    set kill=false
    set bm=true
    set reg=false
    set hp=false
    goto delete
)
if "%mode%"=="2" (
    set clean=115chrome,360Chrome,360ChromeX,360se6,360se5,360se,2345chrome,2345Explorer,"Apple Computer",Baidu,DCBrowser,Microsoft\Edge,hao123JuziBrowser,JuziBrowser,google,"Google Chrome",Chrome,liebao,liebao7,TaoBrowser,"Tencent\QQBrowser",TheWorld7,TheWorld6,UCBrowser,YYExplorer,Maxthon6,Maxthon5,Maxthon4,Maxthon3,Maxthon,Mozilla,"Opera Software",Shouxin,SogouExplorer,Sogou,CentBrowser,"User Data",secoresdk,"IQIYI Video","Qingniao Chrome",TSBrowser,ChromeCore,CEF,"BaiBeiBrowser","Chromium","Huawei\HuaweiBrowser","Lenovo\SLBrowser","Twinkstar","xbbrowser","���������","360gt"
    set "cleans=rd /s /q %clean%"
    set kill=true
    set bm=true
    set reg=true
    set hp=true
    goto delete
)
if "%mode%"=="3" goto peset
if "%mode%"=="" exit

:delete
if "%pemode%"=="1" goto bm

:kill
if "%kill%"=="true" (
    TASKKILL /IM 360se.exe /F
    TASKKILL /IM 360cse.exe /F
    TASKKILL /IM 360Chrome.exe /F
    TASKKILL /IM 360ChromeX.exe /F
    TASKKILL /IM 360bdoctor.exe /F
    TASKKILL /IM sesvc.exe /F
    TASKKILL /IM 2345Explorer.exe /F
    TASKKILL /IM 2345SafeCenterSvc.exe /F
    TASKKILL /IM 2345SafeSvc.exe /F
    TASKKILL /IM msedge.exe /F
    TASKKILL /IM edge.exe /F
    TASKKILL /IM chrome.exe /F
    TASKKILL /IM QQBrowser.exe /F
    TASKKILL /IM QQBrowserFix.exe /F
    TASKKILL /IM QQBrowserLiveup.exe /F
    TASKKILL /IM DelayUpdate.exe /F
    TASKKILL /IM SougouExplorer.exe /F
    TASKKILL /IM DCBrowser.exe /F
    TASKKILL /IM DCBrowserSvr.exe /F
    TASKKILL /IM firefox.exe /F
    TASKKILL /IM iexplore.exe /F
)

:bm
if "%bm%"=="true" (
    echo Win7+ϵͳ����
    for %%i in ("%USERPROFILE%\AppData\Local" "%USERPROFILE%\AppData\Roaming" "%LOCALAPPDATA%" "%APPDATA%" "%SystemDrive%\Users\Default\AppData\Local" "%SystemDrive%\Users\Default\AppData\Roaming" "%SystemDrive%\Users\Administrator\AppData\Local" "%SystemDrive%\Users\Administrator\AppData\Roaming") do (
        cd /d "%%~i"
        for %%a in (%clean%) do (
            if exist "%%~a" (
                echo ��������%%~a
                attrib -S -H "%%~a" /S /D
                rd /s /q "%%~a"
            )
        )
        for %%b in (360,Huawei,Lenovo,Tencent,Google,Sogou) do (dir /a /b %%b 2>nul|findstr .* >nul||rd /s /q %%b)
    )
    echo ����IE������ղ�
    rd /s /q "%SystemDrive%\Users\Administrator\Favorites"
    rd /s /q "%SystemDrive%\Users\Public\Favorites"
    rd /s /q "%SystemDrive%\Users\Default\Favorites"
    rd /s /q "%USERPROFILE%\Favorites"
    rd /s /q "D:\Backup\Favorites"
    echo WinXPϵͳ����
    for %%i in ("%SystemDrive%\Documents and Settings\Administrator\Local Settings\Application Data" "%SystemDrive%\Documents and Settings\Administrator\Application Data" "%SystemDrive%\Documents and Settings\All Users\Local Settings\Application Data" "%SystemDrive%\Documents and Settings\All Users\Application Data" "%ALLUSERSPROFILE%\Local Settings\Application Data" "%ALLUSERSPROFILE%\Application Data" "%USERPROFILE%\Local Settings\Application Data" "%USERPROFILE%\Application Data" "%SystemDrive%\Documents and Settings\Default User\Local Settings\Application Data" "%SystemDrive%\Documents and Settings\Default User\Application Data") do (
        cd /d "%%~i"
        for %%a in (%clean%) do (
            if exist "%%~a" (
                echo ��������%%~a
                attrib -S -H "%%~a" /S /D
                rd /s /q "%%~a"
            )
        )
    )
)

:reg
echo ɾ���Ҽ��˵��ٶ�����
REG DELETE "HKEY_CLASSES_ROOT\Directory\Background\shell\{E82A1BA7-3493-47e1-A673-9277E8695AFA}" /f
del /f /q "%SystemDrive%\Windows\Web\ico\b.ico"
echo ɾ��Edge�������֯����
REG DELETE HKCU\Software\Policies\Microsoft\Edge /f
REG DELETE HKLM\Software\Policies\Microsoft\Edge /f
REG DELETE HKCU\Software\Policies\Microsoft\EdgeUpdate /f
REG DELETE HKLM\Software\Policies\Microsoft\EdgeUpdate /f
for %%a in ("%SystemDrive%\Program Files","%SystemDrive%\Program Files (x86)") do (
    del /f /q "%%~a\Microsoft\Edge\Application\*preferences"
    del /f /q "%%~a\Microsoft\Edge Beta\Application\*preferences"
    del /f /q "%%~a\Microsoft\Edge Dev\Application\*preferences"
    del /f /q "%%~a\Google\Chrome\Application\*preferences"
    del /f /q "%%~a\Google\Chrome Dev\Application\*preferences"
)

if "%reg%"=="true" (
    echo ϵͳ�ƹ�ȸ������
    rd /s /q "%LOCALAPPDATA%\Google\Chromebin"
    rd /s /q "%LOCALAPPDATA%\Google Chrome\Chromebin"
    del /f /q "%USERPROFILE%\Desktop\�ȸ������.lnk"
    del /f /q "%PUBLIC%\Desktop\�ȸ������.lnk"
    if exist "%SystemDrive%\Program Files\Google Chrome\Chrome\App\version.dll" (
        rd /s /q "%SystemDrive%\Program Files\Google Chrome"
        del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"
        del /f /q "%PUBLIC%\Desktop\Google Chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\Google Chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Google Chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\chrome.lnk"
    )
    echo ����ע���
    REG DELETE HKCU\Software\2345.com /f
    REG DELETE HKCU\Software\2345Explorer /f
    REG DELETE HKCU\Software\360 /f
    REG DELETE HKCU\Software\360Chrome /f
    REG DELETE HKCU\Software\360ChromeX /f
    REG DELETE HKCU\Software\360se5 /f
    REG DELETE HKCU\Software\360se6 /f
    REG DELETE HKCU\Software\2345Explorer /f
    REG DELETE HKCU\Software\Chromium /f
    REG DELETE HKCU\Software\Google\Chrome /f
    REG DELETE HKCU\Software\Mozilla /f
    REG DELETE HKCU\Software\Netscape /f
    REG DELETE HKCU\Software\Tencent\QQBrowser /f
    REG DELETE HKCU\Software\Microsoft\Edge /f
    REG DELETE HKCU\Software\PPStream /f
    REG DELETE HKLM\SOFTWARE\2345Explorer /f
    REG DELETE HKLM\SOFTWARE\HaoZip /f
    REG DELETE HKLM\SOFTWARE\Google\Chrome /f
    REG DELETE HKLM\SOFTWARE\Tencent\QQBrowser /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\EUPP\DSP" /v "BackupDefaultSearchScope" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\SearchScopes" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\EUPP\DSP" /v "BackupDefaultSearchScope" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Start Page" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Search" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\EUPP\DSP" /v "BackupDefaultSearchScope" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\SearchScopes" /f
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\360ChromeX" /f
    REG DELETE "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\360Chrome" /f
)

:hp
if "%hp%"=="true" (
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /d "%homepage%" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /d "%homepage%" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /d "%homepage%" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /d "%homepage%" /f
)

:exit
echo ������ɣ�����Ϊ����ִ�е���־��
if "%slientmode%"=="true" (
    exit
)
pause
exit