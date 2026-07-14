<#
.SYNOPSIS
    Verifies Microsoft Purview Information Barriers segment and policy configuration.

.DESCRIPTION
    Retrieves all configured Information Barrier segments and policies from Exchange
    Online / Microsoft Purview, and reports the most recent policy application job
    status. Intended as a quick, read-only health check to confirm segments and
    policies exist and are Active, and that the last policy application completed
    successfully, before relying on or demonstrating the control.

    This script assumes an active Exchange Online PowerShell session
    (see Connect-ExchangeOnline.ps1).

.PARAMETER PolicyNameFilter
    Optional. Filters displayed policies to those whose name contains this string
    (e.g., "Finance" or "HR").

.EXAMPLE
    .\Verify-InformationBarrier.ps1

.EXAMPLE
    .\Verify-InformationBarrier.ps1 -PolicyNameFilter "Finance"

.NOTES
    Author:  Lokesh Karnam
    Purpose: Microsoft Purview Information Barriers — Project 16
    Requires: Active Exchange Online PowerShell session (Connect-ExchangeOnline.ps1)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyNameFilter
)

$ErrorActionPreference = 'Stop'

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Level] $Message"
}

try {
    # Confirm an active Exchange Online session exists before proceeding
    $session = Get-ConnectionInformation -ErrorAction SilentlyContinue
    if (-not $session) {
        Write-Log "No active Exchange Online session detected. Run Connect-ExchangeOnline.ps1 first." "ERROR"
        throw "Not connected to Exchange Online."
    }

    Write-Log "Retrieving Information Barrier segments..."
    $segments = Get-OrganizationSegment -ErrorAction Stop

    if (-not $segments) {
        Write-Log "No segments found in this tenant." "WARN"
    }
    else {
        Write-Log "Found $($segments.Count) segment(s):"
        $segments | Select-Object Name, UserGroupFilter | Format-Table -AutoSize | Out-String | Write-Host
    }

    Write-Log "Retrieving Information Barrier policies..."
    $policies = Get-InformationBarrierPolicy -ErrorAction Stop

    if ($PolicyNameFilter) {
        $policies = $policies | Where-Object { $_.Name -like "*$PolicyNameFilter*" }
    }

    if (-not $policies) {
        Write-Log "No policies found matching the specified criteria." "WARN"
    }
    else {
        Write-Log "Found $($policies.Count) policy(ies):"
        $policies |
            Select-Object Name, State, AssignedSegment, SegmentsBlocked, SegmentAllowed |
            Format-Table -AutoSize | Out-String | Write-Host

        $inactive = $policies | Where-Object { $_.State -ne 'Active' }
        if ($inactive) {
            Write-Log "WARNING: $($inactive.Count) policy(ies) are not Active. Enforcement will not apply until these are Active and (re)applied." "WARN"
        }
        else {
            Write-Log "All returned policies are Active." "SUCCESS"
        }
    }

    Write-Log "Checking the status of the most recent policy application job..."
    $appStatus = Get-InformationBarrierPoliciesApplicationStatus -ErrorAction Stop

    if ($appStatus) {
        $appStatus | Select-Object -First 1 | Format-List | Out-String | Write-Host

        $latest = $appStatus | Select-Object -First 1
        if ($latest.Status -eq 'Completed') {
            Write-Log "Latest policy application job status: Completed. Policies are fully applied." "SUCCESS"
        }
        else {
            Write-Log "Latest policy application job status: $($latest.Status). Policies may not be fully enforced yet." "WARN"
        }
    }
    else {
        Write-Log "No policy application job history returned." "WARN"
    }
}
catch {
    Write-Log "Verification failed: $($_.Exception.Message)" "ERROR"
    throw
}
