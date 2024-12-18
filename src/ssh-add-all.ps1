#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Add all ssh private keys to agent.
.COMPONENT
    ssh
#>
function ssh-add-all {
    if (Test-Command ssh-add) {
        [string[]] $privateKeys = Get-Content ~/.ssh/config | ForEach-Object {
            if ($_ -match "PRIVATE") {
                $matches[1]
            }
        }
        foreach ($privateKey in $privateKeys) {
            ssh-add $privateKey
        }
    }
}
