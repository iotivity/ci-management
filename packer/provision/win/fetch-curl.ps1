Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipfile="curl_754_0_ssl.zip"
mkdir -Force "C:\util"
wget http://www.paehl.com/open_source/?download=$zipfile -OutFile "$PWD\$zipfile"
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\$zipfile", "C:\util")

rm "$PWD\$zipfile"
