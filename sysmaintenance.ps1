$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
# Wait 90 seconds
Start-Sleep -Seconds 90

# Run sfc /scannow and log the output
sfc /scannow
Write-Output "$timestamp SFC Complete" | Out-File -FilePath "c:\sysmaint.txt" -Append

# Wait 90 seconds
Start-Sleep -Seconds 90

# Run dism /online /cleanup-image /restorehealth and log the output
dism /online /cleanup-image /restorehealth
Write-Output "$timestamp DISM Complete" | Out-File -FilePath "c:\sysmaint.txt" -Append