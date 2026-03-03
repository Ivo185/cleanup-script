if ((Get-FreeSpace) -lt 500MB) { 
    Write-Host "[!] Warning: Critical low space!" -ForegroundColor Yellow 
}