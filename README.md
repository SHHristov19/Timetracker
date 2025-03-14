# TimeTrack Assistant

This PowerShell script reads a daily work log from a file, processes it to extract working hours and breaks, and then displays a summary of total working hours excluding breaks in a graphical user interface.

## Features

- **Log File Processing**: Reads a log file containing `START`, `BREAK`, and `END` events.
- **Time Calculation**: Calculates total working time, excluding breaks.
- **Graphical User Interface (GUI)**: Displays a formatted summary of the work hours in a window with customized font size and alignment.
- **Current Time Fallback**: If the log file doesn't contain an `END` event, the script uses the current time to calculate the total working hours.

## Prerequisites

- PowerShell 5.0 or higher (typically comes pre-installed on Windows).
- Windows operating system (for using the GUI functionality).
- `PresentationFramework` assembly, which is available by default on Windows.

## File Format

The script expects a log file with the following structure, saved as `TimeTracker dd.MM.yyyy.txt` under the directory: <br>
`C:\Users\<YourUser>\Documents\TimeTracker\TimeTracker dd.MM.yyyy.txt` <br> 
Each entry in the file should be formatted as:
```
[2025-03-14 09:00:00] [START] User 'username' logged in 
[2025-03-14 12:30:00] [BREAK] Break started 
[2025-03-14 13:15:00] [BREAK] Break ended 
[2025-03-14 18:00:00] [END] User 'username' logged out
```

Where:
- `[START]`: The time the user starts working.
- `[BREAK]`: Times for breaks, with start and end.
- `[END]`: The time the user finishes their workday.

## How It Works

1. **Reads the log file** from the directory: `$env:USERPROFILE\Documents\TimeTracker\TimeTracker dd.MM.yyyy.txt`.
2. **Parses the log** for `START`, `BREAK`, and `END` events.
3. **Calculates working hours**: Computes total working time by subtracting break durations from the total work time.
4. **Displays a summary** of the working hours in a window with:
   - Start time.
   - Breaks with their start and end times.
   - End time (or current time if `END` is missing).
   - Total working hours (excluding breaks).

## Installation and Usage

### Step 1: Set up Task Scheduler for Login and Logout Events

The following tasks will be created using Task Scheduler to automatically run the scripts when the user logs in and logs out.

**Steps:**
1. Open PowerShell as Administrator.
2. Run the following command to create the necessary tasks in Microsoft Task Scheduler:
```
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/import.ps1' -OutFile ((Get-ChildItem Env:TEMP).Value + '\import.ps1') -UseBasicParsing; PowerShell -ExecutionPolicy Bypass -File ((Get-ChildItem Env:TEMP).Value + '\import.ps1')"
```
### Step 2: Track Total Working Hours

After the log file has been created, you can track the total working hours by running the following command in PowerShell as an administrator:
```
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SHHristov19/Timetracker/refs/heads/main/TimeTracker.ps1' -OutFile ((Get-ChildItem Env:TEMP).Value + '\track.ps1') -UseBasicParsing; PowerShell -ExecutionPolicy Bypass -File ((Get-ChildItem Env:TEMP).Value + '\track.ps1')"
```
This script will read the log file generated earlier and output the working hours in a new window. 

## Troubleshooting
- **File Not Found**: If the script cannot find the log file, ensure it exists in the Documents\TimeTracker folder with the correct date format.
- **Invalid Log Format**: Ensure that each line in the log follows the [datetime] [EVENT] format for proper parsing.
- **Missing END Event**: If the END event is missing, the script will use the current time to compute the total working hours.
