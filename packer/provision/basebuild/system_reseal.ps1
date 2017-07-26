$openssh_root="C:\Program Files\OpenSSH-Win64"
Remove-Item "$openssh_root\ssh_host_*_key"

$sysprep_dir="C:\Windows\System32\Sysprep"

cd $sysprep_dir

& .\sysprep.exe /quiet /generalize /unattend:c:\packer\Unattend.xml
