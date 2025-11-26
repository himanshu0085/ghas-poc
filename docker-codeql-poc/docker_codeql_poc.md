# **CodeQL - Dockerized Multi-Language Security Scanner (PoC)**

**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 26 Nov 2025  
**Contact:** [himanshu.parashar.snaatak@mygurukulam.co](mailto:himanshu.parashar.snaatak@mygurukulam.co)

## Table of Contents
- [Overview](#overview)
- [Why This PoC](#why-this-poc)
- [Architecture Workflow](#architecture-workflow)
- [Project Structure](#project-structure)
- [Supported Languages](#supported-languages)
- [Dockerfile Explanation](#dockerfile-explanation)
- [Script Explanation - run-codeqlsh](#script-explanation---run-codeqlsh)
- [How to Run](#how-to-run)
- [Sample Output](#sample-output)
- [PoC Demonstrates](#poc-demonstrates)
- [Future Enhancements](#future-enhancements)
- [Summary](#summary)


## **Overview**

GitHub **CodeQL** is a semantic code analysis engine that identifies high-risk vulnerabilities in source code.

| **Category** | **Issues** |
| --- | --- |
| Injection | SQL Injection, XSS, Command Injection |
| Secrets | Hardcoded credentials |
| Unsafe Cryptography | Weak algorithms (MD5/SHA-1) |
| Deserialization | Python / Java unsafe object handling |
| SSRF / CSRF | Server-side & client-side forgery attacks |

🔐 This Proof-of-Concept provides:

- **Docker-based CodeQL security scanner**
- **Automatic multi-language detection**
- **Reports in SARIF, CSV, and HTML formats**

No local CodeQL installation required.

## **Why This PoC**

| **Problem** | **Solution** |
| --- | --- |
| CodeQL setup is heavy | Docker packaged scanner |
| Developers forget to scan | One-command execution |
| CI/CD requires results | SARIF + CSV + HTML |
| Multi-language repos are common | Auto detection & scanning |

Result → Streamlined "shift-left security" without environment friction.

## **Architecture Workflow**

Developer / CI Trigger  
↓  
Docker Container (codeql-scanner)  
↓  
Clone target repo  
↓  
Auto-detect languages (JS / Python / Go / Java)  
↓  
Create DBs per language  
↓  
Run CodeQL queries  
↓  
Generate reports → SARIF + HTML + CSV  

## **Project Structure**

codeql-docker/  
├── Dockerfile  
├── run-codeql.sh  
│  
├── repo/ # Created during scan  
│ ├── db-javascript  
│ ├── db-python  
│ ├── db-go  
│ ├── db-java  
│ ├── results.sarif  
│ ├── report.html  
│ └── report.csv  

## **Supported Languages**

| **Language** | **Support** |
| --- | --- |
| JavaScript / TypeScript | ✔   |
| Python | ✔   |
| Go  | ✔   |
| Java | ✔ (requires Maven/Gradle) |

⚠️ Java auto-build may fail if no build tool exists - **scanning still continues**.

## **Dockerfile Explanation**

| **Component** | **Purpose** |
| --- | --- |
| Python | Python extractor |
| Java JDK | Java extractor |
| Go  | Go auto builder |
| ln -sf python3 python | CodeQL compatibility |
| CodeQL bundle | Pre-installed - no external dependency |

Everything needed for scanning is contained in **one Docker image**.

## **Script Explanation - run-codeql.sh**

Operations performed:

| **Stage** | **Action** |
| --- | --- |
| 1   | Clone repository fresh |
| 2   | Detect languages automatically |
| 3   | Build CodeQL databases for each detected language |
| 4   | Run security queries |
| 5   | Merge SARIF manually |
| 6   | Export results → .sarif, .csv, .html |

📄 **Outputs**

- results.sarif → Uploadable to GitHub Advanced Security
- report.csv → Excel-ready
- report.html → Security dashboard

## **How to Run**

### **Step 1 - Build image**

```
docker build -t codeql-scanner .  
```

<img width="1298" height="513" alt="image" src="https://github.com/user-attachments/assets/1329b064-1124-498c-ac98-3d1ac51f7c66" />


### **Step 2 - Execute scan**

```
docker run --rm codeql-scanner /scan/run-codeql.sh <https://github.com/><user>/<repo>.git
```

<img width="1298" height="513" alt="image" src="https://github.com/user-attachments/assets/87decb22-88cc-4577-95c0-7a6270d42090" />


### **Step 3 - Open reports**
cd /scan/repo  
```
cat report.csv
```
<img width="1301" height="517" alt="image" src="https://github.com/user-attachments/assets/c42a7937-5ac8-49a8-84c8-e9693beb0683" />


If you want to see the report on browser first hit this below command in /scan/repo

```
python3 -m http.server 8080  
```

### **Step 4 - Access reports from browser**

| **Format** | **URL** |
| --- | --- |
| HTML | http://&lt;ip&gt;:8080/report.html |
| CSV | http://&lt;ip&gt;:8080/report.csv |
| SARIF | http://&lt;ip&gt;:8080/results.sarif |

<img width="1297" height="446" alt="image" src="https://github.com/user-attachments/assets/2c2101df-7569-46a9-81eb-d97a511002b4" />


## **Sample Output**

### **Terminal JSON (example)**

{  
"ruleId": "js/reflected-xss",  
"message": "Cross-site scripting vulnerability...",  
"file": "codeql-poc/app.js",  
"line": 18,  
"severity": "warning"  
}  

### **CSV Example**

Rule ID,Severity,Message,File,Line  
"py/command-line-injection","high","User-controlled value reaches command execution","vuln.py","9"  

📌 HTML report provides **sortable, severity-color-coded vulnerability dashboard**.

## **PoC Demonstrates**

| **Capability** | **Status** |
| --- | --- |
| Multi-language static analysis | ✔   |
| Language auto-detection | ✔   |
| SARIF + HTML + CSV export | ✔   |
| CI/CD Ready | ✔   |
| No CodeQL local dependency | ✔   |

## **Future Enhancements**

| **Enhancement** | **Benefit** |
| --- | --- |
| Web dashboard | Enterprise reporting |
| PDF export | Compliance |
| Slack / Teams notifications | Faster remediation |
| CI failure based on severity | Policy enforcement |
| Custom CodeQL query packs | Organization-wide secure coding rules |

## **Summary**

| **Objective** | **Result** |
| --- | --- |
| Dockerized CodeQL scanner | **Achieved** |
| Developer-friendly experience | **Achieved** |
| CI/CD compatibility | **Achieved** |
| Multi-language scanning | **Achieved** |
| Exportable security reports | **Achieved** |
