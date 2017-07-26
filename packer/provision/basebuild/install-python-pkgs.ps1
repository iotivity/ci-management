choco install -y pywin32

$get_pip_sha256='19DAE841A150C86E2A09D475B5EB0602861F2A5B7761EC268049A662DBD2BD0C'

$get_pip_filename="$HOME\Downloads\get-pip.py"
$get_pip_url="https://bootstrap.pypa.io/get-pip.py"

wget -OutFile $get_pip_filename $get_pip_url

if ($get_pip_sha256 -ne (Get-FileHash -Path $get_pip_filename -Algorithm "SHA256").Hash){
  echo "hash mismatch"
  exit 1
}

& python $get_pip_filename

& pip install scons
