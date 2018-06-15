$get_pip_sha256='EF0D74EDCACF495C24D2BB2FA5E7AE6F23ABC6FF0171180D9D868596057F44F8'

$get_pip_filename="C:\packer\get-pip.py"
$get_pip_url="https://bootstrap.pypa.io/get-pip.py"

c:\ProgramData\chocolatey\bin\curl.exe -k -o $get_pip_filename $get_pip_url

$received_hash=(Get-FileHash -Path $get_pip_filename -Algorithm "SHA256").Hash
if ($get_pip_sha256 -ne $received_hash){
  echo "hash mismatch"
  echo "$get_pip_sha256 expected"
  echo "$received_hash received"
  exit 1
}else{
  echo "hashes match"
}

& python $get_pip_filename
echo "pip installed"

& pip install pypiwin32
echo "pypiwin32 istalled"

& pip install 'scons==2.5.1'
#& pip install scons
echo "scons istalled"

