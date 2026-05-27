# PCHealthChecker - Automated Windows PC Health Diagnostic Tool

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![HTML](https://img.shields.io/badge/HTML-239120?style=for-the-badge&logo=html5&logoColor=white)
![PDF](https://img.shields.io/badge/PDF-FF0000?style=for-the-badge&logo=adobeacrobat&logoColor=white)

**A professional automated diagnostic tool built to help IT Support and Helpdesk teams quickly assess Windows PC health.**

---

## Business Problem

IT and Helpdesk technicians waste valuable time **manually checking** slow or problematic machines. This tool automates the entire initial diagnostic process and generates professional reports for faster troubleshooting and better documentation.

---

## Key Features

- **Performance Monitoring**
  - CPU usage and core info
  - RAM usage + top memory-consuming processes
- **Storage Health**
  - Disk space usage with color-coded warnings
  - Drive health status
- **System Updates**
  - Windows Update status and pending updates
- **Security Check**
  - Antivirus / Windows Defender status
  - Real-time protection verification
- **Stability**
  - System uptime and last boot time
  - Critical & Error event logs (last 7 days)
- **Professional Reporting**
  - Beautiful **HTML report** with health score
  - **PDF export** support (via Microsoft Edge)
  - Color-coded status indicators (Green/Yellow/Red)
- **Robustness**
  - Comprehensive error handling
  - Detailed logging to file

---

## Technologies Used

- **PowerShell 5.1+**
- **WMI / CIM** for hardware and system data
- **Windows Event Log APIs**
- **Microsoft Edge** headless mode for PDF generation
- Modular design with separate PowerShell modules

---

## Repository Structure
