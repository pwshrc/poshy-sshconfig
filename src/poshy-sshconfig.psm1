#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-coreutils-ish"; RequiredVersion = "0.7.0" }
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Add entry to ssh config.
.COMPONENT
    ssh
#>
function add_ssh {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $sshhost,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $hostname,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $user
    )
    if (-not (Test-Path ~/.ssh -ErrorAction SilentlyContinue)) {
        New-Item -Path ~/.ssh -ItemType Directory | Out-Null
        if (-not $IsWindows) {
            Set-ItemNixMode -Path ~/.ssh -OctalMode 700
        }

    }
    if (-not (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue)) {
        New-Item -Path ~/.ssh/config -ItemType File | Out-Null
        if (-not $IsWindows) {
            Set-ItemNixMode -Path ~/.ssh/config -OctalMode 600
        }
    }
"

Host $sshhost
  HostName $hostname
  User $user
  ServerAliveInterval 30
  ServerAliveCountMax 120
" | Out-File -Append -FilePath ~/.ssh/config
}

<#
.SYNOPSIS
    List hosts defined in ssh config.
.COMPONENT
    ssh
#>
function sshlist {
    if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
        Get-Content ~/.ssh/config | ForEach-Object {
            if ($_ -match "^Host\s+(.+)$") {
                $matches[1]
            }
        }
    }
}

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

Export-ModuleMember -Function *
