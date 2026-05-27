<#
    Core System Diagnostics Module
#>

function Get-CPUInfo {
    $cpu = Get-CimInstance -ClassName Win32_Processor
    $load = (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
    
    [PSCustomObject]@{
        Name        = $cpu.Name
        Cores       = $cpu.NumberOfCores
        Threads     = $cpu.NumberOfLogicalProcessors
        AvgUsage    = [math]::Round($load, 1)
    }
}

function Get-MemoryInfo {
    $mem = Get-CimInstance -ClassName Win32_OperatingSystem
    $total = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2)
    $free  = [math]::Round($mem.FreePhysicalMemory / 1MB, 2)
    $used  = $total - $free
    $percent = [math]::Round(($used / $total) * 100, 1)
    
    [PSCustomObject]@{
        TotalGB        = $total
        FreeGB         = $free
        UsedGB         = $used
        UsagePercent   = $percent
        TopProcesses   = (Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name, @{Name='MemoryMB';Expression={[math]::Round($_.WorkingSet / 1MB, 1)}})
    }
}

function Get-DiskInfo {
    Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $freePercent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
        [PSCustomObject]@{
            Drive           = $_.DeviceID
            SizeGB          = [math]::Round($_.Size / 1GB, 2)
            FreeGB          = [math]::Round($_.FreeSpace / 1GB, 2)
            FreeSpacePercent= $freePercent
            Health          = if ($freePercent -lt 10) { "Critical" } elseif ($freePercent -lt 20) { "Warning" } else { "Good" }
        }
    }
}

function Get-WindowsUpdateInfo {
    try {
        $updates = Get-WindowsUpdate -ErrorAction Stop | Where-Object { $_.IsInstalled -eq $false }
        [PSCustomObject]@{
            PendingUpdates = $updates.Count
            LastUpdateDate = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install" -ErrorAction SilentlyContinue).LastSuccessTime
        }
    }
    catch {
        [PSCustomObject]@{
            PendingUpdates = "Unknown (Install PSWindowsUpdate module)"
            LastUpdateDate = "N/A"
        }
    }
}

function Get-AntivirusStatus {
    $av = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct -ErrorAction SilentlyContinue
    
    [PSCustomObject]@{
        Installed      = if ($av) { $true } else { $false }
        DisplayName    = $av.displayName
        RealTimeEnabled= $av.productState -band 0x1000
        DefenderStatus = (Get-Service -Name WinDefend -ErrorAction SilentlyContinue).Status
    }
}

function Get-CriticalEventLogs {
    param([int]$Days = 7)
    
    $startTime = (Get-Date).AddDays(-$Days)
    
    Get-WinEvent -FilterHashtable @{
        LogName = 'System','Application'
        Level   = 1,2  # Critical (1), Error (2)
        StartTime = $startTime
    } -ErrorAction SilentlyContinue | Select-Object -First 30 TimeCreated, LogName, LevelDisplayName, Message
}

# Export all functions
Export-ModuleMember -Function *