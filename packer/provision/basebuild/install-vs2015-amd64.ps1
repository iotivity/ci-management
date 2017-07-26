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

$install_success_file = "c:\packer\vs-install-success"
$was_installed=False

Function Uninstall-VisualStudio() {
  echo "to be implemented"
}

Function Install-VisualStudio() {
  # Download and install VS2017
  Write-Output "$(Get-Date) -- Download and install VS2015 --"
#  $vsSource="https://aka.ms/vs/15/release/vs_community.exe"
  $vsSource="https://download.microsoft.com/download/0/B/C/0BC321A4-013F-479C-84E6-4A2F90B11269/vs_community.exe"
  $vsDest="d:\packer\vs_community.exe"
#     mkdir d:\vs | Out-Null
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($vsSource, $vsDest)
#  Start-Process $vsDest -Wait -ArgumentList '--add Microsoft.VisualStudio.Component.Windows81SDK --add Microsoft.VisualStudio.Component.VC.140 --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop --add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP --add Microsoft.Component.VC.Runtime.OSSupport --add Microsoft.VisualStudio.Component.VC.CoreIde --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.ComponentGroup.UWP.VC --add Microsoft.VisualStudio.Component.UWP.Support --add Microsoft.Component.NetFX.Native --add Microsoft.Net.Component.4.5.TargetingPack --add Microsoft.Component.MSBuild --add Microsoft.Net.Component.4.7.SDK --add Microsoft.Net.Component.4.7.TargetingPack --add Component.Android.SDK23 --quiet --wait --norestart'
  Start-Process $vsDest /AdminFile c:\packer\AdminDeployment-ws2012-vs2015.xml

}

if( Test-Path $install_success_file ){
  Remove-Item $install_success_file
  $was_installed=True

  Uninstall-VisualStudio

  Install-VisualStudio
}else{
  Install-VisualStudio
}

if( $lastExitCode -eq 0 ){
  echo $null >> $install_success_file
  echo "Visual Studio 2015 Installed"
}else{
#  Get-Content C:\Users\vagrant\AppData\Local\Temp\chocolatey\vs.log
#  Get-WinEvent -FilterHashtable @{logname = 'setup'} | Format-Table timecreated, message -AutoSize -Wrap
  echo "Visual Studio 2015 Installation failed"
  if ($was_installed -ne True) {
    exit 0
  }
}

# TODO: check $PATH for expected utilities
# TODO: check include path for expected headers

