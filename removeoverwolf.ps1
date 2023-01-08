Start-Sleep -Seconds 90
Stop-Process -Name "icafecloudtrackersetup" -Force
Stop-Process -Name "overwolf" -Force
Start-Sleep -Seconds 90
# Set the variables for the log file
$logFile = "c:\owolf_rem.log"

# Set the variables for the log entry
${timestamp} = Get-Date
$pc = $env:COMPUTERNAME
$location = $pc.Split('-')[1]
$localIp = (Test-Connection -Count 1 localhost).IPV4Address.IPAddressToString
$externalIp = (Invoke-WebRequest ifconfig.me/ip).Content
$event = "Remove Overwolf"

# Check if the Overwolf folders exist
if (!(Test-Path "d:\internet tools\icafemenu\overwolf") -and !(Test-Path "s:\internet tools\icafemenu\overwolf") -and !(Test-Path "e:\internet tools\icafemenu\overwolf"))
{
    # Log a message if the Overwolf folders do not exist
    Add-Content -Path $logFile -Value "`n${timestamp}: PC=$pc, Location=$location, Local IP=$localIp, External IP=$externalIp, Event=$event, Result=skip, Error Message=Overwolf Not Found - Skipping Deletion" -Force
    return
}

# Try to kill the processes and delete the folders
try
{
    if (Test-Path "d:\internet tools\icafemenu\overwolf")
    {
        Remove-Item -Path "d:\internet tools\icafemenu\overwolf" -Recurse -Force
    }
    if (Test-Path "s:\internet tools\icafemenu\overwolf")
    {
        Remove-Item -Path "s:\internet tools\icafemenu\overwolf" -Recurse -Force
    }
    if (Test-Path "e:\internet tools\icafemenu\overwolf")
    {
        Remove-Item -Path "e:\internet tools\icafemenu\overwolf" -Recurse -Force
    }
    $result = "success"
    $errorMessage = $null
}
catch
{
    $result = "failure"
    $errorMessage = $_.Exception.Message
}

# Check if the directories were deleted and log a message if not
if (Test-Path "d:\internet tools\icafemenu\overwolf")
{
    Write-Host "d:\internet tools\icafemenu\overwolf not deleted"
    Add-Content -Path $logFile -Value "`n${timestamp}: d:\internet tools\icafemenu\overwolf not deleted" -Force
}
if (Test-Path "s:\internet tools\icafemenu\overwolf")
{
    Write-Host "s:\internet tools\icafemenu\overwolf not deleted"
    Add-Content -Path $logFile -Value "`n${timestamp}: s:\internet tools\icafemenu\overwolf not deleted" -Force
}
if (Test-Path "e:\internet tools\icafemenu\overwolf")
{
    Write-Host "e:\internet tools\icafemenu\overwolf not deleted"
    Add-Content -Path $logFile -Value "`n${timestamp}: e:\internet tools\icafemenu\overwolf not deleted" -Force
}

# Log the event to the log file
Add-Content -Path $logFile -Value "`n${timestamp}: PC=${pc}, Location=${location}, Local IP=${localIp}, External IP=${externalIp}, Event=${event}, Result=${result}, Error Message=${errorMessage}" -Force
