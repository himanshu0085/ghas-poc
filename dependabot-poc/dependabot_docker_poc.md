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

```
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl jq git ca-certificates coreutils python3 python3-pip pandoc \
  && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY dependabot_scan.sh /app/dependabot_scan.sh
RUN chmod +x /app/dependabot_scan.sh

ENTRYPOINT ["/bin/bash", "/app/dependabot_scan.sh"]
```

- Installs GitHub CLI  
- Installs jq, Python3, pip, pandoc  
- Copies script and makes it executable  
- Runs script through ENTRYPOINT  

---

## Script Explanation

```
#!/usr/bin/env bash
set -euo pipefail

# dependabot_scan.sh
# Generates:
# - dependabot_results.json
# - dependabot_report.md
# - dependabot_summary.csv

if [ -z "${GH_TOKEN:-}" ] || [ -z "${REPO:-}" ]; then
  echo "❌ Error: GH_TOKEN and REPO must be provided."
  echo "Usage: docker run -e GH_TOKEN=... -e REPO=owner/repo -v \$(pwd):/app dependabot-scan"
  exit 1
fi

# Export GH_TOKEN for GitHub CLI (no interactive login needed)
export GH_TOKEN="$GH_TOKEN"

OUT_JSON="/app/dependabot_results.json"
OUT_MD="/app/dependabot_report.md"
OUT_CSV="/app/dependabot_summary.csv"

echo "🔍 Fetching Dependabot alerts for repo: $REPO ..."
gh api -H "Accept: application/vnd.github+json" \
  "/repos/$REPO/dependabot/alerts" > "$OUT_JSON" || {
    echo "❌ API call failed — check token permissions and repo name."
    exit 2
}

echo "📄 Raw JSON saved to: $OUT_JSON"

# No alerts case
if [ "$(jq 'length' "$OUT_JSON")" -eq 0 ]; then
  echo "ℹ️ No Dependabot alerts found."

  cat > "$OUT_MD" <<EOF
# Dependabot Report — $REPO

_No Dependabot alerts found._
EOF

  echo "alert_number,package,severity,state,manifest_path,summary" > "$OUT_CSV"
  exit 0
fi

# CSV header
echo "alert_number,package,severity,state,manifest_path,summary" > "$OUT_CSV"

# Markdown header
cat > "$OUT_MD" <<EOF
# Dependabot Full Report — $REPO

Generated: $(date -u +"%Y-%m-%d %H:%M:%SZ")
Repository: **$REPO**

---

## Summary Table

| Alert # | Package | Severity | State | Manifest Path |
|--------:|:-------:|:--------:|:-----:|:-------------:|
EOF

# Loop through alerts
jq -c '.[]' "$OUT_JSON" | while read -r alert; do

  number=$(jq -r '.number' <<<"$alert")
  state=$(jq -r '.state' <<<"$alert")
  pkg=$(jq -r '(.dependency.package.name // .security_vulnerability.package.name)' <<<"$alert")
  manifest=$(jq -r '.dependency.manifest_path // "n/a"' <<<"$alert")
  severity=$(jq -r '(.security_advisory.severity // .security_vulnerability.severity)' <<<"$alert")
  title=$(jq -r '(.security_advisory.summary // "n/a")' <<<"$alert")
  summary_text=$(jq -r '(.security_advisory.description // .security_advisory.summary // "n/a")' <<<"$alert")

  # Markdown summary row
  printf "| %s | %s | %s | %s | %s |\n" \
    "$number" "$pkg" "$severity" "$state" "$manifest" >> "$OUT_MD"

  # Detailed alert section
  cat >> "$OUT_MD" <<DETAIL

---

### Alert #$number — $pkg

- **State:** $state
- **Severity:** $severity
- **Package:** $pkg
- **Manifest:** $manifest
- **Title:** $title

**Summary:**  
$summary_text

DETAIL

  # CSV row
  echo "$number,\"$pkg\",$severity,$state,\"$manifest\",\"$title\"" >> "$OUT_CSV"

done

echo "✅ Report generated:"
echo " - $OUT_JSON"
echo " - $OUT_MD"
echo " - $OUT_CSV"

# Pretty terminal output
echo
echo "🔁 Top alerts:"
jq -r '.[] | "Alert #" + (.number|tostring) + " | " +
       (.dependency.package.name // .security_vulnerability.package.name) +
       " | " +
       (.security_advisory.severity // .security_vulnerability.severity) +
       " | " +
       .state' "$OUT_JSON" | sed -n '1,20p'
```
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

<img width="1135" height="577" alt="image" src="https://github.com/user-attachments/assets/db1891b5-2311-4ce3-b1cd-184dab3936f6" />

<img width="1282" height="695" alt="image" src="https://github.com/user-attachments/assets/0b47aa0f-bd0f-47c0-8d5d-6c61d6a317ab" />

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
