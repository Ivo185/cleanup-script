function Get-Localization {
    Clear-Host
    Write-Host "1. Български (Bulgarian)"
    Write-Host "2. English"
    Write-Host "0. Изход (Exit)"
    $choice = Read-Host "Избор / Choice"
    
    if ($choice -eq "0") { exit }
    
    $lang = @{}
    if ($choice -eq "1") {
        $lang.Title = "ПАРАМЕТРИ ЗА ПОЧИСТВАНЕ"
        $lang.LogQ = "1. Искате ли да се създава log файл? (Y/N)"
        $lang.LogLevelQ = "   - Ниво на детайлност: [1] Само сумарно | [2] Всеки истрит файл"
        $lang.RestartQ = "2. Рестарт на explorer.exe накрая? (Y/N)"
        $lang.WinSxSQ = "3. Оптимизация на WinSxS (бавно)? (Y/N)"
        $lang.SmartQ = "4. Smart Scan за остатъчни папки? (Y/N)"
        $lang.Working = "Започва почистването..."
        $lang.Found = "Намерена възможна излишна папка:"
        $lang.Prompt = "Желаете ли да я изтриете? (Y/N)"
        $lang.Total = "Вие освободихте ОБЩО"
        $lang.Duration = "Време за почистване"
        $lang.Done = "Готово! Прозорецът ще остане отворен."
        $lang.LogFolder = "Папка [{0}] - Освободени: {1} MB"
        $lang.LogSmartTotal = "Остатъци от приложения: Освободени {0} MB"
        $lang.Checking = "Проверка на {0}..."
        $lang.OK = " Готово!"
        $lang.UserTemp = "Потребителски Temp"
        $lang.WinTemp = "Системен Temp"
        $lang.Prefetch = "Prefetch кеш"
        $lang.Bin = "Кошчето"
    } else {
        $lang.Title = "CLEANUP PARAMETERS"
        $lang.LogQ = "1. Create log file? (Y/N)"
        $lang.LogLevelQ = "   - Detail level: [1] Summary only | [2] Every deleted file"
        $lang.RestartQ = "2. Restart explorer.exe at the end? (Y/N)"
        $lang.WinSxSQ = "3. WinSxS Optimization (slow)? (Y/N)"
        $lang.SmartQ = "4. Smart Scan for leftover folders? (Y/N)"
        $lang.Working = "Starting cleanup..."
        $lang.Found = "Potential leftover folder found:"
        $lang.Prompt = "Do you want to delete it? (Y/N)"
        $lang.Total = "Total space freed"
        $lang.Duration = "Time taken"
        $lang.Done = "Done! The window will stay open."
        $lang.LogFolder = "Folder [{0}] - Freed: {1} MB"
        $lang.LogSmartTotal = "App leftovers: Freed {0} MB"
        $lang.Checking = "Checking {0}..."
        $lang.OK = " OK!"
        $lang.UserTemp = "User Temp"
        $lang.WinTemp = "Win Temp"
        $lang.Prefetch = "Prefetch"
        $lang.Bin = "Recycle Bin"
    }
    return $lang
}