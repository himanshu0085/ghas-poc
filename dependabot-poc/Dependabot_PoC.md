# 🛡️ GHAS – Dependabot (Dependency Scanning) PoC
**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 21 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co  

---

## 📘 Table of Contents
- [What is Dependency Scanning?](#what-is-dependency-scanning)
- [Objective of This PoC 🎯](#objective-of-this-poc-)
- [Repository Setup 📁](#repository-setup-)
- [Add Vulnerable Dependencies ⚠️](#add-vulnerable-dependencies-️)
- [Enable Dependabot Security Updates ⚙️](#enable-dependabot-security-updates-️)
- [Expected Alerts 🚨](#expected-alerts-)
- [Apply Auto-Fix via Dependabot PR 🔧](#apply-auto-fix-via-dependabot-pr-)
- [Best Practices 📌](#best-practices-)
- [Conclusion 🏁](#conclusion-)

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
```

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
```

Commit & Push changes:

```bash
git add .
git commit -m "Added vulnerable dependencies for Dependabot PoC"
git push
```
---

## Enable Dependabot Security Updates ⚙️

Go to:
**Settings → Code security and analysis**

Enable:
- ✔ **Dependabot alerts**
- ✔ **Dependabot security updates**

<img width="1292" height="619" alt="image" src="https://github.com/user-attachments/assets/c74da134-6937-4ed8-b061-9d12d09436ba" />
<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/f5bedad4-d3e7-495a-857e-743be881f8aa" />



---

## Expected Alerts 🚨

Dependabot will detect two vulnerabilities:

| Package | Version | Issue | Severity | Fix |
|---------|---------|-------|----------|-----|
| lodash  | 4.17.19 | Prototype Pollution | ❌ High | Upgrade to ≥ 4.17.21 |
| axios   | 0.21.0  | SSRF Vulnerability | ❌ High | Upgrade to ≥ 0.21.1 |

View them in:
➡ **Security → Dependabot → Alerts**
<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/45779eaa-beb8-4f85-8fee-b4ffeab9e84e" />
<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/54b0858e-2046-4f63-9acf-84b3e11ee1a9" />

---

## Apply Auto-Fix via Dependabot PR 🔧

Dependabot will automatically generate:

- 📌 PR #1 — Upgrade **lodash**
- 📌 PR #2 — Upgrade **axios**

<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/0b8d773f-7d0b-491a-bab1-d0ad50c59d08" />
<img width="1056" height="572" alt="image" src="https://github.com/user-attachments/assets/548869a7-301d-46a0-98a0-c18d8cf81892" />
<img width="1073" height="553" alt="image" src="https://github.com/user-attachments/assets/fb1cacdf-f6d7-4fa1-9915-8c7048a27752" />



✔ Your tasks:
- Review both PRs  
- Merge to the main branch  
- Confirm GitHub checks pass  

<img width="1075" height="564" alt="image" src="https://github.com/user-attachments/assets/bb4ba953-e0d7-4cc6-96e3-7709e3ab13a0" />


➡ After merging:
- ✔ Alerts marked **Resolved**
- ✔ Dependency tree becomes secure

<img width="1270" height="598" alt="image" src="https://github.com/user-attachments/assets/1d0424ba-52a4-4871-addf-824a27bcec0c" />

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
