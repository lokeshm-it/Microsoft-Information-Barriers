# Changelog

All notable changes to this repository are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses date-based entries (lab-driven, not semantic versioning).

## [1.0.0] - 2026-07-08

### Added
- Initial repository build: README.md with full implementation walkthrough (22 screenshot-backed steps)
- `docs/` — Architecture, Implementation-Guide, Validation, Troubleshooting, Lessons-Learned, Best-Practices, References
- `scripts/` — Connect-ExchangeOnline.ps1, Verify-InformationBarrier.ps1, Validate-IBRelationship.ps1
- `architecture/` — Architecture.mmd, Workflow.mmd, PolicyFlow.mmd (Mermaid)
- `images/` — 22 screenshots documenting segment creation, policy creation, policy application, PowerShell verification, and Teams enforcement testing
- LICENSE, CONTRIBUTING.md, SECURITY.md

### Lab Timeline (from screenshot evidence)
- 2026-07-04 — Finance Department and HR Department segments created; Finance-HR Block Policy created and set Active
- 2026-07-06 — HR-Finance Block Policy created and set Active; policy application job run (04:28–04:32) and reached Completed
- PowerShell verification and Microsoft Teams enforcement test performed following policy application completion
