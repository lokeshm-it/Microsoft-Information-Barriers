# Validation — Microsoft Purview Information Barriers

## Purpose

Document the multi-layer validation methodology used to confirm the Information Barrier control is not just configured, but actually enforced.

## Validation Layers

### Layer 1 — Portal Configuration Review

| Check | Evidence | Result |
|---|---|---|
| Finance Department segment exists with correct filter | `images/06`, `07` | Pass — `department -eq 'Finance'` |
| HR Department segment exists | `images/08` | Pass (filter details not captured — see README Step 8 note) |
| Finance-HR Block Policy configured: Assigned=Finance, Blocked=HR, Active, moderation off | `images/14` | Pass |
| Both directional policies show Active status | `images/16` | Pass |

### Layer 2 — Policy Application Status

| Check | Evidence | Result |
|---|---|---|
| Application job reaches Completed | `images/19` | Pass — Completed, 100%, end time `07/06/2026 04:32:43` |

### Layer 3 — PowerShell Verification

Command used:

```powershell
Get-EXOInformationBarrierRelationship -RecipientId1 "testuser1@securem365lsb.onmicrosoft.com" -RecipientId2 "testuser2@securem365lsb.onmicrosoft.com"
```

| Check | Evidence | Result |
|---|---|---|
| `testuser1` resolves to Finance Department segment | `images/20` | Pass |
| `testuser2` resolves to HR Department segment | `images/20` | Pass |
| `Communication1To2 = False` | `images/20` | Pass |
| `Communication2To1 = False` | `images/20` | Pass |
| `Visibility1To2 = False`, `Visibility2To1 = False` | `images/20` | Pass |
| `IsValid = True` | `images/20` | Pass |
| Result is stable on re-query | `images/21` | Pass — identical output |

### Layer 4 — Live Enforcement Test (Microsoft Teams)

| Check | Evidence | Result |
|---|---|---|
| Message from Finance-segment user to HR-segment user is rejected | `images/22` | Pass — "Failed to send" |

## Configuration Verification Command Reference

```powershell
# List all segments
Get-OrganizationSegment

# List all policies and their state
Get-InformationBarrierPolicy | Select-Object Name, State, AssignedSegment, SegmentsBlocked

# Confirm the latest policy application status
Get-InformationBarrierPoliciesApplicationStatus

# Confirm the computed relationship for a specific pair of users
Get-EXOInformationBarrierRelationship -RecipientId1 <UPN1> -RecipientId2 <UPN2>
```

## Result Summary

All four validation layers were consistent and passed. The control is confirmed **configured and enforced**, not merely configured. See [`../scripts/Validate-IBRelationship.ps1`](../scripts/Validate-IBRelationship.ps1) for a reusable script version of Layer 3.
