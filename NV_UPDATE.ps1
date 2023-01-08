[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Grab latest URL from Github
Invoke-WebRequest "https://raw.githubusercontent.com/ESAScanada/nvidiadriverurl/main/nvurl.txt" -OutFile "c:\nvurl.txt"
# Save Download URL for latest Nvidia Drivers
$nvpath = Get-Content -Path c:\nvurl.txt -raw
# Check if Drivers need to update
$file_data = Get-Content c:\nvurl.txt -raw
# Log the completion of the driver update and the installed version
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($nvpath -notcontains $file_data[3]) {
    "$timestamp Drivers will be updated" | Out-File -FilePath "c:\nvupdateresult.txt" -Append   
    # Download the driver package
    Invoke-WebRequest $file_data -OutFile "c:\driver.exe"
        
    $sevenZipInstalled = Get-ItemProperty HKLM:\SOFTWARE\7-Zip | Select-Object -ExpandProperty Path
    if (-not $sevenZipInstalled) {
        # Set the download location for 7-Zip
        $dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object { ($_.innerHTML -eq 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe") } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        $installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)

        # Download 7-Zip
        Invoke-WebRequest $dlurl -OutFile $installerPath

        # Install 7-Zip
        Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait | Out-Null
    }
    # Extract Contents
    $7zpath = Get-ItemProperty -path  HKLM:\SOFTWARE\7-Zip\ -Name Path
    $7zpath = $7zpath.Path
    $7zpathexe = $7zpath + "7z.exe"
    $filesToExtract = "c:\driver.exe"
    $extractFolder = "c:\driver"
    Start-Process -FilePath $7zpathexe -NoNewWindow -ArgumentList "x -bso0 -bsp1 -bse1 -aoa $dlFile $filesToExtract -o""$extractFolder""" -wait
    Start-Sleep -Seconds 15
    # Install Drivers
    c:\driver\setup.exe Display.Driver HDAudio.Driver -clean -s
    Start-Sleep -Seconds 120

    # Get the version of the installed drivers
    $installedDriverVersion = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*Nvidia*" }).DisplayVersion

    # Log the completion of the driver update and the installed version
    "$timestamp Driver update completed. Installed version: $installedDriverVersion" | Out-File -FilePath "c:\nvupdateresult.txt" -Append
}
Remove-Item c:\driver.exe