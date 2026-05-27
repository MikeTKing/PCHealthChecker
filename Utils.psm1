<#
    Utility Functions for PC Health Checker
#>

function Get-UptimeInfo {
    $uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    [PSCustomObject]@{
        UptimeDays    = [math]::Round($uptime.TotalDays, 1)
        UptimeHours   = [math]::Round($uptime.TotalHours, 1)
        LastBootTime  = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    }
}

function Calculate-HealthScore {
    param($HealthData)
    
    $score = 100
    
    # CPU Penalty
    if ($HealthData.CPU.AvgUsage -gt 80) { $score -= 25 }
    elseif ($HealthData.CPU.AvgUsage -gt 60) { $score -= 15 }
    
    # Memory Penalty
    if ($HealthData.Memory.UsagePercent -gt 85) { $score -= 25 }
    elseif ($HealthData.Memory.UsagePercent -gt 70) { $score -= 15 }
    
    # Disk Penalty
    if ($HealthData.Disk | Where-Object { $_.FreeSpacePercent -lt 15 }) { $score -= 20 }
    
    # Updates Penalty
    if ($HealthData.Updates.PendingUpdates -gt 5) { $score -= 10 }
    
    # Event Logs Penalty
    if ($HealthData.EventLogs.Count -gt 50) { $score -= 15 }
    
    [math]::Max(0, $score)
}

# Export all functions
Export-ModuleMember -Function *