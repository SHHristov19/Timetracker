Add-Content -Path "$([Environment]::GetFolderPath('MyDocuments'))\TimeTracker\TimeTracker $(Get-Date -Format 'dd.MM.yyyy').txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [BREAK] User '$(whoami)' entered the workingspace '$(hostname)'"