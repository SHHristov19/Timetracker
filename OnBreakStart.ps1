$logDir = "$([Environment]::GetFolderPath('MyDocuments'))\TimeTracker"
$logFile = "$logDir\TimeTracker $(Get-Date -Format 'dd.MM.yyyy').txt"
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$username = $(whoami)
$hostname = $(hostname)
$logEntry = "[$timestamp] [BREAK] User '$username' left the workspace '$hostname'"

# Ensure directory exists
if (!(Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force
}

# Write to log file
Add-Content -Path $logFile -Value $logEntry