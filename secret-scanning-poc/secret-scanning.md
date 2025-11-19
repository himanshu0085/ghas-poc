# 🚀 Secret Scanning PoC
**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 19 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co  

---


# 📘 Table of Contents

- [Understanding Secret Scanning](#-understanding-secret-scanning)
- [Objective of This PoC](#-objective-of-this-poc)
- [Repository Setup](#-repository-setup)
- [Content for secret-scanningtxt](#-content-for-secret-scanningtxt)
- [Enable Secret Scanning](#️-enable-secret-scanning)
- [Expected Flow](#-expected-flow)

---

# ✅ Understanding Secret Scanning

Secret Scanning is a GitHub Advanced Security (GHAS) capability that automatically identifies exposed credentials inside a repository. GitHub scans:

- Commits  
- Branches  
- Pull Requests  
- Issues  
- Wikis  
- Discussions  

When a supported secret pattern is detected, GitHub generates an alert under:

➡️ **Security → Secret Scanning**

This PoC demonstrates adding sample secrets, pushing them to GitHub, observing the alerts, and documenting the workflow.

---

# 🎯 Objective of This PoC

- Create a single file containing multiple credential patterns  
- Push the file to a public repository  
- Trigger secret-scanning alerts  
- Validate and record alert details through screenshots  
- Understand how alerts are reviewed and resolved  

---

# 📁 Repository Setup

Create a dedicated folder in your repository:

```
secret-scanning-poc/
```

Inside it, create one file:

```
secret-scanning.txt
```
---

# 🧪 Content for `secret-scanning.txt`

Paste the following sample secrets into the file:

```
ghp_FAKEPAT1234567890abcdefghijklmnopqrstuvwxyz12
AKIA1234567890FAKEKEY
sk_test_4eC39HqLyjWDarjtT1zdp7dc
```

<img width="1288" height="690" alt="image" src="https://github.com/user-attachments/assets/7e8ad12a-d7b8-41f6-b6e7-7a16c2e3a0e9" />


Commit and push the file to the **main** branch.

This file will be used to demonstrate GitHub's Secret Scanning feature.

---

# 🛠️ Enable Secret Scanning

Before detection begins, ensure Secret Scanning is enabled for the repository.

### **1️⃣ Go to repository Settings**

### **2️⃣ Navigate to “Code security and analysis” / “Advanced Security”**

<img width="1292" height="619" alt="image" src="https://github.com/user-attachments/assets/78bc8019-fb47-4ef3-9b34-beb2d42b4c45" />


### **3️⃣ Under “Secret Protection”, enable:**
- **Secret scanning**
  <img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/d010885a-f5f0-420f-9177-a02e9ddccee8" />

- *(Optional)* **Push protection**


Once enabled, GitHub will automatically scan **new commits** for exposed secrets.

---

# 🕒 Expected Flow

1. After enabling the feature, go to the **Security** tab in your repository  
2. GitHub scans the newly pushed content  
3. Secret alerts appear under **Security → Secret Scanning**  
4. You will validate alerts and capture screenshots  
5. Alerts can then be marked as **resolved**, **revoked**, or **dismissed**
