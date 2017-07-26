$get_pip_sha256='19DAE841A150C86E2A09D475B5EB0602861F2A5B7761EC268049A662DBD2BD0C'
#$get_pip_sha256='E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855'

$get_pip_filename="$HOME\Downloads\get-pip.py"
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

& pip install 'scons==2.5.1'
echo "scons istalled"

& pip install pypiwin32
echo "pypiwin32 istalled"
