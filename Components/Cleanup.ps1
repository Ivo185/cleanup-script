function Clean-Target {
    param([string]$Path, [string]$Name)
    $before = Get-FreeSpace
    Write-Host ($msg.Checking -f $Name) -NoNewline
    
    if (Test-Path $Path) {
        $items = Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue
        foreach ($i in $items) {
            if ($global:doLog -and $global:logLv -eq "2") {
                Add-Content $global:logPath -Value "DEL: $($i.FullName)"
            }
            Remove-Item $i.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    $after = Get-FreeSpace
    $freedThisFolder = [math]::Max(0, ($after - $before) / 1MB)
    $global:totalFreed += $freedThisFolder
    
    if ($global:doLog) {
        $logMsg = $msg.LogFolder -f $Name, $freedThisFolder.ToString("N2")
        Add-Content $global:logPath -Value $logMsg
    }
    Write-Host $msg.OK -ForegroundColor Green
}

# ТОЧКА ЗА ВЪЗСТАНОВЯВАНЕ
Write-Progress -Activity "System" -Status "Creating Restore Point" -PercentComplete 10
Checkpoint-Computer -Description "PC_Optimizer_Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue

# ИЗПЪЛНЕНИЕ
Clean-Target -Path $env:TEMP -Name $msg.UserTemp
Clean-Target -Path "C:\Windows\Temp" -Name $msg.WinTemp
Clean-Target -Path "C:\Windows\Prefetch" -Name $msg.Prefetch

# Кошче
Write-Host ($msg.Checking -f $msg.Bin) -NoNewline
$bBin = Get-FreeSpace
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
$freedBin = [math]::Max(0, (Get-FreeSpace) - $bBin) / 1MB
$global:totalFreed += $freedBin
Write-Host $msg.OK -ForegroundColor Green

if ($global:doLog) {
    $logMsg = $msg.LogFolder -f $msg.Bin, $freedBin.ToString("N2")
    Add-Content $global:logPath -Value $logMsg
}

# WinSxS
if ($global:doSxS) {
    Write-Progress -Activity "Cleanup" -Status "Optimizing WinSxS" -PercentComplete 80
    DISM.exe /online /Cleanup-Image /StartComponentCleanup /Quiet
}

# SMART SCANNER
if ($global:doSmart) {
    $smartTotalFreed = 0.0 
    $whitelist = @("Microsoft","Windows","Common Files","NVIDIA","Intel","AMD","Google","Steam","Epic Games","Windows Defender","Windows Defender Advanced Threat Protection","Windows Mail","Windows Media Player","Windows NT","WindowsPowerShell","Windows Photo Viewer","WindowsApps","Internet Explorer","Microsoft.NET","Dolby","Package Cache","Microsoft DevDiv","K7F0O","ssh","USOPrivate","USOShared","Whesvc",".IdentityService","Backup","Packages","pip","Programs","speech","ConnectedDevicesPlatform","CEF","Microsoft_Corporation","Microsoft Office 15","ModifiableWindowsApps","Lenovo","D3DSCache","PackageManagement","Temp")
    $apps = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object -ExpandProperty DisplayName -ErrorAction SilentlyContinue
    $paths = @("C:\Program Files", "C:\Program Files (x86)", "C:\ProgramData", "$env:AppData")
    
    foreach ($p in $paths) {
        if (Test-Path $p) {
            Get-ChildItem $p -Directory | ForEach-Object {
                $f = $_
                if ($whitelist -contains $f.Name) { return }
                $match = $apps | Where-Object { $_ -like "*$($f.Name)*" }
                if (-not $match) {
                    Write-Host "`n[?] $($msg.Found) $($f.FullName)" -ForegroundColor Cyan
                    if ((Read-Host $msg.Prompt) -match "^[Yy]$") {
                        $b = Get-FreeSpace
                        Remove-Item $f.FullName -Recurse -Force -ErrorAction SilentlyContinue
                        $freed = [math]::Max(0, ((Get-FreeSpace) - $b) / 1MB)
                        $global:totalFreed += $freed
                        $smartTotalFreed += $freed
                        if ($global:doLog) { Add-Content $global:logPath -Value "SMART SCAN DELETE: $($f.FullName) [$($freed.ToString('N2')) MB]" }
                    }
                }
            }
        }
    }
    if ($global:doLog -and $smartTotalFreed -gt 0) {
        $logMsg = $msg.LogSmartTotal -f $smartTotalFreed.ToString("N2")
        Add-Content $global:logPath -Value $logMsg
    }
}