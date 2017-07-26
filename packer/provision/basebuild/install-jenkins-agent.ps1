#ps1_sysnative
Set-ExecutionPolicy Unrestricted

$baseDir = 'c:\j'



$jenkinsServerUrl = ${JENKINS_URL}
$jenkinsSlaveJarUrl = ${SLAVE_JAR_URL}
#$jenkinsSlaveJarUrl = $jenkinsServerUrl + "jnlpJars/slave.jar"
$jnlpUrl=${SLAVE_JNLP_URL}

cd $baseDir

$secret=perl.exe c:\packer\fetch_jnlp_secret.pl $jenkinsServerUrl $jenkinsSlaveJarUrl $jnlpUrl "username_here" "api_token_here"

$destinationSlaveJarPath = $baseDir + '\slave.jar'

If(-not((Test-Path $destinationSlaveJarPath)))
{
  c:\ProgramData\chocolatey\bin\curl.exe -o $destinationSlaveJarPath $jenkinsSlaveJarUrl
}

# Function to get path of script file
function Get-ScriptPath
{
    return $MyInvocation.ScriptName;
}

$javaExe = "C:\Program Files\Java\jdk1.8.0_144\bin\java.exe"

$nssm="C:\ProgramData\chocolatey\lib\NSSM\Tools\nssm-2.24\win64\nssm.exe"
$svc_name="jenkins-slave"

Set-ExecutionPolicy Unrestricted

$baseDir = 'c:\j'
$destinationSlaveJarPath = $baseDir + '\slave.jar'


If(-not((Test-Path $destinationSlaveJarPath)))
{
  c:\ProgramData\chocolatey\bin\curl.exe -o $destinationSlaveJarPath $jenkinsSlaveJarUrl
}

$logfile="$baseDir\jenkins.log"

& $nssm install $svc_name $javaExe
& $nssm set $svc_name AppParameters -jar $destinationSlaveJarPath -jnlpUrl $jnlpUrl -secret $secret
& $nssm set $svc_name AppDirectory $baseDir
& $nssm set $svc_name AppStdout    $logfile
& $nssm set $svc_name
& $nssm start $svc_name

Write-Host 'Done installing jenkins slave service.';


