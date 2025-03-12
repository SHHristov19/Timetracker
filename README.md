# Timetracker

```
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/import.ps1' -OutFile ((Get-ChildItem Env:TEMP).Value + '\import.ps1') -UseBasicParsing; PowerShell -ExecutionPolicy Bypass -File ((Get-ChildItem Env:TEMP).Value + '\import.ps1')"
```
