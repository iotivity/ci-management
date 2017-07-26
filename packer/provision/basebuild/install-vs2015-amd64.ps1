echo "Installing Visual Studio 2015"

echo "Disk usage:"
Get-WmiObject win32_logicaldisk


#choco install -y VisualStudio2015Professional
#choco install -y visualstudio2015-update

#choco install --execution-timeout 0 -y KB3033929 chocolatey-windowsupdate.extension KB3035131 KB2999226 choco install vcredist2015
#choco install --execution-timeout 0 -y vcredist-all

#choco install --execution-timeout 0 -y vcbuildtools -ia "/Full"
#choco install --execution-timeout 0 -y mingw
#choco install --execution-timeout 0 -y vim
#choco install --execution-timeout 0 -y windows-sdk-7.1
#choco install --execution-timeout 0 -y windows-sdk-8.1
#choco install --execution-timeout 0 -y windows-sdk-10.1

choco install --execution-timeout 0 -y VisualStudio2015Community --packageParameters "/AdminFile c:\packer\AdminDeployment-ws2012-vs2015.xml"

if( $lastExitCode -ne 0 ){
  Get-Content C:\Users\vagrant\AppData\Local\Temp\chocolatey\vs.log
  Get-WinEvent -FilterHashtable @{logname = 'setup'} | Format-Table timecreated, message -AutoSize -Wrap
  echo "Visual Studio 2015 Installation failed"
  exit 0
}else{
  echo "Visual Studio 2015 Installed"
}

# TODO: check $PATH for expected utilities

