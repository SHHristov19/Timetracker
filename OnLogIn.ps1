# Set the path for the log file
$folderPath = "$([Environment]::GetFolderPath('MyDocuments'))\TimeTracker"

# Ensure the folder exists; create it if it doesn't
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

# Log the information to the file
$logFile = "$folderPath\TimeTracker $(Get-Date -Format 'dd.MM.yyyy').txt"
Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [START] User '$(whoami)' was logged in on computer '$(hostname)'."