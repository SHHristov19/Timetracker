# Define an array of XML URLs
$xmlUrls = @(
    "https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/TimeTracker-OnStart.xml",
    "https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/TimeTracker-OnBreakStart.xml",
    "https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/TimeTracker-OnBreakEnd.xml",
    "https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/TimeTracker-OnShutDown.xml"
)

# Retrieve the User SID
$UserSID = (Get-WmiObject Win32_UserAccount | Where-Object { $_.Name -eq $env:USERNAME }).SID

# Get the current date in the desired format (ISO 8601)
$currentDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fff")

# Loop through each URL
foreach ($xmlUrl in $xmlUrls) {
    # Define the path where the file will be stored (in the TEMP folder)
    $xmlFilePath = (Get-ChildItem Env:TEMP).Value + '\' + [System.IO.Path]::GetFileName($xmlUrl)

    # Download the XML file to the TEMP folder
    Invoke-WebRequest -Uri $xmlUrl -OutFile $xmlFilePath

    # Create a new XmlDocument object
    $XmlObject = New-Object -TypeName System.Xml.XmlDocument

    # Load the downloaded XML file into the XmlDocument object
    $XmlObject.Load($xmlFilePath)

    # Insert User SID into the XML
    $XmlObject.Task.Principals.Principal.UserId = $UserSID

    # Update the Date tag in RegistrationInfo to the current date
    $XmlObject.Task.RegistrationInfo.Date = $currentDate

    # Extract Task Name from XML
    $TaskName = $XmlObject.Task.RegistrationInfo.URI -replace "^\\", ""

    # Register the scheduled task
    Register-ScheduledTask -Xml $XmlObject.OuterXml -TaskName $TaskName -User ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -Force
}