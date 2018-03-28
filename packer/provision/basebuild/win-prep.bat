net accounts /maxpwage:unlimited::
enable RDP:http://technet.microsoft.com/en-us/library/cc782195(v=ws.10).aspx
%SystemRoot%\System32\reg.exe ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
<!-- :
@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

echo ==^> Enabling updates for other products from Microsoft Update
net stop wuauserv

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v EnableFeaturedSoftware /t REG_DWORD /d 1 /f

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v IncludeRecommendedUpdates /t REG_DWORD /d 1 /f

cscript //nologo "%~f0?.wsf"

net start wuauserv
exit /b

----- Begin wsf script --->
<job><script language="VBScript">
  Set ServiceManager = CreateObject("Microsoft.Update.ServiceManager")
  Set NewUpdateService = ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

  Const NOT_CONFIGURED = 0
  Const DISABLED = 1
  Const PROMPT_TO_APPROVE_BEFORE_DOWNLOAD = 2
  Const DOWNLOAD_AUTOMATICALLY = 3
  Const SCHEDULED_INSTALLATION = 4
  Set AutoUpdate = CreateObject("Microsoft.Update.AutoUpdate")
  Set AutoUpdateSettings = AutoUpdate.Settings
  AutoUpdateSettings.NotificationLevel = DISABLED
  AutoUpdateSettings.Save
  AutoUpdateSettings.Refresh
</script></job>

@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Disabling UAC. Please wait...

echo ==^> Disabling UAC
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v EnableLUA /t REG_DWORD /d 0
echo Reboot required to make this change effective.

:exit0

ver>nul
goto :exit

:exit1
verify other 2>nul

%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f
netsh advfirewall firewall add rule name="All ICMP V4" dir=in action=allow protocol=icmpv4
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

:exit
