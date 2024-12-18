#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


. "$PSScriptRoot/add_ssh.ps1"
Export-ModuleMember -Function add_ssh

. "$PSScriptRoot/ssh-add-all.ps1"
Export-ModuleMember -Function ssh-add-all

. "$PSScriptRoot/sshlist.ps1"
Export-ModuleMember -Function sshlist
