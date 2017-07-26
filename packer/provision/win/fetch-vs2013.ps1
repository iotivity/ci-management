$vs_installer="wdexpress_full.exe"
$vs_adminfile="AdminDeployment.xml"

c:\util\curl.exe -o $vs_installer http://100.64.79.1/downloads/msdn/vs2013/$vs_installer
c:\util\curl.exe -o $vs_adminfile http://100.64.79.1/downloads/msdn/vs2013/$vs_adminfile

$vs_installer /adminfile $vs_adminfile /norestart
vs_professional.exe /Passive /LOG %SYSTEMROOT%\TEMP\VS_2013_U3.log /NoWeb /NoRefresh /Full /ProductKey XXXX-XXXX-XXXX-XXX



