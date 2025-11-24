# **🔐 Dependabot - Dockerized PoC Documentation**

**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 24 Nov 2025  
**Contact:** [himanshu.parashar.snaatak@mygurukulam.co](mailto:himanshu.parashar.snaatak@mygurukulam.co)

---
## 📑 Table of Contents
- [1️⃣ Overview](#1️⃣-overview)
- [2️⃣ Why This PoC?](#2️⃣-why-this-poc)
- [3️⃣ Architecture Workflow](#3️⃣-architecture-workflow)
- [4️⃣ Project Structure](#4️⃣-project-structure)
- [5️⃣ Dockerfile Explanation](#5️⃣-dockerfile-explanation)
- [6️⃣ Script Explanation (dependabot_scan.sh)](#6️⃣-script-explanation-dependabot_scansh)
- [7️⃣ How to Run the Scan](#7️⃣-how-to-run-the-scan)
- [8️⃣ Sample Output](#8️⃣-sample-output)
- [9️⃣ What This PoC Demonstrates](#9️⃣-what-this-poc-demonstrates)
- [🔟 Future Enhancements](#🔟-future-enhancements)
- [1️⃣1️⃣ Summary](#1️⃣1️⃣-summary)

---

# **1️⃣ Overview**

GitHub **Dependabot** identifies vulnerable packages inside your repository-such as outdated npm, pip, Maven, or Docker dependencies-and reports security issues.

This PoC demonstrates how to:

✔ Fetch Dependabot alerts via **GitHub API**  
✔ Run the scan inside **Docker**  
✔ Produce structured outputs:

- dependabot_results.json
- dependabot_report.md
- dependabot_summary.csv  
    ✔ Display a clean terminal summary  
    ✔ Prepare for CI/CD automation

---

# **2️⃣ Why This PoC?**

Organizations often need:

✔ A portable vulnerability-checking tool  
✔ No dependency on local GitHub CLI installations  
✔ Repeatable builds for DevSecOps pipelines  
✔ Automated reporting for audits and reviews

Docker solves all of this.

---

# **3️⃣ Architecture Workflow**

Manual Run / CI Trigger  
|  
v  
Docker Container: dependabot-scan  
|  
v  
GitHub API → Fetch Dependabot Alerts  
|  
v  
JSON + Markdown + CSV Reports  
|  
v  
Security Team / Dev Team Review & Fix  

Currently: **Manual execution**  
Future: **CI/CD automation, Slack alerts, PDF reporting**

---

# **4️⃣ Project Structure**

dependabot-docker/  
├── Dockerfile  
├── dependabot_scan.sh  
├── dependabot_results.json # generated  
├── dependabot_report.md # generated  
└── dependabot_summary.csv # generated  

---

# **5️⃣ Dockerfile Explanation**

FROM ubuntu:22.04  
<br/>ENV DEBIAN_FRONTEND=noninteractive  
<br/>RUN apt-get update && apt-get install -y \\  
curl jq git ca-certificates coreutils python3 python3-pip pandoc \\  
&& rm -rf /var/lib/apt/lists/\*  
<br/>\# Install GitHub CLI  
RUN curl -fsSL <https://cli.github.com/packages/githubcli-archive-keyring.gpg> \\  
| dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \\  
&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \\  
&& echo "deb \[arch=\$(dpkg --print-architecture) \\  
signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg\] \\  
<https://cli.github.com/packages> stable main" \\  
\> /etc/apt/sources.list.d/github-cli.list \\  
&& apt-get update \\  
&& apt-get install -y gh \\  
&& rm -rf /var/lib/apt/lists/\*  
<br/>WORKDIR /app  
<br/>COPY dependabot_scan.sh /app/dependabot_scan.sh  
RUN chmod +x /app/dependabot_scan.sh  
<br/>ENTRYPOINT \["/app/dependabot_scan.sh"\]  

✔ Installs GitHub CLI  
✔ Installs jq, Python, pandoc  
✔ Makes script executable  
✔ Sets /app as runtime directory

---

# **6️⃣ Script Explanation (dependabot_scan.sh)**

The script:
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



✔ Authenticates using \$GH_TOKEN  
✔ Queries: /repos/OWNER/REPO/dependabot/alerts  
✔ Generates:

- dependabot_results.json → raw alerts
- dependabot_report.md → full detailed report
- dependabot_summary.csv → Excel-friendly summary

✔ Shows summary in terminal

---

# **7️⃣ How to Run the Scan**

### **Step 1 - Build Docker Image**

docker build -t dependabot-scan .  

### **Step 2 - Run the Scan**

docker run \\  
\-e GH_TOKEN="&lt;YOUR_GITHUB_PAT&gt;" \\  
\-e REPO="himanshu0085/ghas-poc" \\  
\-v \$(pwd):/app \\  
dependabot-scan  

Outputs will be saved in your **local folder**.

---

# **8️⃣ Sample Output (Terminal)**

🔍 Fetching Dependabot alerts for repo: himanshu0085/ghas-poc ...  
📄 Raw JSON saved to: /app/dependabot_results.json  
✅ Report generated:  
\- /app/dependabot_results.json  
\- /app/dependabot_report.md  
\- /app/dependabot_summary.csv  
<br/>🔁 Top alerts:  
Alert #12 | lodash | medium | open  
Alert #11 | lodash | high | open  
Alert #10 | lodash | critical | open  
Alert #9 | lodash | high | open  
Alert #6 | axios | high | fixed  

---

# **9️⃣ What This PoC Demonstrates**

| **Feature** | **Status** |
| --- | --- |
| Fetch Dependabot alerts from GitHub API | ✔   |
| Generate multi-format reports | ✔   |
| Portable Docker-based scanner | ✔   |
| Ready for pipeline integration | ✔   |
| Works with any GitHub repository | ✔   |

---

# **🔟 Future Enhancements**

| **Enhancement** | **Benefit** |
| --- | --- |
| GitHub Action automation | Fully automatic scanning |
| Slack/Teams notification | Immediate visibility |
| HTML/PDF reporting | Compliance-friendly |
| Severity filtering | Prioritization |
| Auto-fix PR generation | Faster remediation |

---

# **1️⃣1️⃣ Summary**

| **Objective** | **Result** |
| --- | --- |
| Build a Dockerized Dependabot scanner | ✔ Success |
| Extract and parse alerts | ✔ Completed |
| Provide security reports | ✔ Delivered |
| Align with DevSecOps | ✔ Strong alignment |

---
