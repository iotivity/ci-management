#ps1_sysnative
Set-ExecutionPolicy Unrestricted

$baseDir = 'c:\j'
$destinationSlaveJarPath = "$baseDir\e\slave.jar"
$logfile="$baseDir\jenkins.log"
$errlog="$baseDir\jenkins-err.log"
$jenkinsServerUrl=${JENKINS_URL}
$jenkinsSlaveJarUrl=${SLAVE_JAR_URL}
$jnlpUrl=${SLAVE_JNLP_URL}
$svc_name="jenkins-slave"
$javaExe="C:\Program Files\Java\jdk1.8.0_144\bin\java.exe"
$srcScriptPath=$MyInvocation.ScriptName
$scriptPath="$baseDir\install-jenkins-agent.ps1"
$jenkinsSlaveJarUrl=$jenkinsSlaveJarUrl -replace 'https', 'http'

Copy-Item $srcScriptPath $scriptPath

cd $baseDir

$secret=perl.exe c:\packer\fetch_jnlp_secret.pl $jenkinsServerUrl $jenkinsSlaveJarUrl $jnlpUrl "username_here" "api_token_here"

#& curl.exe -o $destinationSlaveJarPath $jenkinsSlaveJarUrl
#wget $jenkinsSlaveJarUrl -OutFile $destinationSlaveJarPath

$content = 'powershell.exe -ExecutionPolicy Unrestricted -file' + ' '+ $scriptPath
$commandFile = $baseDir + '\slaveagenttask.cmd'
$content | Out-File $commandFile -Encoding ASCII -Append
schtasks /create /tn "Jenkins slave agent" /ru "SYSTEM" /sc onstart /rl HIGHEST /delay 0000:30 /tr $commandFile /f

& nssm.exe install $svc_name $javaExe
& nssm.exe set $svc_name AppParameters -jar $destinationSlaveJarPath -jnlpUrl $jnlpUrl -secret $secret
& nssm.exe set $svc_name AppDirectory $baseDir
& nssm.exe set $svc_name AppStdout    $logfile
& nssm.exe set $svc_name AppStderr    $errlog
& nssm.exe set $svc_name AppStopMethodSkip 6
& nssm.exe set $svc_name AppStopMethodConsole 1000
& nssm.exe set $svc_name AppThrottle 5000
& nssm.exe start $svc_name

Write-Host 'Done installing jenkins slave service.'
