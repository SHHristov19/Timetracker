# Define the path to the folder containing XML files
$TaskXmlFolder = "E:\TimeTracker\Timetracker"  # Change this to your folder path

# Get the current user's SID
$UserSID = (Get-WmiObject Win32_UserAccount | Where-Object { $_.Name -eq $env:USERNAME }).SID
if (-not $UserSID) {
    Write-Host "Failed to retrieve user SID" -ForegroundColor Red
    exit
}

# Get all XML files in the specified folder
$XmlFiles = Get-ChildItem -Path $TaskXmlFolder -Filter "*.xml"

if ($XmlFiles.Count -eq 0) {
    Write-Host "No XML files found in $TaskXmlFolder" -ForegroundColor Yellow
    exit
}

foreach ($XmlFile in $XmlFiles) {
    # Extract the task name from the file name (without extension)
    $TaskName = [System.IO.Path]::GetFileNameWithoutExtension($XmlFile.Name)

    # Ensure task name is not empty
    if ([string]::IsNullOrWhiteSpace($TaskName)) {
        Write-Host "⚠ Skipping file with empty task name: $XmlFile.FullName" -ForegroundColor Yellow
        continue
    }

    # Load the XML file
    [xml]$XmlContent = Get-Content $XmlFile.FullName

    # Find and update the <UserId> element with the current user's SID
    if ($XmlContent.Task.Principals.Principal.UserId) {
        $XmlContent.Task.Principals.Principal.UserId = $UserSID
        $XmlContent.Save($XmlFile.FullName)
        Write-Host "Updated UserId in $XmlFile with SID: $UserSID" -ForegroundColor Cyan
    } else {
        Write-Host "No <UserId> element found in $XmlFile, skipping update." -ForegroundColor Yellow
    }

    # Import the modified XML into Task Scheduler
    $XmlFilePath = "`"" + $XmlFile.FullName + "`""  # Ensure proper quoting
	
	$Command = @(
		"/create",
		"/tn", "`"$TaskName`"",
		"/xml", "`"$XmlFilePath`"",
		"/RU", "$env:USERNAME",
		"/f"
	)

	# Run schtasks through PowerShell
	$Process = Start-Process -FilePath "schtasks" -ArgumentList $Command -NoNewWindow -PassThru -Wait

    # Check if the command was successful
    if ($Process.ExitCode -eq 0) {
        Write-Host "Successfully imported: $TaskName" -ForegroundColor Green
    } else {
        Write-Host "Failed to import: $TaskName" -ForegroundColor Red
    }
}

# Run ImportInScheduler.ps1 after processing all XML files
$ImportScriptPath = "E:\TimeTracker\Timetracker\ImportInScheduler.ps1"
if (Test-Path $ImportScriptPath) {
    Write-Host "Executing ImportInScheduler.ps1..." -ForegroundColor Blue
    powershell -ExecutionPolicy Bypass -File $ImportScriptPath
} else {
    Write-Host "⚠ ImportInScheduler.ps1 not found, skipping execution." -ForegroundColor Yellow
}
