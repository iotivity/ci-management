$vs_installer="en_visual_studio_professional_2015_with_update_3_x86_x64_web_installer_8922978.exe"
$vs_adminfile="AdminDeployment.xml"


c:\util\curl.exe -o $vs_installer https://my.visualstudio.com/Downloads?pid=2088
c:\util\curl.exe -o $vs_adminfile 

$vs_installer /adminfile $vs_adminfile /norestart
#$vs_installer /Passive /LOG %SYSTEMROOT%\TEMP\VS_2015_U3.log /NoWeb /NoRefresh /Full



