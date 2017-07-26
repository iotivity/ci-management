Set-ExecutionPolicy Unrestricted

# C:\\packer\\install-jenkins-agent.ps1 "{{user `hostname`}}"

#$jenkinsServerUrl = $args[0]
#$vmName = "windows-server0"
$vmName = $args[0]

$jenkinsServerUrl = 'https://jenkins.iotivity.org/sandbox/'

$secret = $args[1]

$baseDir = 'c:\j'

$jenkinsSlaveJarUrl = $jenkinsServerUrl + "jnlpJars/slave.jar"
$destinationSlaveJarPath = $baseDir + '\slave.jar'

If(-not((Test-Path $destinationSlaveJarPath)))
{
  c:\ProgramData\chocolatey\bin\curl.exe -o $destinationSlaveJarPath $jenkinsSlaveJarUrl
}


$jnlpUrl=$jenkinsServerUrl + 'computer/' + $vmName + '/slave-agent.jnlp'

# Function to get path of script file
function Get-ScriptPath
{
    return $MyInvocation.ScriptName;
}

# Checking if this is first time script is getting executed, if yes then download slave jar
If(-not((Test-Path $destinationSlaveJarPath)))
{
  "& git config --system core.autocrlf false"
  "& git config --system core.longpaths true"

   md -Path $baseDir -Force

   $wc = New-Object System.Net.WebClient

   $wc.DownloadFile($jenkinsSlaveJarUrl, $destinationSlaveJarPath)

   $scriptPath = Get-ScriptPath
#   $content = 'powershell.exe -ExecutionPolicy Unrestricted -file' + ' '+ $scriptPath + ' '+ $jenkinsServerUrl + ' ' + $vmName + ' ' + $secret
   $content = 'powershell.exe -ExecutionPolicy Unrestricted -file' + ' '+ $scriptPath + ' ' + $vmName + ' ' + $secret
   $commandFile = $baseDir + '\slaveagenttask.cmd'
   $content | Out-File $commandFile -Encoding ASCII -Append
   schtasks /create /tn "Jenkins slave agent" /ru "SYSTEM" /sc onstart /rl HIGHEST /delay 0000:30 /tr $commandFile /f
}

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

$process.StartInfo;
$process.Start();

Write-Host 'Done Init Script.';