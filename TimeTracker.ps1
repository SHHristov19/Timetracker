# Define the file path
$filePath = "C:\Users\shhristov\Documents\Time Tracker\time.txt"

# Read the file contents and extract datetime values using regex
$times = Get-Content $filePath | ForEach-Object { 
    if ($_ -match '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}') {
        [datetime]::ParseExact($matches[0], "yyyy-MM-dd HH:mm:ss", $null)
    }
}

# Ensure we have an even number of timestamps
if ($times.Count % 2 -ne 0) {
    Write-Output "Error: The file contains an odd number of timestamps."
    exit
}

$totalTime = [timespan]::Zero

# Iterate through pairs (Login at odd index, Logout at even index)
for ($i = 0; $i -lt $times.Count; $i += 2) {
    $loginTime = $times[$i]  # Odd index is login
    $logoutTime = $times[$i + 1]  # Even index is logout
    $sessionTime = $logoutTime - $loginTime  # Calculate session time as logoutTime - loginTime
    Write-Output "Session $($i/2 + 1): $sessionTime"
    $totalTime += $sessionTime
}

Write-Output "Total Time of Breaks: $totalTime"