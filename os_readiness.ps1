# Requires -Version 5.1

function Test-Windows11Readiness {
    [CmdletBinding()]
    Param()

    $Result = @{
        TPM20Present = $false
        SecureBootCapable = $false
        GPTPartitionStyle = $false
        MinRAMMet = $false
        MinDiskSpaceMet = $false
        CPUCompatible = $false
    }

    # Check TPM 2.0
    try {
        $tpm = Get-CimInstance -ClassName Win32_Tpm -ErrorAction Stop
        if ($tpm.SpecVersion -like "2.0*") {
            $Result.TPM20Present = $true
        }
    } catch {
        # TPM not found or error accessing
    }

    # Check Secure Boot
    try {
        $secureBoot = Get-CimInstance -ClassName Win32_SecureBootState -ErrorAction Stop
        if ($secureBoot.SecureBootEnabled) {
            $Result.SecureBootCapable = $true
        }
    } catch {
        # Secure Boot state not found or error accessing
    }

    # Check GPT Partition Style for OS Drive
    try {
        $osDisk = Get-CimInstance -ClassName Win32_DiskDrive | Where-Object { $_.Model -eq (Get-WmiObject Win32_OperatingSystem).SystemDrive.Split('\')[0] }
        if ($osDisk.PartitionStyle -eq "GPT") {
            $Result.GPTPartitionStyle = $true
        }
    } catch {
        # Error determining partition style
    }

    # Check Minimum RAM (4GB)
    try {
        $physicalMemory = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
        if ($physicalMemory -ge (4GB)) {
            $Result.MinRAMMet = $true
        }
    } catch {
        # Error getting physical memory
    }

    # Check Minimum Disk Space (64GB)
    try {
        $osDrive = Get-PSDrive C
        if ($osDrive.Free -ge (64GB)) {
            $Result.MinDiskSpaceMet = $true
        }
    } catch {
        # Error getting disk space
    }

    # CPU Compatibility (a more complex check, simplified for example)
    # This would typically involve checking against a list of supported CPUs
    # For this example, we'll just check for 64-bit architecture
    try {
        $cpu = Get-CimInstance -ClassName Win32_Processor
        if ($cpu.AddressWidth -eq 64) {
            $Result.CPUCompatible = $true
        }
    } catch {
        # Error getting CPU info
    }

    [PSCustomObject]$Result
}

# Run the function and display results
Test-Windows11Readiness
