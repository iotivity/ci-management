Import-Module PSWindowsUpdate

Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -WhatIf -Verbose
Invoke-WUInstall -OnlineUpdate -verbose -Confirm:false