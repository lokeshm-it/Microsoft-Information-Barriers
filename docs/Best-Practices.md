# Best Practices — Microsoft Purview Information Barriers

## Segment Design

- Base segments on a single, authoritative, well-governed directory attribute (e.g., `Department`, synced from an HR system) rather than manually maintained group membership.
- Use clear, descriptive segment names that match the business unit exactly (this lab used `Finance Department` / `HR Department`) to avoid ambiguity in audit reports.
- Document the exact compiled filter expression (visible on the segment wizard Summary screen, e.g., `department -eq 'Finance'`) for every segment as part of change records.

## Policy Design

- Always design Information Barrier policies in **pairs** when a mutual/bidirectional barrier is the business requirement — a single directional policy is a one-way block only.
- Use policy names that make the direction explicit (`Finance-HR Block Policy` vs. `HR-Finance Block Policy`) rather than a single ambiguous name for both directions.
- Leave **Allow moderation** disabled unless there is a specific, approved business exception process that requires a moderator role to bridge the barrier.
- Set policies to `Active` only after the assigned/blocked segments have been reviewed and confirmed correct — an Active policy with a wrong segment can incorrectly block legitimate business communication.

## Rollout and Change Management

- Pilot with a small number of clearly labeled test accounts (as this lab did with `Test User 1` / `Test User 2`) before applying to full production department segments.
- Always confirm the policy application job reaches `Completed` (via the Policy applications page or `Get-InformationBarrierPoliciesApplicationStatus`) before communicating the control as live to stakeholders.
- Treat policy application as a change with a defined maintenance/validation window, since propagation is not instantaneous (observed ~4–5 minutes in this lab; production tenants may vary).

## Validation

- Validate at multiple layers: portal configuration, policy application status, PowerShell relationship query, and a live client-side test — do not rely on any single layer alone.
- Re-run PowerShell verification after any segment or policy change, not just after the initial rollout.
- Keep PowerShell output as auditable evidence (e.g., exported transcripts) for compliance and audit purposes.

## Operational Governance

- Assign ownership of the source directory attribute (e.g., `Department`) to a specific team (typically HR/IT identity operations) so that segment drift is caught early.
- Periodically re-run `Get-InformationBarrierPolicy` and `Get-OrganizationSegment` as part of a recurring compliance review, not just at initial deployment.
- Pair Information Barriers with Microsoft Purview Communication Compliance and/or Insider Risk Management for defense-in-depth around sensitive internal communications, rather than relying on Information Barriers as a sole control.
