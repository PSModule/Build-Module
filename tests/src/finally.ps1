﻿Write-Verbose '------------------------------' -Verbose
Write-Verbose '---  THIS IS A LAST LOADER ---' -Verbose
Write-Verbose '------------------------------' -Verbose
Write-Verbose ($MyInvocation | ConvertTo-Json | Out-String) -Verbose
Write-Verbose ($PSCmdlet | ConvertTo-Json | Out-String) -Verbose
Write-Verbose ($StackTrace | ConvertTo-Json | Out-String) -Verbose
