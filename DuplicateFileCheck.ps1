 do{ cls 
 write-host ""
    Write-Host "DUPLICATE FILE CHECKER"
    Write-Host "######################"
    Write-Host " "
    Write-Host "Please select an option:"
    Write-Host "1. Run a Quick Search (less accurate - only matches files with same name and file size)."
    Write-Host "2. Run a Detailed Search (takes longer - match files by unique hash, even if name is different)."
    Write-Host "0. Exit script."

    $opt = Read-Host "Enter choice"

    $ok = $opt -match '[012]+$'
    if ( -not $ok) {write-host "Invalid option, try again..."
                    sleep 3
                    write-host ""
                    }
} until ($ok)

function scanDrives {
    #Fetch Drive info
    Get-PSDrive -PSProvider FileSystem | Select-Object Root, @{Name="Used (GB)";Expression={[math]::Round($_.Used/1GB,2)}}, @{Name="Free (GB)";Expression={[math]::Round($_.Free/1GB,2)}}, Name | Out-String
}


function getDrive {
    Write-Host "Serarching for available drives to scan..."
    $drives = scanDrives
    Write-Host $drives
    Write-Host 'You can enter the Root of the drive you wish to scan (e.g. "C:\"),'
    Write-Host 'or enter a custom path if desired (e.g. "C:\Temp\MyFiles\").'
    Write-Host 'NOTE: Use quotes if your path contains spaces (e.g. "C:\My Folder\")'
    Write-Host " "
    $a = Read-Host 'ENTER ROOT OR PATH TO SCAN'
    $checkDrive = $a
    Set-Location -Path $checkDrive
    Write-Output $checkDrive
}    


Function PauseMsg ($message) {
    # Check if running Powershell ISE
    if ($psISE) {
        Write-Host "$message"
        Write-Host " "
        Start-Sleep -Seconds 1
        Write-Host "NOTE: Key pressed for you, as you are using Powershell ISE (This is not an error) ;)"
    }
    else {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

if ($opt -eq 1)
    {Write-Host " "
    $myPath = getDrive
    Write-Host -NoNewline "Running a Quick Search for duplicate files in path: "
    Write-Host $myPath
    Write-Host "Press CTRL + BREAK to abort."
    Start-Sleep -Seconds 1
    Get-ChildItem -Recurse -File | Group-Object Name, Length | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Group | Tee-Object -Variable RawData | Format-Table Name, FullName -Wrap | Out-File -FilePath .\Duplicates-Quick-Scan.txt; $RawData | Select-Object PSChildName, Directory, FullName, CreationTimeUtc, LastAccessTime | Export-Csv -Path .\Duplicates-Quick-Scan.csv -NoTypeInformation
    #Get-Content -Path .\Quick-Duplicate-File-Check-Results.txt #Show results on screen
    Write-Host " "
    Write-Host "##########################" -ForegroundColor Black -BackgroundColor Green
    Write-Host "# Quick Search Completed #" -ForegroundColor Black -BackgroundColor Green
    Write-Host "##########################" -ForegroundColor Black -BackgroundColor Green
    Write-Host " "
    Write-Host 'Results written to Path: $myPath using Filename "Duplicates-Quick-Search.txt" and ".csv"'

    Write-Host " "
    Start-Sleep -Seconds 2
    $message = "Press any key to exit..."
    PauseMsg($message)   
    Exit
    }

if ($opt -eq 2)
    {Write-host ""
    $myPath = getDrive
    Write-Host -NoNewline "Running a Detailed Scan for duplicate files in "
    Write-Host $myPath
    Start-Sleep -Seconds 1
    Write-Host " "
    Write-Host "... This may take some time, depending on the size of the directory ..."
    Write-Host " "
    Write-Host "####################################################################" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host "# CAUTION! - SELECTED DRIVE MAY OVERHEAT AND SLOW DOWN DURING SCAN #" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host "#    MANUALLY INCREASE CASE FAN SPEED TO COMPENSATE IF REQUIRED    #" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host "####################################################################" -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " "
    Write-Host "Press CTRL + BREAK to abort."    
    Get-ChildItem -Recurse -File | Group-Object { (Get-FileHash $_.FullName -Algorithm MD5).Hash } | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group } | Select-Object Name, FullName, Directory, @{N='Hash';E={(Get-FileHash $_.FullName -Algorithm MD5).Hash}}, CreationTimeUtc, LastAccessTime | Tee-Object -Variable RawData | Format-Table Name, Directory, FullName, Hash -Wrap | Out-File -FilePath .\Duplicates-Detailed-Scan.txt; $RawData | Select-Object Name, Directory, FullName, Hash, CreationTimeUtc, LastAccessTime | Export-Csv -Path .\Duplicates-Detailed-Scan.csv -NoTypeInformation
    #Get-Content -Path .\Detailed-Duplicate-File-Check-Results.txt #Show results on screen
    Write-Host " "
    write-host "###########################" -ForegroundColor Black -BackgroundColor Green
    write-host "# Detailed Scan Completed #" -ForegroundColor Black -BackgroundColor Green
    write-host "###########################" -ForegroundColor Black -BackgroundColor Green
    Write-Host " "
    Start-Sleep -Seconds 2
    Write-Host 'Results written to Path: $myPath using Filename "Duplicates-Detailed-Search.txt" and ".csv"'
    Write-Host " "
    $message = "Press any key to exit..."
    PauseMsg($message)
    Exit
    }

if ($opt -eq 0)
    {Write-host ""
    Write-Host "GOODBYE :P"
    Start-Sleep -Seconds 5
    Exit
    }

