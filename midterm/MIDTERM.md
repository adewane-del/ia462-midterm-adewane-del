
# IA 462 Midterm — Threat Model and Cross-Platform Hardening Comparison

## 1. Repository Overview

This repository contains my IA 462 Advanced Operating Systems Security & Administration midterm project, focusing on operating system hardening, vulnerability management, and software supply-chain security across Linux, Windows, and Docker. Throughout this project, I configured Linux and Windows security controls, built and hardened a Python Flask application using Docker, and performed vulnerability assessments using Trivy, Syft, and Grype. I also implemented enterprise security policies, developed a Sigma detection rule to identify suspicious Windows account creation, and configured GitHub Actions workflows to automate dependency auditing and container security scanning. The repository includes configuration files, security reports, screenshots, and evidence demonstrating how security controls can detect vulnerable dependencies before they are merged into the main branch.

## 2. Cross-Platform Hardening Comparison

| Category | Linux | Windows | Docker |
|---|---|---|---|
| Kernel Model | Monolithic Linux kernel with support for loadable modules. | Hybrid Windows NT kernel with separate user and kernel modes. | Containers share the host's Linux kernel and use namespaces for isolation. |
| Access Control | User and group permissions, sudo, PAM, and AppArmor or SELinux. | NTFS permissions, access control lists (ACLs), User Account Control, and Group Policy. | Non-root users, Linux capabilities, seccomp profiles, and read-only filesystems. |
| Auditing | System logs, authentication logs, auditd, and Lynis security assessments. | Windows Event Logs, Sysmon, advanced audit policies, and PowerShell logging. | Docker logs, Docker Bench, and image vulnerability scanners such as Trivy and Grype. |
| Hardening Standard | CIS Linux Benchmarks and applicable DISA STIGs. | CIS Windows Benchmarks, Microsoft security baselines, and DISA STIGs. | CIS Docker Benchmark and container hardening best practices. |
| Common Attack Surface | SSH, SUID binaries, unnecessary services, weak permissions, and outdated packages. | SMB, PowerShell, credential theft, remote access, and vulnerable services. | Vulnerable container images, excessive privileges, exposed ports, and Docker socket access. |

Linux, Windows, and Docker use different security mechanisms, but all three depend on least privilege, auditing, and reducing unnecessary attack surfaces. Linux emphasizes file permissions and system configuration, while Windows relies on access control policies, centralized administration, and detailed event logging. Docker uses Linux kernel isolation and requires additional restrictions to minimize the impact of a compromised application.

**Lecture References:** Week 3 — Operating Systems Fundamentals, Docker, Windows and Linux; Week 4 — Comparing Policy Frameworks Across Platforms; Week 5 — Cross-Platform Comparison: Security Controls at a Glance.

## 3. Supply-Chain Threat Model

The main assets in this project are the Python Flask application, its dependencies, the Docker image, the GitHub repository, and the CI/CD workflows. An attacker could attempt to introduce vulnerable dependencies, manipulate software packages, compromise the build process, or exploit excessive container privileges. The security controls implemented throughout this midterm provide multiple layers of prevention, detection, and risk reduction.

| Potential Attack | Security Control | How the Control Addresses the Threat | Lecture Reference |
|---|---|---|---|
| Introduce a vulnerable Flask dependency through a pull request. | pip-audit and GitHub Dependency Review. | Detects known vulnerabilities in dependency changes. The temporary Flask 2.0.0 pull request triggered failures in both security checks. | Week 8 — GitHub's Dependency Review Action |
| Replace a Python dependency with an unexpected package artifact. | Exact version pinning and SHA-256 hashed lockfiles. | Hash verification restricts installations to packages matching the recorded hashes, helping prevent unauthorized package substitution. | Week 8 — Pinning vs. Floating Dependencies |
| Modify a Docker image tag to reference a different base image. | SHA-256 digest-pinned base image. | Ensures the build references a specific image digest instead of relying solely on a mutable image tag. | Week 4 — Docker: Supply Chain Attacks & The Trivy Incident (March 2026) |
| Introduce vulnerable packages into the Docker image. | Trivy, Syft, and Grype. | Identifies known vulnerabilities and generates an SBOM to document installed packages. Findings can then be investigated and remediated. | Week 5 — Docker: Threat Intelligence Techniques |
| Exploit the Flask application to gain excessive container privileges. | Non-root execution, read-only filesystem, dropped capabilities, no-new-privileges, and seccomp restrictions. | Limits container permissions and reduces the potential impact of a compromised application. | Week 4 — Docker: Runtime Security & Least Privilege |
| Compromise or unexpectedly change a third-party GitHub Action. | GitHub Actions pinned to full commit SHAs. | Prevents mutable version tags from silently changing which action revision the workflow executes. | Week 8 — Securing Dependencies in GitHub Actions |
| Introduce vulnerable dependency updates without review. | Dependabot and automated dependency auditing. | Identifies available dependency updates and detects known vulnerabilities so changes can be evaluated before adoption. | Week 8 — GitHub Dependency Security Tools |

### Security Testing and Remaining Risks

To demonstrate dependency vulnerability detection, I created a temporary pull request that downgraded Flask from version 3.1.3 to version 2.0.0. Both the Python Dependency Audit and Dependency Review Gate failed, while the Docker Security and SBOM job succeeded. I closed the vulnerable pull request without merging it, leaving the secure Flask version on the main branch.

Although these controls improve supply-chain security, they cannot eliminate every risk. Vulnerability scanners detect known issues but do not automatically remediate them. In addition, the Trivy workflow currently reports image vulnerabilities without failing the job, and required GitHub status checks must be enforced through branch protection to prevent merging vulnerable changes.

## 4. Course Learning Objectives Crosswalk

The following sections demonstrate how the practical work completed in this midterm relates to the course objectives listed in the IA 462 syllabus.

- **Section 1 — Linux Host Hardening:** Addresses the objective "Implement Windows and Linux best practices to protect against Supply Chain Attacks." I applied Linux security measures involving user permissions, SSH configuration, PAM authentication, service management, and Lynis auditing to reduce system vulnerabilities and unauthorized access risks.

- **Section 2 — Windows Baseline and Event Log Analysis:** Also addresses "Implement Windows and Linux best practices to protect against Supply Chain Attacks." I evaluated Microsoft Defender, Windows Firewall, SMBv1 configuration, Sysmon, and Windows Security events to demonstrate operating system hardening and security monitoring.

- **Section 3 — Docker Hardened Build and Runtime Controls:** Addresses "Apply enterprise patch and policy management for Docker Containers, including container hardening" and "Utilize Supply Chain Security Techniques across Windows, Linux, and Docker container environments." I implemented a multi-stage Dockerfile, digest-pinned base image, non-root execution, and runtime restrictions using seccomp, dropped capabilities, and a read-only filesystem.

- **Section 4 — Vulnerability Scanning and SBOM:** Addresses "Understand and integrate Software Bill of Materials (SBOM) into Docker Container workflows" and the vulnerability assessment portion of "Perform Vulnerability Management: scan, patch, and retest continuously using CI/CD techniques in GitHub." I generated an SPDX JSON SBOM with Syft, scanned the Docker image using Trivy and Grype, and investigated a reported CVE with a proposed remediation process.

- **Section 5 — Enterprise Policy Enforcement:** Supports "Apply enterprise patch and policy management for Docker Containers, including container hardening" and "Utilize Supply Chain Security Techniques across Windows, Linux, and Docker container environments." I evaluated the Docker environment against CIS Benchmark recommendations using Docker Bench and created a Sigma detection rule for Windows Event ID 4720, corresponding to MITRE ATT&CK technique T1136.

- **Section 6 — Dependency Pinning and GitHub Security Automation:** Addresses "Apply Dependency Pinning, Version Control, and Hashing to reduce surprise supply chain attacks," "Configure and manage third-party security scanners within a GitHub CI/CD pipeline," and the continuous scanning aspect of "Perform Vulnerability Management: scan, patch, and retest continuously using CI/CD techniques in GitHub." I configured exact Python dependency versions, SHA-256 hashed lockfiles, Dependabot, SHA-pinned GitHub Actions, and automated Trivy, Syft, and pip-audit checks. I also demonstrated that the dependency security checks detected a vulnerable Flask downgrade in a temporary pull request.

Together, these six sections demonstrate how security hardening, auditing, vulnerability management, dependency integrity, and automated GitHub workflows contribute to a layered supply-chain security strategy.
