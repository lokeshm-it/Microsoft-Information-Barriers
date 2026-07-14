# Security Policy

## Nature of This Repository

This repository documents a Microsoft Purview Information Barriers configuration performed in a **non-production sandbox tenant** (`securem365lsb.onmicrosoft.com`) using clearly labeled test accounts (`Test User 1`, `Test User 2`, `testuser1@...`, `testuser2@...`, `admin365 lab`). No production tenant data, real employee data, customer data, or production credentials are included anywhere in this repository.

## Sensitive Data Handling

- Object GUIDs shown in PowerShell output (e.g., `IBSegment1`, `RecipientName1`) are sandbox-tenant identifiers with no external validity or reuse risk.
- No passwords, connection strings, API keys, certificates, or tokens are included in any script or screenshot in this repository.
- All PowerShell scripts in `scripts/` require interactive, MFA-capable sign-in via `Connect-ExchangeOnline` — no credentials are hardcoded or stored in this repository.

## Reporting a Security Issue

If you believe you have found a security issue related to this repository (for example, an accidentally committed secret, or a script that could be misused), please:

1. Do **not** open a public GitHub issue describing the vulnerability in detail.
2. Contact the repository owner directly at **lokeshkarnam007@gmail.com** with a description of the issue.
3. Allow reasonable time for the issue to be reviewed and addressed before any public disclosure.

## Scope Limitations

This repository is documentation and reusable PowerShell tooling for a compliance/governance control (Information Barriers). It is not a security scanning tool, does not process live production data, and should not be treated as a certified or audited security product. Organizations implementing Information Barriers based on this repository should validate the configuration against their own compliance, legal, and security requirements before production rollout.
