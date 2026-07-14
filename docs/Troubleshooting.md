# Troubleshooting — Microsoft Purview Information Barriers

## Purpose

Common issues encountered when configuring, applying, and validating Information Barriers, based on the behavior observed in this lab plus standard Microsoft guidance.

## Issue: Policy application stuck at "ApplyInProgress"

**Observed in this lab:** the job showed `ApplyInProgress` at `0%` progress immediately after policies were created/edited (`images/17`).

**Cause:** Policy application is an asynchronous, tenant-wide job. It does not complete instantly.

**Resolution:** Wait and re-check the **Policy applications** page or run `Get-InformationBarrierPoliciesApplicationStatus`. In this lab, the job moved to `PendingCompletion (100%)` and then `Completed (100%)` within roughly 4–5 minutes (`images/18`, `19`). Do not conclude the configuration is broken based on an in-progress job alone.

## Issue: Users can still communicate after creating a policy

**Cause:** The policy was created/edited but the policy application job has not yet run or completed.

**Resolution:** Confirm the policy `State` is `Active`, then either wait for the scheduled application cycle or run:

```powershell
Start-InformationBarrierPoliciesApplication
```

Re-verify with `Get-InformationBarrierPoliciesApplicationStatus` until `Completed`.

## Issue: `Get-EXOInformationBarrierRelationship` shows the wrong segment for a user

**Cause:** The directory attribute used as the segment filter (e.g., `Department`) is not populated, mismatched in case/spelling, or not synced correctly to Exchange Online / Azure AD.

**Resolution:** Correct the attribute on the user object, re-run the policy application, and re-verify.

## Issue: Teams still shows prior chat history between blocked users

**Cause:** This is expected behavior. Information Barriers block **new** communication and collaboration going forward — they do not retroactively remove existing chat history, files, or shared content.

**Resolution:** No action needed; this is by design. If historical content must also be addressed, that requires a separate eDiscovery/records management action, which is `Not configured in this lab`.

## Issue: A message shows "Failed to send" but no clear reason is given in the Teams client

**Observed in this lab:** `images/22` shows a generic **"Failed to send."** label with a red warning icon — the Teams client does not explicitly say "blocked by Information Barriers" in the UI.

**Resolution:** Cross-verify with `Get-EXOInformationBarrierRelationship` (as in `images/20`, `21`) to confirm the failure is due to an Information Barrier policy and not an unrelated network/service issue.

## Issue: One-directional block instead of the expected bidirectional block

**Cause:** Only one directional policy was created (e.g., `Finance-HR Block Policy` blocking Finance→HR) without its mirror policy (`HR-Finance Block Policy`).

**Resolution:** Confirm both `Communication1To2` and `Communication2To1` are `False` via PowerShell. If only one is `False`, create/enable the missing directional policy and re-apply.

## General Diagnostic Checklist

1. Are both segments correctly populated (`Get-OrganizationSegment`)?
2. Are both directional policies `Active` (`Get-InformationBarrierPolicy`)?
3. Has the policy application job reached `Completed` (`Get-InformationBarrierPoliciesApplicationStatus`)?
4. Does `Get-EXOInformationBarrierRelationship` show the expected `Communication1To2`/`Communication2To1` values?
5. Does the client (Teams) enforce the expected behavior in a live test?
