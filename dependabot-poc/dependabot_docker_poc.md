# 🔐 Dependabot - Dockerized PoC Documentation

**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 24 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co

---

## Table of Contents
- [Overview](#overview)
- [Why-This-PoC](#why-this-poc)
- [Architecture-Workflow](#architecture-workflow)
- [Project-Structure](#project-structure)
- [Dockerfile-Explanation](#dockerfile-explanation)
- [Script-Explanation](#script-explanation)
- [How-to-Run](#how-to-run)
- [Sample-Output](#sample-output)
- [PoC-Demonstrates](#poc-demonstrates)
- [Future-Enhancements](#future-enhancements)
- [Summary](#summary)

---

## Overview

GitHub **Dependabot** identifies vulnerable packages such as npm, pip, Maven, and Docker dependencies.  
This PoC demonstrates:

- Fetching Dependabot alerts via GitHub API  
- Running inside Docker  
- Producing structured outputs:  
  - `dependabot_results.json`  
  - `dependabot_report.md`  
  - `dependabot_summary.csv`

---

## Why This PoC?

This PoC helps organizations:

- Use a **portable** dependency scanning tool  
- Avoid local installations of GitHub CLI  
- Integrate into DevSecOps CI/CD  
- Produce automated security reports  

---

## Architecture Workflow

Manual Run / CI Trigger  
↓  
Docker Container (`dependabot-scan`)  
↓  
GitHub API → Fetch Dependabot Alerts  
↓  
Reports (JSON + MD + CSV)  
↓  
Security Team Reviews & Fixes

---

## Project Structure

```
dependabot-docker/
├── Dockerfile
├── dependabot_scan.sh
├── dependabot_results.json      # generated
├── dependabot_report.md         # generated
└── dependabot_summary.csv       # generated
```

---

## Dockerfile Explanation

- Installs GitHub CLI  
- Installs jq, Python3, pip, pandoc  
- Copies script and makes it executable  
- Runs script through ENTRYPOINT  

---

## Script Explanation

`dependabot_scan.sh`:

- Authenticates GitHub using GH_TOKEN  
- Calls `/repos/<owner>/<repo>/dependabot/alerts`  
- Creates:
  - Raw JSON  
  - Markdown report  
  - CSV summary  

- Prints a clean terminal summary  

---

## How to Run

### Build image

```sh
docker build -t dependabot-scan .
```

### Run scan

```sh
docker run   -e GH_TOKEN="<YOUR_PAT>"   -e REPO="himanshu0085/ghas-poc"   -v $(pwd):/app   dependabot-scan
```

---

## Sample Output

```
🔍 Fetching Dependabot alerts...
📄 Raw JSON saved to /app/dependabot_results.json
✅ Reports generated:
 - dependabot_results.json
 - dependabot_report.md
 - dependabot_summary.csv

Top alerts:
Alert #12 | lodash | medium | open
Alert #11 | lodash | high   | open
Alert #10 | lodash | critical | open
```

---

## PoC Demonstrates

| Feature | Status |
|--------|--------|
| Fetch Dependabot alerts | ✔ |
| Multi-format reports | ✔ |
| Portable Docker scanner | ✔ |
| CI/CD-ready | ✔ |
| Works for any repo | ✔ |

---

## Future Enhancements

| Enhancement | Benefit |
|------------|---------|
| GitHub Actions pipeline | Automate scans |
| Slack/Teams notifications | Instant alerts |
| HTML/PDF reporting | Compliance-ready |
| Severity filtering | Prioritization |
| Auto-fix PR generation | Faster remediation |

---

## Summary

| Objective | Result |
|----------|--------|
| Build Dockerized Dependabot scanner | Success |
| Extract & parse alerts | Completed |
| Provide security reports | Delivered |
| Align with DevSecOps | Strong alignment |
