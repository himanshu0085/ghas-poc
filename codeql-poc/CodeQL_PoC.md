# 🛡 Code Scanning PoC (CodeQL)
**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 20 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co  

---

## 📘 Table of Contents
- [Understanding CodeQL](#understanding-codeql)
- [Objective of This PoC](#objective-of-this-poc)
- [Repository Setup](#repository-setup)
- [Introducing Vulnerabilities](#introducing-vulnerabilities)
- [Enable CodeQL Code Scanning](#enable-codeql-code-scanning)
- [Expected Alerts](#expected-alerts)
- [Fixing Vulnerabilities](#fixing-vulnerabilities)
- [Alert Resolution](#alert-resolution)
- [Best Practices](#best-practices)

---

## Understanding CodeQL
CodeQL is the static analysis engine used by **GitHub Advanced Security** to detect security vulnerabilities in codebases.  
Developers can **query code like a database**, identifying patterns that could lead to:

- SQL injection
- XSS attacks
- Hardcoded secrets
- Lack of rate limiting
- Command injection & more

CodeQL scanning can be executed:
✔ Locally with CodeQL CLI  
✔ On GitHub via CodeQL workflow  
✔ Through GitHub API  

---

## Objective of This PoC
- Introduce vulnerable application code
- Configure CodeQL workflow in GitHub
- Trigger scan via push event
- Validate alerts shown in **Security → Code Scanning**
- Apply secure fixes
- Confirm alerts marked **resolved** after mitigation

---

## Repository Setup

Folder structure added:

codeql-poc/
└── app.js


Initial vulnerable code committed to repo.

📌 Repo: https://github.com/himanshu0085/ghas-poc

---

## Introducing Vulnerabilities
`codeql-poc/app.js` — intentionally insecure:

- ❌ SQL Injection  
- ❌ Cross-Site Scripting (XSS)  
- ❌ Hardcoded secret  
- ❌ Missing rate limiting  

📎 Screenshot Placeholder → **Add Code here from GitHub UI**

---

## Enable CodeQL Code Scanning

1️⃣ Go to **Security** tab  
2️⃣ Under **Code Scanning**, Click **Set up CodeQL**  
3️⃣ Select **Default Configuration**  
4️⃣ Commit workflow file:

📍 `.github/workflows/codeql.yml`

📸 Screenshot Placeholder → CodeQL Workflow added

---

## Expected Alerts

After workflow runs, CodeQL will report vulnerabilities:

| Vulnerability | Severity | Expected Alert |
|--------------|----------|----------------|
| SQL Injection | High | ✔ Yes |
| XSS | Medium | ✔ Yes |
| Hardcoded Secret | High | ✔ Yes |
| Missing rate limiting | Medium | ✔ Yes |

📸 Screenshot Placeholder → CodeQL Alerts Screen
📸 Screenshot Placeholder → Individual alert with description

---

## Fixing Vulnerabilities

A secure version was created:

📌 `codeql-poc/app-secure.js`

Mitigations included:

| Issue Fixed | Method Used |
|------------|-------------|
| SQL Injection | Parameterized query |
| XSS | HTML input escaping |
| Hardcoded Secret | Environment variables |
| Missing Rate Limiting | Added global rate limiter |

📸 Screenshot Placeholder → Pull request / commit with fix

---

## Alert Resolution

After remediation push:

✔ CodeQL rescans automatically  
✔ Alerts update to **Resolved** or can be manually closed  
✔ Select valid closure reason (e.g., “Fixed”)  

📸 Screenshot Placeholder → Alert marked resolved

---

## Best Practices
- Enable **branch protection rules** to block merging vulnerable code  
- Use **Copilot Security** to auto-fix common vulnerabilities  
- Expand CodeQL queries for custom security rules  
- Include CodeQL scans in all CI/CD pipelines  
- Monitor Security dashboard for regression alerts  

---

> 🏁 Result: Code Scanning (CodeQL) PoC successfully implemented with real alert → fix → resolution workflow.

**Next Step:** Dependabot PoC → introducing vulnerable dependency and validating auto-remediation.
