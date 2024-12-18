#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-coreutils-ish"; RequiredVersion = "0.7.0" }


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
