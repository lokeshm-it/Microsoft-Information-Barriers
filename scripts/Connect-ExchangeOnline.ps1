<#
.SYNOPSIS
    Connects to Exchange Online for Microsoft Purview Information Barriers administration.

.DESCRIPTION
    Establishes a modern-auth connection to Exchange Online PowerShell using the
    ExchangeOnlineManagement module. This connection is a prerequisite for every
    Information Barriers cmdlet used in this repository (Get-EXOInformationBarrierRelationship,
    Get-InformationBarrierPolicy, Get-OrganizationSegment, etc.).

.PARAMETER UserPrincipalName
    The UPN of the account used to connect (must hold Compliance Administrator,
    Global Administrator, or an equivalent Information Barriers-capable role).

.EXAMPLE
    .\Connect-ExchangeOnline.ps1 -UserPrincipalName admin@securem365lsb.onmicrosoft.com

.NOTES
    Author:  Lokesh Karnam
    Purpose: Microsoft Purview Information Barriers — Project 16
    Requires: ExchangeOnlineManagement module (Install-Module ExchangeOnlineManagement)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "UPN of the admin account used to connect to Exchange Online")]
    [ValidateNotNullOrEmpty()]
    [string]$UserPrincipalName
)

$ErrorActionPreference = 'Stop'

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Level] $Message"
}

try {
    Write-Log "Checking for the ExchangeOnlineManagement module..."

    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Write-Log "ExchangeOnlineManagement module not found. Installing for the current user..." "WARN"
        Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -AllowClobber
    }
    else {
        Write-Log "ExchangeOnlineManagement module is already installed."
    }

    Write-Log "Importing ExchangeOnlineManagement module..."
    Import-Module ExchangeOnlineManagement -ErrorAction Stop

    Write-Log "Connecting to Exchange Online as '$UserPrincipalName'. A sign-in prompt will appear..."
    Connect-ExchangeOnline -UserPrincipalName $UserPrincipalName -ShowBanner:$false

    Write-Log "Successfully connected to Exchange Online." "SUCCESS"
    Write-Log "You can now run Information Barriers cmdlets such as Get-EXOInformationBarrierRelationship, Get-InformationBarrierPolicy, and Get-OrganizationSegment."
}
catch {
    Write-Log "Failed to connect to Exchange Online: $($_.Exception.Message)" "ERROR"
    throw
}
