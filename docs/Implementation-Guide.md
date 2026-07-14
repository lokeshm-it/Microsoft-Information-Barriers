# Implementation Guide — Microsoft Purview Information Barriers

## Purpose

Step-by-step reproduction guide for configuring the same Finance ↔ HR Information Barrier control demonstrated in this repository, written for an administrator following along in their own tenant.

## Prerequisites

- Microsoft Purview compliance portal access with Compliance Administrator (or higher) role
- Exchange Online PowerShell module (`ExchangeOnlineManagement`) for verification
- A directory attribute (this lab used `Department`) populated on the target user accounts
- Appropriate Purview licensing (see README → Licensing Requirements)

## Configuration Steps

### 1. Create Segments

1. Go to **Microsoft Purview portal → Solutions → Information Barriers → Segments**.
2. Select **New segment**.
3. Provide a **Name** (e.g., `Finance Department`).
4. Add a **User group filter** condition — attribute, operator, and value (e.g., `Department Equal Finance`).
5. Review the compiled filter on the Summary screen (e.g., `department -eq 'Finance'`) and **Submit**.
6. Repeat for each additional segment required (e.g., `HR Department`).

**Evidence in this repository:** `images/04`–`08`.

### 2. Create Directional Policies

1. Go to **Information Barriers → Policies → Create policy**.
2. Provide a **Name** describing the direction (e.g., `Finance-HR Block Policy`).
3. Choose the **Assigned segment** — the segment this policy governs (e.g., `Finance Department`).
4. Set **Communication and collaboration** to `Blocked`, and choose the segment to block against (e.g., `HR Department`).
5. Leave **Allow moderation** unchecked unless a moderated exception is required.
6. Set **Policy status** to `Active`.
7. Review the Summary screen and **Submit**.
8. **Repeat in the reverse direction** — create a second policy (e.g., `HR-Finance Block Policy`) with the assigned/blocked segments swapped, to achieve a true bidirectional barrier.

> A single policy only blocks the assigned segment's outbound communication toward the blocked segment. A one-directional policy alone does **not** create a mutual barrier.

**Evidence in this repository:** `images/09`–`16`.

### 3. Apply Policies

1. Policies are applied automatically on a schedule, or can be applied on demand via:
   ```powershell
   Start-InformationBarrierPoliciesApplication
   ```
2. Monitor progress at **Information Barriers → Policies → Policy applications**, or via:
   ```powershell
   Get-InformationBarrierPoliciesApplicationStatus
   ```
3. Wait until **Status = Completed** and **Progress = 100** before validating enforcement. In this lab, the job progressed `ApplyInProgress (0%)` → `PendingCompletion (100%)` → `Completed (100%)` over approximately 4–5 minutes.

**Evidence in this repository:** `images/17`–`19`.

### 4. Verify via PowerShell

```powershell
Connect-ExchangeOnline -UserPrincipalName admin@yourtenant.onmicrosoft.com

Get-EXOInformationBarrierRelationship -RecipientId1 "user1@yourtenant.onmicrosoft.com" -RecipientId2 "user2@yourtenant.onmicrosoft.com"
```

Confirm:
- `IBSegmentDisplayName1` / `IBSegmentDisplayName2` resolve to the expected segments.
- `Communication1To2` and `Communication2To1` are both `False` for a bidirectional block.
- `IsValid` is `True`.

**Evidence in this repository:** `images/20`, `images/21`.

### 5. Validate in Microsoft Teams

1. Sign in as a user from the assigned/blocked segment pair.
2. Open (or start) a 1:1 chat with a user from the opposing segment.
3. Attempt to send a message.
4. Expected result once the policy is fully applied: the message shows **"Failed to send"**.

**Evidence in this repository:** `images/22`.

## Best Practices

See [`Best-Practices.md`](Best-Practices.md).

## Security Notes

- Always test with clearly named pilot/test accounts (as this lab did with `Test User 1` / `Test User 2`) before applying to production department segments.
- Confirm policy application status is `Completed` before communicating the control as "live" to stakeholders or auditors.

## Troubleshooting

See [`Troubleshooting.md`](Troubleshooting.md).
