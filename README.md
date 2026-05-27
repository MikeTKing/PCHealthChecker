# PCHealthChecker - Automated Windows PC Health Diagnostic Tool

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![HTML](https://img.shields.io/badge/HTML-239120?style=for-the-badge&logo=html5&logoColor=white)
![PDF](https://img.shields.io/badge/PDF-FF0000?style=for-the-badge&logo=adobeacrobat&logoColor=white)

**A professional automated diagnostic tool built to help IT Support and Helpdesk teams quickly assess Windows PC health.**

---

## Business Problem

IT and Helpdesk technicians waste valuable time **manually checking** slow or problematic machines. This tool automates the entire initial diagnostic process and generates professional reports for faster troubleshooting and better documentation.

This project demonstrates clean architecture, modularity, and real-world IT automation skills.

| File / Folder                    | Purpose |
|-------------------------------|--------|
| **`PCHealthChecker.ps1`**     | **Main Orchestration Script**<br>Entry point of the tool. Coordinates the entire workflow: gathers system data, calculates health score, generates reports, and handles user input. Includes robust error handling and logging. |
| **`modules/Utils.psm1`**      | **Utility Functions**<br>Contains helper functions like `Write-Log`, `Calculate-HealthScore`, `ConvertTo-Pdf`, and `Get-UptimeInfo`. Demonstrates reusable code practices and PDF generation using Opera GX. |
| **`modules/SystemDiagnostics.psm1`** | **Core Diagnostics Module**<br>Uses WMI/CIM to collect real system information (CPU, Memory, Disk, Antivirus, Event Logs, etc.). Shows deep understanding of Windows internals. |
| **`modules/ReportGenerator.psm1`** | **Report Generation Module**<br>Builds a professional HTML report with CSS styling, health scoring, and color-coded status indicators. Easily extensible for future features. |
| **`Reports/`**                | Output folder for generated HTML and PDF reports |
| **`Logs/`**                   | Stores execution logs for troubleshooting |

---

## Key Features

- Real-time CPU, RAM, and Disk health monitoring
- Windows Update and Antivirus status
- Critical Event Log analysis (last 7 days)
- Overall **Health Score** calculation (0–100)
- Professional HTML report with visual indicators
- PDF export support (Opera GX)
- Comprehensive error handling and logging

---

<img width="454" height="73" alt="image" src="https://github.com/user-attachments/assets/f9474ae0-04e0-4aa5-b645-71c9f1067a53" />





<img width="911" height="894" alt="image" src="https://github.com/user-attachments/assets/1ecbcdd3-20fd-488a-b3aa-37f8c92d9de7" />


<img width="477" height="122" alt="image" src="https://github.com/user-attachments/assets/7a49e5e5-b901-45ff-8343-83ed78deca9b" />




---

## Installation & Usage

### Prerequisites
- Windows 10/11
- Run PowerShell **as Administrator**

### Quick Start
```powershell
git clone https://github.com/yourusername/PCHealthChecker.git
cd PCHealthChecker
.\PCHealthChecker.ps1
