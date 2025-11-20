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


---

## Expected Alerts

After workflow runs, CodeQL will report vulnerabilities:

| Vulnerability | Severity | Expected Alert |
|--------------|----------|----------------|
| SQL Injection | High | ✔ Yes |
| XSS | Medium | ✔ Yes |
| Hardcoded Secret | High | ✔ Yes |
| Missing rate limiting | Medium | ✔ Yes |

<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/da3bc3c2-434b-4086-a2b6-47907ebb2d7e" />

<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/f634762b-4270-4104-b64c-3554c5609abf" />

<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/82efb8bb-33ce-417e-8148-4c22442a7732" />



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

<img width="1284" height="594" alt="image" src="https://github.com/user-attachments/assets/4cd8c614-7928-4d39-b935-1ee84db32c0c" />

<img width="1284" height="594" alt="image" src="https://github.com/user-attachments/assets/f81e906c-6167-4d89-86b4-e289dba0024c" />

<img width="1284" height="594" alt="image" src="https://github.com/user-attachments/assets/eca1f6db-c04e-432e-af42-99729ad9e030" />

<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/c229678a-8723-49c1-b82c-5fdb5db629ea" />



---

## Alert Resolution

After remediation push:

✔ CodeQL rescans automatically  
✔ Alerts update to **Resolved** or can be manually closed  
✔ Select valid closure reason (e.g., “Fixed”)  



---

## Best Practices
- Enable **branch protection rules** to block merging vulnerable code  
- Use **Copilot Security** to auto-fix common vulnerabilities  
- Expand CodeQL queries for custom security rules  
- Include CodeQL scans in all CI/CD pipelines  
- Monitor Security dashboard for regression alerts  

---
