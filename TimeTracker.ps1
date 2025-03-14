# Define the file path
$currentDate = Get-Date -Format "dd.MM.yyyy"
$filePath = "$env:USERPROFILE\Documents\TimeTracker\TimeTracker $currentDate.txt"

# Check if file exists
if (-Not (Test-Path $filePath)) {
    Write-Output "Error: File not found: $filePath"
}

# Read file contents
$entries = Get-Content $filePath | ForEach-Object {
    if ($_ -match '\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] \[(START|BREAK|END)\]') {
        [PSCustomObject]@{
            DateTime = [datetime]::ParseExact($matches[1], "yyyy-MM-dd HH:mm:ss", $null)
            Event    = $matches[2]
        }
    }
}

# Ensure there is at least a START entry
if (-Not $entries -or $entries[0].Event -ne "START") {
    Write-Output "Error: The log file must start with [START]"
}

$startTime = $entries[0].DateTime.TimeOfDay
$endTime = $null
$breaks = @()
$workTime = [timespan]::Zero

Write-Output "Time of start: $startTime"

# Process entries
$pendingBreakStart = $null  # Stores unmatched break start times

for ($i = 1; $i -lt $entries.Count; $i++) {
    $current = $entries[$i]

    if ($current.Event -eq "BREAK") {
        if (-Not $pendingBreakStart) {
            # Store first break time (break start)
            $pendingBreakStart = $current.DateTime
        } else {
            # Pair with previous break (break end)
            $breaks += @{
                Start = $pendingBreakStart
                End   = $current.DateTime
            }
            $pendingBreakStart = $null  # Reset
        }
    }
    elseif ($current.Event -eq "END") {
        $endTime = $current.DateTime
    }
}

# Check for unpaired break start
if ($pendingBreakStart) {
    Write-Output "Warning: Unmatched break start at $pendingBreakStart. Ignoring it!"
}

# Use current time if END is missing
if (-Not $endTime) {
    $endTime = Get-Date
}

# Calculate total working time excluding breaks
$workTime = $endTime - $startTime
foreach ($b in $breaks) {
    Write-Output "Break from $($b.Start.TimeOfDay) to $($b.End.TimeOfDay)"
    $workTime -= ($b.End - $b.Start)
}
 
Write-Output ("Total working hours: " + $workTime.ToString("hh\:mm\:ss"))
