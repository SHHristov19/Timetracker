$logDirectory = "$([Environment]::GetFolderPath('MyDocuments'))\TimeTracker"
$logFile = "$logDirectory\TimeTracker $(Get-Date -Format 'dd.MM.yyyy').txt"

# Check if directory exists, if not, create it
if (-not (Test-Path -Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory -Force
}

# Write the log entry
Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [START] User '$(whoami)' was logged in on computer '$(hostname)'"