function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $LogFile = ".\Logs\PCHealthChecker.log"
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp [$Level] $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    
    $Color = if($Level -eq "ERROR"){"Red"}elseif($Level -eq "WARNING"){"Yellow"}else{"White"}
    Write-Host "[$Level] $Message" -ForegroundColor $Color
}

function ConvertTo-Pdf {
    param([string]$HtmlPath, [string]$PdfPath)
    
    try {
        # Your exact Opera GX path
        $operaPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Opera GX\opera.exe"
        
        if (Test-Path $operaPath) {
            $arguments = "--headless", "--print-to-pdf=`"$PdfPath`"", "--no-margins", "--disable-gpu", "`"$HtmlPath`""
            Start-Process -FilePath $operaPath -ArgumentList $arguments -Wait -NoNewWindow
            Write-Log "PDF report generated successfully using Opera GX" "INFO"
            return $true
        } 
        else {
            Write-Log "Opera GX not found at expected location. Skipping PDF export." "WARNING"
            return $false
        }
    }
    catch {
        Write-Log "PDF conversion failed: $($_.Exception.Message)" "ERROR"
        return $false
    }
}
      

function Get-UptimeInfo {
    $uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    [PSCustomObject]@{
        UptimeDays   = [math]::Round($uptime.TotalDays, 1)
        LastBootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    }
}

function Calculate-HealthScore {
    param($HealthData)
    $score = 100
    if ($HealthData.CPU.AvgUsage -gt 80) { $score -= 25 }
    elseif ($HealthData.CPU.AvgUsage -gt 60) { $score -= 15 }
    if ($HealthData.Memory.UsagePercent -gt 85) { $score -= 25 }
    elseif ($HealthData.Memory.UsagePercent -gt 70) { $score -= 15 }
    if ($HealthData.Disk | Where-Object { $_.FreeSpacePercent -lt 15 }) { $score -= 20 }
    [math]::Max(0, $score)
}

Export-ModuleMember -Function *