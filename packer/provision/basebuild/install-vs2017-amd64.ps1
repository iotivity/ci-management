echo "Installing Visual Studio 2017"

echo "Disk usage:"
Get-WmiObject win32_logicaldisk

$install_success_file = "c:\packer\vs-install-success"
$was_installed=$FALSE

Function Uninstall-VisualStudio() {
  echo "to be implemented"
#  Remove-Item $install_success_file
}

Function Install-VisualStudio() {
  # Download and install VS2017
  Write-Output "$(Get-Date) -- Download and install VS2017 --"
  $vsSource="https://aka.ms/vs/15/release/vs_community.exe"
  $vsDest="c:\packer\vs_community.exe"
  c:\ProgramData\chocolatey\bin\curl.exe -k -o $vsDest $vsSource
  Start-Process $vsDest -Wait -ArgumentList '--add Microsoft.VisualStudio.Component.Windows81SDK --add Microsoft.VisualStudio.Component.VC.140 --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop --add Microsoft.VisualStudio.Component.Windows10SDK.15063.UWP --add Microsoft.Component.VC.Runtime.OSSupport --add Microsoft.VisualStudio.Component.VC.CoreIde --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.ComponentGroup.UWP.VC --add Microsoft.VisualStudio.Component.UWP.Support --add Microsoft.Component.NetFX.Native --add Microsoft.Net.Component.4.5.TargetingPack --add Microsoft.Component.MSBuild --add Microsoft.Net.Component.4.7.SDK --add Microsoft.Net.Component.4.7.TargetingPack --add Component.Android.SDK23 --quiet --wait --norestart'

}

if( Test-Path $install_success_file ){
  Remove-Item $install_success_file
  $was_installed=$TRUE

  Uninstall-VisualStudio

  Install-VisualStudio
}else{
  Install-VisualStudio
}

if( $lastExitCode -eq 0 ){
  echo $null >> $install_success_file
  echo "Visual Studio 2017 Installed"
}else{
#  Get-Content C:\Users\vagrant\AppData\Local\Temp\chocolatey\vs.log
#  Get-WinEvent -FilterHashtable @{logname = 'setup'} | Format-Table timecreated, message -AutoSize -Wrap
  echo "Visual Studio 2017 Installation failed"
#  if ($was_installed -ne $TRUE) {
#    exit 0
#  }
}

# TODO: check $PATH for expected utilities
# TODO: check include path for expected headers

