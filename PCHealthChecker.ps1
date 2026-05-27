<#
.SYNOPSIS
    Automated PC Health Check Tool for Helpdesk & IT Support
#>

#Requires -RunAsAdministrator

# =============================================
# Configuration
# =============================================
$ReportPath = ".\Reports"
$LogPath    = ".\Logs"
$ReportName = "PCHealthReport_$(Get-Date -Format 'yyyy-MM-dd_HH-mm')"
$ComputerName = $env:COMPUTERNAME

# Create directories
foreach ($path in $ReportPath, $LogPath) {
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
}

# =============================================
# Import Modules
# =============================================
Import-Module .\modules\Utils.psm1 -Force
Import-Module .\modules\SystemDiagnostics.psm1 -Force
Import-Module .\modules\ReportGenerator.psm1 -Force

Write-Log "Starting PC Health Check for $ComputerName" "INFO"

try {
    Write-Host "🚀 Starting PC Health Check for $ComputerName..." -ForegroundColor Cyan

    # =============================================
    # Gather Diagnostics
    # =============================================
    $HealthData = @{
        ComputerName = $ComputerName
        CheckDate    = Get-Date
        Uptime       = Get-UptimeInfo
        CPU          = Get-CPUInfo
        Memory       = Get-MemoryInfo
        Disk         = Get-DiskInfo
        Updates      = Get-WindowsUpdateInfo
        Antivirus    = Get-AntivirusStatus
        EventLogs    = Get-CriticalEventLogs -Days 7
        HealthScore  = 0
    }

    $HealthData.HealthScore = Calculate-HealthScore $HealthData

    # =============================================
    # Generate Report
    # =============================================
    Write-Host "📊 Generating Report..." -ForegroundColor Cyan

    $ReportChoice = Read-Host "Choose report format (H = HTML, P = PDF, B = Both)"

    $HtmlContent = New-HealthReport -HealthData $HealthData

    $HtmlFile = Join-Path $ReportPath "$ReportName.html"
    $HtmlContent | Out-File -FilePath $HtmlFile -Encoding UTF8

    if ($ReportChoice -eq 'P' -or $ReportChoice -eq 'B') {
        $PdfFile = Join-Path $ReportPath "$ReportName.pdf"
        ConvertTo-Pdf -HtmlPath $HtmlFile -PdfPath $PdfFile
    }

    Write-Host "✅ Health check completed!" -ForegroundColor Green
    Write-Host "📄 Report saved to: $ReportPath" -ForegroundColor Green

    # Open report
    if (Test-Path $HtmlFile) { Start-Process $HtmlFile }

} catch {
    Write-Log "Critical error: $($_.Exception.Message)" "ERROR"
    Write-Host "❌ An error occurred. Check log file for details." -ForegroundColor Red
}