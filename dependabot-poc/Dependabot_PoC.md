# 🛡️ GHAS – Dependabot (Dependency Scanning) PoC
**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 21 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co  

---

## 📘 Table of Contents
- [What is Dependency Scanning?](#what-is-dependency-scanning)
- [Objective of This PoC](#objective-of-this-poc)
- [Repository Setup](#repository-setup)
- [Add Vulnerable Dependencies](#add-vulnerable-dependencies)
- [Enable Dependabot Security Updates](#enable-dependabot-security-updates)
- [Expected Alerts](#expected-alerts)
- [Apply Auto-Fix via Dependabot PR](#apply-auto-fix-via-dependabot-pr)
- [Best Practices](#best-practices)

---

## What is Dependency Scanning?
GitHub Dependabot scans dependencies for known vulnerabilities using the **GitHub Advisory Database**.

It:
- Detects security vulnerabilities (CVEs)
- Alerts the developer in GitHub Security tab
- Suggests or auto-creates PRs to upgrade packages

---

## Objective of This PoC 🎯
- Introduce **vulnerable npm dependencies**
- Trigger Dependabot alerts
- Apply recommended fixes via PR
- Validate remediation in GitHub UI

---

## Repository Setup 📁

Create new folder inside repo:

ghas-poc/
└── dependabot-poc/
├── package.json
└── index.js


Initialize a basic Node.js project:

```bash
cd dependabot-poc
npm init -y

---

## Add Vulnerable Dependencies ⚠️

Edit `package.json`:

```json
{
  "name": "dependabot-poc",
  "version": "1.0.0",
  "dependencies": {
    "lodash": "4.17.19",
    "axios": "0.21.0"
  }
}

Create `index.js`:

```javascript
console.log("Dependabot scanning PoC running...");

Commit & Push changes:

```bash
git add .
git commit -m "Added vulnerable dependencies for Dependabot PoC"
git push

---

## Enable Dependabot Security Updates ⚙️

Go to:
**Settings → Code security and analysis**

Enable:
- ✔ **Dependabot alerts**
- ✔ **Dependabot security updates**

---

## Expected Alerts 🚨

Dependabot will detect two vulnerabilities:

| Package | Version | Issue | Severity | Fix |
|---------|---------|-------|----------|-----|
| lodash  | 4.17.19 | Prototype Pollution | ❌ High | Upgrade to ≥ 4.17.21 |
| axios   | 0.21.0  | SSRF Vulnerability | ❌ High | Upgrade to ≥ 0.21.1 |

View them in:
➡ **Security → Dependabot → Alerts**

---

## Apply Auto-Fix via Dependabot PR 🔧

Dependabot will automatically generate:

- 📌 PR #1 — Upgrade **lodash**
- 📌 PR #2 — Upgrade **axios**

✔ Your tasks:
- Review both PRs  
- Merge to the main branch  
- Confirm GitHub checks pass  

➡ After merging:
- ✔ Alerts marked **Resolved**
- ✔ Dependency tree becomes secure

---

## Best Practices 📌

| Best Practice | Why |
|--------------|-----|
| Monitor alerts daily | Faster remediation |
| Enable auto-security updates | Avoid outdated dependencies |
| Apply least privilege to workflows | Reduce dependency-based attacks |
| Use version pinning | Prevent unexpected breaking changes |
| Combine with CodeQL + Secret Scanning | Full SDLC protection |

---

## Conclusion 🏁

This PoC confirms:

- 🔐 Dependabot correctly identified vulnerable dependencies  
- 🔔 Alerts were visible inside GitHub Security Dashboard  
- 🔧 Auto-generated PRs patched vulnerabilities  
- 🛡 The application security posture improved  

---
