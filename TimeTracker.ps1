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
 
# Use current time if END is missing
if (-Not $endTime) {
    $endTime = Get-Date
}

# Calculate total working time excluding breaks
$workTime = $endTime - $startTime
foreach ($b in $breaks) { 
    $workTime -= ($b.End - $b.Start)
}
 
Add-Type -AssemblyName PresentationFramework

# Create the window
$window = New-Object System.Windows.Window
$window.Title = "Work Hours Summary for today " +  $endTime.ToString("dd.MM.yyyy")
$window.Width = 500
$window.Height = 200
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen  # Centers the window on screen

# Create a StackPanel to display the content
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Add start time with larger text
$stackPanel.Children.Add((New-Object System.Windows.Controls.TextBlock -Property @{
    Text = "Time of start: $startTime"
    FontSize = 18  # Larger font size
}))

# Add breaks with larger text
$breaks | ForEach-Object {
    $stackPanel.Children.Add((New-Object System.Windows.Controls.TextBlock -Property @{
        Text = "Break from $($_.Start) to $($_.End)"
        FontSize = 16  # Larger font size
    }))
}

# Add end time with larger text
$stackPanel.Children.Add((New-Object System.Windows.Controls.TextBlock -Property @{
    Text = "Time of end: $endTime"
    FontSize = 18  # Larger font size
}))

# Add total working hours with bold and larger text
$totalTimeText = New-Object System.Windows.Controls.TextBlock -Property @{
    Text = "Total working hours: " + $workTime.ToString("hh\:mm\:ss")
    FontSize = 20  # Larger font size
    FontWeight = [System.Windows.FontWeights]::Bold  # Bold font
}
$stackPanel.Children.Add($totalTimeText)

# Show the window
$window.ShowDialog()
