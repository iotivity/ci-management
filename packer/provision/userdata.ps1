# User Data
rem cmd

@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"

net user Administrator W!nRMB00tStrap.
wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE

# Turning off User Account Control (UAC)
# see http://www.howtogeek.com/howto/windows-vista/enable-or-disable-uac-from-the-windows-vista-command-line/
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

# Setting the PowerShell ExecutionPolicy to RemoteSigned (64 bit)
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force" <NUL

# Setting the PowerShell ExecutionPolicy to RemoteSigned (32 bit)
if exist %SystemRoot%\SysWOW64\cmd.exe (
  %SystemRoot%\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force" <NUL
)

wmic os get Caption | findstr /c:"Windows 7" /c:"Windows 10" >nul
if errorlevel 1 goto skip_fixnetwork

if not exist %~dp0fixnetwork.ps1 echo ==^> ERROR: File not found: %~dp0fixnetwork.ps1

# Setting the Network Location to private
# see http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx
powershell -File %~dp0fixnetwork.ps1 <NUL

:skip_fixnetwork

# Changing remote UAC account policy
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

# Blocking WinRM port 5985 on the firewall
netsh advfirewall firewall add rule name="winrm"  dir=in action=block protocol=TCP localport=5985

# Configuring Windows Remote Management (WinRM) service

call winrm quickconfig -q
call winrm quickconfig -transport:http
call winrm set winrm/config @{MaxTimeoutms="1800000"}
call winrm set winrm/config/winrs @{MaxMemoryPerShellMB="800"}
call winrm set winrm/config/service @{AllowUnencrypted="true"}
call winrm set winrm/config/service/auth @{Basic="true"}
call winrm set winrm/config/client/auth @{Basic="true"}
call winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}
sc config winrm start= disabled

# wait for winrm service to finish starting
timeout 5

sc query winrm | findstr "RUNNING" >nul
if errorlevel 1 goto winrm_not_running

# Stopping winrm service

sc stop winrm

:is_winrm_running

timeout 1

sc query winrm | findstr "STOPPED" >nul
if errorlevel 1 goto is_winrm_running

:winrm_not_running

# Unblocking WinRM port 5985 on the firewall
netsh advfirewall firewall delete rule name="winrm"
netsh advfirewall firewall set rule group="remote administration" new enable=yes

# Opening WinRM port 5985 on the firewall
# see http://social.technet.microsoft.com/Forums/windowsserver/en-US/a1e65f0f-2550-49ae-aee2-56a9bdcfb8fb/windows-7-remote-administration-firewall-group?forum=winserverManagement
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
netsh advfirewall firewall add rule name="winrm"  dir=in action=allow protocol=TCP localport=5985

:exit0

ver>nul

goto :exit

:exit1

verify other 2>nul

:exit
