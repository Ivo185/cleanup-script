Write-Host "`n=== $($msg.Title) ===" -ForegroundColor Cyan
$global:doLog = (Read-Host $msg.LogQ) -match "^[Yy]$"
if ($global:doLog) { $global:logLv = Read-Host $msg.LogLevelQ }
$global:doRest = (Read-Host $msg.RestartQ) -match "^[Yy]$"
$global:doSxS = (Read-Host $msg.WinSxSQ) -match "^[Yy]$"
$global:doSmart = (Read-Host $msg.SmartQ) -match "^[Yy]$"