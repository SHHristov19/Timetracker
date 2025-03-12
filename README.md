# Timetracker

### Import tasks into Task Scheduler using this command in an admin terminal.
```
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/import.ps1' -OutFile ((Get-ChildItem Env:TEMP).Value + '\import.ps1') -UseBasicParsing; PowerShell -ExecutionPolicy Bypass -File ((Get-ChildItem Env:TEMP).Value + '\import.ps1')"
```

### Get the total working hours
```
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/TimeTracker.ps1' -OutFile ((Get-ChildItem Env:TEMP).Value + '\track.ps1') -UseBasicParsing; PowerShell -ExecutionPolicy Bypass -File ((Get-ChildItem Env:TEMP).Value + '\track.ps1')"
```
