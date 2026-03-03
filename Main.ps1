$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Set-Location $PSScriptRoot

function Get-FreeSpace {
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
    return [double]$disk.FreeSpace
}

$comp = "$PSScriptRoot\Components"

. "$comp\Localization.ps1"
$msg = Get-Localization

$global:totalFreed = 0.0
$global:logPath = Join-Path $PSScriptRoot "Cleanup_Report.txt"

. "$comp\Questions.ps1"
. "$comp\ErrorHandling.ps1"

$sw = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "`n$($msg.Working)" -ForegroundColor Cyan

if ($global:doLog) { Add-Content $global:logPath -Value "`n--- START: $(Get-Date) ---" }

. "$comp\Cleanup.ps1"

$sw.Stop()
$time = "{0:00}h {1:00}m {2:00}s {3:00}ms" -f $sw.Elapsed.Hours, $sw.Elapsed.Minutes, $sw.Elapsed.Seconds, $sw.Elapsed.Milliseconds

Write-Host "`n========================================"
Write-Host "$($msg.Total): $($global:totalFreed.ToString('N2')) MB" -ForegroundColor Red
Write-Host "$($msg.Duration): $time" -ForegroundColor Yellow
Write-Host "========================================"

if ($global:doLog) {
    Add-Content $global:logPath -Value "--- END: $(Get-Date) ---"
    Add-Content $global:logPath -Value "Duration: $time | Total Freed: $($global:totalFreed.ToString('N2')) MB"
}

[System.Console]::Beep(440, 500)
if ($global:doRest) { Stop-Process -Name explorer -Force; Start-Process explorer.exe }

Write-Host "`n$($msg.Done)"

pause
