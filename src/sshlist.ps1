#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


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
