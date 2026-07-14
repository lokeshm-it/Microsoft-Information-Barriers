# Lessons Learned — Microsoft Purview Information Barriers

## Policy application is asynchronous — plan validation timing accordingly

The policy application job in this lab took roughly 4–5 minutes to move from `ApplyInProgress` to `Completed` (`images/17`–`19`). Any validation attempted before `Completed` would have produced a misleading result — either a false sense that the control isn't working, or (more dangerously) a false sense that it is not yet needed to be checked again. **Takeaway:** always gate validation activities on the application job status, not on policy `Active` status alone.

## Bidirectional barriers require two policies, not one

A single Information Barrier policy only blocks the *assigned* segment's communication toward the *blocked* segment — it does not automatically create a mutual barrier. This lab confirmed both `Finance-HR Block Policy` and `HR-Finance Block Policy` were required and Active (`images/16`) to achieve `Communication1To2: False` **and** `Communication2To1: False` in the PowerShell output (`images/20`). **Takeaway:** when designing IB policies, always map out both directions explicitly rather than assuming symmetry.

## PowerShell verification and client-side testing tell different stories

`Get-EXOInformationBarrierRelationship` confirms what the system has *computed* — it does not, by itself, prove the client is *enforcing* it. Only the live Teams chat attempt (`images/22`, "Failed to send") proved end-to-end enforcement. **Takeaway:** treat PowerShell output as configuration proof and a real client-side test as enforcement proof — a complete validation needs both.

## Segment accuracy depends entirely on directory attribute hygiene

Segments in this lab were built on a single `Department` attribute filter (`department -eq 'Finance'`, confirmed in `images/06`). If that attribute is inconsistently populated across the user directory, segment membership — and therefore policy enforcement — will silently be wrong for affected users. **Takeaway:** Information Barriers should never be treated as more reliable than the underlying HR/directory attribute feeding it.

## Documentation discipline matters when evidence is incomplete

Not every configuration screen was captured in this lab (e.g., the HR Department segment's filter screen, and the HR-Finance Block Policy's creation wizard). Rather than guessing or reconstructing these from assumption, this repository explicitly marks them as **"Not configured in this lab"** / not captured, while still using independently confirmed evidence (the PowerShell relationship output) to establish what can be trusted. **Takeaway:** a credible technical portfolio should distinguish clearly between what was directly observed and what is inferred or assumed.
