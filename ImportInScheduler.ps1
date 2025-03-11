$TaskXmlFolder = "E:\TimeTracker\Timetracker"  # Change this to your folder path

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

    $XmlFilePath = "`"" + $XmlFile.FullName + "`""  # Ensure proper quoting
    $Command = "schtasks /create /tn `"$TaskName`" /xml $XmlFilePath /RU `"SYSTEM`" /f"

    Write-Host "Running command: $Command"  # Debugging output

    # Run schtasks through PowerShell
    $Process = Start-Process -FilePath "schtasks" -ArgumentList "/create /tn `"$TaskName`" /xml $XmlFilePath /RU `"SYSTEM`" /f" -NoNewWindow -PassThru -Wait

    # Check if the command was successful
    if ($Process.ExitCode -eq 0) {
        Write-Host "Successfully imported: $TaskName" -ForegroundColor Green
    } else {
        Write-Host "Failed to import: $TaskName" -ForegroundColor Red
    }
}

powershell -ExecutionPolicy Bypass -File E:\TimeTracker\Timetracker\ImportInScheduler.ps1
