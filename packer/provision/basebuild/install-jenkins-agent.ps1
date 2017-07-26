Set-ExecutionPolicy Unrestricted

# C:\\packer\\install-jenkins-agent.ps1 'https://jenkins.iotivity.org/sandbox/' "{{user `hostname`}}"

#$jenkinsServerUrl = $args[0]
#$vmName = "windows-server0"
$vmName = $args[0]

$jenkinsServerUrl = 'https://jenkins.iotivity.org/sandbox/'

$secret = $args[1]

$jenkinsSlaveJarUrl = $jenkinsServerUrl + "jnlpJars/slave.jar"
$jnlpUrl=$jenkinsServerUrl + 'computer/' + $vmName + '/slave-agent.jnlp'

$baseDir = 'c:\j'

$javaExe = "C:\Program Files\Java\jdk1.8.0_144\bin\java.exe"

# Launching jenkins slave agent
$process = New-Object System.Diagnostics.Process;
$process.StartInfo.FileName = $javaExe;
If($secret)
{
    $process.StartInfo.Arguments = "-jar $destinationSlaveJarPath -secret $secret -jnlpUrl $jnlpUrl"
}
else
{
    $process.StartInfo.Arguments = "-jar $destinationSlaveJarPath -jnlpUrl $jnlpUrl"
}
$process.StartInfo.RedirectStandardError = $true;
$process.StartInfo.RedirectStandardOutput = $true;
$process.StartInfo.UseShellExecute = $false;
$process.StartInfo.CreateNoWindow = $true;

$newPath = $env:Path + ';' + $GITPath
$process.StartInfo.EnvironmentVariables.Item('Path') = $newPath


$process.StartInfo;
$process.Start();

Write-Host 'Done Init Script.';