# Contributing

This repository is a personal Microsoft 365 / Microsoft Purview infrastructure portfolio project, maintained by Lokesh Karnam as part of a Senior Infrastructure Engineer GitHub portfolio.

## Scope

This repository documents a specific, evidence-backed lab implementation of Microsoft Purview Information Barriers. Contributions should stay within that scope — improvements to clarity, accuracy, formatting, additional PowerShell tooling, or corrections to Microsoft Learn references are welcome.

## How to Contribute

1. Fork the repository.
2. Create a feature branch (`git checkout -b improve/troubleshooting-section`).
3. Make your changes. If adding new configuration claims or evidence, include the supporting screenshot or command output in `images/` and reference it explicitly — this repository's core principle is **no undocumented/fabricated configuration**.
4. Test any PowerShell script changes against a non-production tenant.
5. Submit a pull request with a clear description of the change and why it improves the documentation.

## Documentation Standards

- Every configuration claim in `README.md` and `docs/` must reference a specific screenshot in `images/` or a specific PowerShell output.
- If a configuration detail is not visible in available evidence, it must be explicitly marked as **"Not configured in this lab"** rather than assumed or invented.
- PowerShell scripts in `scripts/` should include comment-based help, parameter validation, and error handling consistent with the existing scripts.
- Mermaid diagrams in `diagrams/` should stay synchronized with any changes to the documented architecture or workflow.

## Code of Conduct

Be respectful and constructive. This is a professional portfolio repository intended to demonstrate real enterprise practices — contributions should reflect that standard.
