# Find the registry key for Google Chrome uninstall information
$chromeRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome"
$chromeRegistryPathWow64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome"

# Check if the Chrome uninstall registry key exists in 32-bit or 64-bit registry
$chromeUninstallString = ""
if (Test-Path $chromeRegistryPath) {
    $chromeUninstallString = (Get-ItemProperty -Path $chromeRegistryPath).UninstallString
} elseif (Test-Path $chromeRegistryPathWow64) {
    $chromeUninstallString = (Get-ItemProperty -Path $chromeRegistryPathWow64).UninstallString
}

# If the uninstall string is found, proceed with uninstallation
if ($chromeUninstallString) {
    Write-Host "Found Chrome uninstall string: $chromeUninstallString"
    
    # Run the uninstall command
    Write-Host "Uninstalling Google Chrome..."
    Start-Process -FilePath $chromeUninstallString -ArgumentList "/silent /uninstall" -Wait
    Write-Host "Google Chrome has been uninstalled successfully."
} else {
    Write-Host "Google Chrome uninstall string not found in the registry. Chrome might not be installed."
}
