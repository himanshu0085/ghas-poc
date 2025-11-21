# **🔐 Secret Scanning - Dockerized PoC Documentation**

**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 21 Nov 2025  
**Contact:** [himanshu.parashar.snaatak@mygurukulam.co](mailto:himanshu.parashar.snaatak@mygurukulam.co)

## **📌 1️⃣ Overview**

GitHub **Secret Scanning** automatically detects accidentally committed credentials such as:

- 🔑 API Keys (AWS, Azure, Stripe…)
- 🔒 Tokens (GitHub PAT, OAuth…)
- 🔐 Passwords & sensitive config

This PoC validates how secret scanning alerts can be:  
✔ Retrieved  
✔ Parsed  
✔ Reported through a **Dockerized security tool**

Running in Docker means:  
No GitHub CLI installation required → Runs anywhere → DevSecOps automation ready 🚀

## **🧩 2️⃣ Dockerized Workflow Architecture**

Manual / CI/CD Trigger  
|  
v  
Docker Container (Secret-Scanner)  
|  
v  
GitHub API → Fetch Secret Scanning Alerts  
|  
v  
results.json + Readable Terminal Output  
|  
v  
Security Team Reviews & Fixes  

📌 Currently: executed manually  
📌 Future: fully automated pipeline integration

## **🗂 3️⃣ Project Structure**

secret-scanning-docker/  
├── Dockerfile  
├── scan.sh  
└── results.json (generated after scan)  

## **🏗 4️⃣ Dockerfile Explanation**

FROM ubuntu:22.04  
<br/>\# Install dependencies  
RUN apt-get update && apt-get install -y \\  
curl jq git  
<br/>\# Install GitHub CLI  
RUN type -p curl >/dev/null || apt-get install curl -y  
RUN curl -fsSL <https://cli.github.com/packages/githubcli-archive-keyring.gpg> \\  
| dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \\  
&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \\  
&& echo "deb \[arch=\$(dpkg --print-architecture) \\  
signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg\] \\  
<https://cli.github.com/packages> stable main" \\  
\> /etc/apt/sources.list.d/github-cli.list \\  
&& apt-get update \\  
&& apt-get install gh -y  
<br/>WORKDIR /app  
<br/>COPY scan.sh /app/scan.sh  
RUN chmod +x /app/scan.sh  
<br/>ENTRYPOINT \["/app/scan.sh"\]  

✔ Installs GitHub CLI  
✔ Installs JSON parser jq  
✔ Makes script executable  
✔ Defines execution entrypoint

## **🧪 5️⃣ scan.sh Script Explanation**

# !/bin/bash  
<br/>if \[ -z "\$GH_TOKEN" \] || \[ -z "\$REPO" \]; then  
echo "❌ Error: GH_TOKEN and REPO must be provided"  
exit 1  
fi  
<br/>gh auth login --with-token <<< "\$GH_TOKEN"  
<br/>echo "🔍 Fetching secret scanning alerts for \$REPO ..."  
gh api \\  
\-H "Accept: application/vnd.github+json" \\  
/repos/\$REPO/secret-scanning/alerts \\  
\> results.json  
<br/>echo "📄 Results saved to results.json"  
cat results.json | jq  

✔ Uses GitHub REST API  
✔ Retrieves all alert metadata  
✔ Saves & displays Beautiful JSON output 😍

## **⚙ 6️⃣ How to Run the Scan**

### **Step 1 - Build Docker Image**

docker build -t secret-scan .  

### **Step 2 - Run Scan**

docker run \\  
\-e GH_TOKEN="&lt;YOUR_GITHUB_PAT&gt;" \\  
\-e REPO="himanshu0085/ghas-poc" \\  
\-v \$(pwd):/app \\  
secret-scan  

🎯 Output Result:

- Parsed JSON displayed in terminal
- results.json generated in local folder

## **📸 7️⃣ Screenshots**

<img width="1298" height="469" alt="image" src="https://github.com/user-attachments/assets/d49d4640-393d-4428-b416-c1fb2aa2bde5" />

<img width="1298" height="469" alt="image" src="https://github.com/user-attachments/assets/012f3cc6-c4c6-4bd9-a50f-0ab316a263a9" />

<img width="1296" height="251" alt="image" src="https://github.com/user-attachments/assets/a0e63b64-0855-4335-8920-96a05af9a9cf" />

## **📦 8️⃣ What This PoC Demonstrates**

| **Security Feature** | **Status** |
| --- | --- |
| Secret Scanning Enabled | ✔   |
| Detection of Exposed Credentials | ✔   |
| Retrieve Alerts via GitHub API | ✔   |
| Dockerized CLI for Portability | ✔   |
| Ready for CI/CD Integration | ⚙ Planned |

## **🚀 9️⃣ Future Enhancements**

| **Initiative** | **Benefit** |
| --- | --- |
| Convert to GitHub Action Job | Fully automated scanning |
| Push Alerts to Teams/Slack | Faster incident response |
| Generate HTML/PDF Reports | Better compliance evidence |
| Add filtering (Open only) | Prioritization |

## **🏁 1️⃣0️⃣ Summary**

| **Objective** | **Result** |
| --- | --- |
| Validate Secret Scanning | Success |
| Build Dockerized Scanner | Completed |
| Generate Actionable Output | Success |
| Align with DevSecOps Practices | ✔ Strong Alignment |

This PoC is fully ready for demo and CI/CD expansion.
