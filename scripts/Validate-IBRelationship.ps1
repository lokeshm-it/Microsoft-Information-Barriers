<#
.SYNOPSIS
    Validates the computed Information Barrier relationship between two recipients.

.DESCRIPTION
    Wraps Get-EXOInformationBarrierRelationship to confirm whether communication and
    visibility are blocked or allowed between two specific recipients, and prints a
    clear pass/fail style summary. This is the script-based equivalent of the manual
    verification performed in this repository's README (Step 20 / Step 21), and is
    intended to be reusable for any two recipients/segments — not just the
    Finance/HR test pairing documented in the lab.

.PARAMETER RecipientId1
    UPN or recipient identity of the first user (e.g., testuser1@securem365lsb.onmicrosoft.com).

.PARAMETER RecipientId2
    UPN or recipient identity of the second user (e.g., testuser2@securem365lsb.onmicrosoft.com).

.EXAMPLE
    .\Validate-IBRelationship.ps1 -RecipientId1 "testuser1@securem365lsb.onmicrosoft.com" -RecipientId2 "testuser2@securem365lsb.onmicrosoft.com"

.NOTES
    Author:  Lokesh Karnam
    Purpose: Microsoft Purview Information Barriers — Project 16
    Requires: Active Exchange Online PowerShell session (Connect-ExchangeOnline.ps1)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$RecipientId1,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$RecipientId2
)

$ErrorActionPreference = 'Stop'

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Level] $Message"
}

try {
    $session = Get-ConnectionInformation -ErrorAction SilentlyContinue
    if (-not $session) {
        Write-Log "No active Exchange Online session detected. Run Connect-ExchangeOnline.ps1 first." "ERROR"
        throw "Not connected to Exchange Online."
    }

    Write-Log "Querying Information Barrier relationship between '$RecipientId1' and '$RecipientId2'..."

    $relationship = Get-EXOInformationBarrierRelationship -RecipientId1 $RecipientId1 -RecipientId2 $RecipientId2 -ErrorAction Stop

    if (-not $relationship) {
        Write-Log "No relationship data returned. Verify both recipient identities are correct and licensed for Information Barriers." "ERROR"
        return
    }

    $relationship | Format-List | Out-String | Write-Host

    Write-Log "----- Relationship Summary -----"
    Write-Log ("{0} -> Segment: {1}" -f $RecipientId1, $relationship.IBSegmentDisplayName1)
    Write-Log ("{0} -> Segment: {1}" -f $RecipientId2, $relationship.IBSegmentDisplayName2)

    if ($relationship.Communication1To2 -eq $false -and $relationship.Communication2To1 -eq $false) {
        Write-Log "RESULT: Communication is BLOCKED in both directions. Bidirectional barrier is enforced." "SUCCESS"
    }
    elseif ($relationship.Communication1To2 -eq $false -or $relationship.Communication2To1 -eq $false) {
        Write-Log "RESULT: Communication is blocked in only ONE direction. This is a one-way barrier — confirm this is intentional." "WARN"
    }
    else {
        Write-Log "RESULT: Communication is ALLOWED in both directions. No barrier is currently enforced between these recipients." "WARN"
    }

    if (-not $relationship.IsValid) {
        Write-Log "WARNING: IsValid = False. The relationship record may be stale or the policy application may not have completed. Re-run Verify-InformationBarrier.ps1 to check application status." "WARN"
    }
}
catch {
    Write-Log "Validation failed: $($_.Exception.Message)" "ERROR"
    throw
}
