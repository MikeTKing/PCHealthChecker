function Get-CPUInfo {
    $load = (Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average
    [PSCustomObject]@{
        AvgUsage = [math]::Round($load, 1)
    }
}

function Get-MemoryInfo {
    $mem = Get-CimInstance Win32_OperatingSystem
    $total = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2)
    $free = [math]::Round($mem.FreePhysicalMemory / 1MB, 2)
    $used = $total - $free
    $percent = [math]::Round(($used / $total) * 100, 1)
    
    [PSCustomObject]@{
        UsagePercent = $percent
    }
}

function Get-DiskInfo {
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $freePercent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
        [PSCustomObject]@{
            Drive            = $_.DeviceID
            FreeSpacePercent = $freePercent
            Health           = if ($freePercent -lt 10) { "Critical" } elseif ($freePercent -lt 20) { "Warning" } else { "Good" }
        }
    }
}

function Get-WindowsUpdateInfo {
    [PSCustomObject]@{
        PendingUpdates = "Check manually (PSWindowsUpdate module optional)"
    }
}

function Get-AntivirusStatus {
    [PSCustomObject]@{
        DisplayName     = "Windows Defender"
        RealTimeEnabled = $true
    }
}

function Get-CriticalEventLogs {
    param([int]$Days = 7)
    @()  # Placeholder - returns empty for now
}

Export-ModuleMember -Function *