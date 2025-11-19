# 🚀 Secret Scanning PoC
**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 19 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co  

---


# 📘 Table of Contents

- [Understanding Secret Scanning](#understanding-secret-scanning)
- [Objective of This PoC](#objective-of-this-poc)
- [Repository Setup](#repository-setup)
- [Content for secret-scanningtxt](#content-for-secret-scanningtxt)
- [Enable Secret Scanning](#enable-secret-scanning)
- [Expected Flow](#expected-flow)
- [Closure Reasons Explained](#closure-reasons-explained)
- [Best Practices](#best-practices)


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
  <img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/f05a8737-a493-422b-89a0-a13897cc845f" />


- *(Optional)* **Push protection**
<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/0a7d2b22-34c7-41b0-afb4-cf7c95be397a" />


Once enabled, GitHub will automatically scan **new commits** for exposed secrets.

---

# 🕒 Expected Flow

1. After enabling the feature, go to the **Security** tab in your repository  
<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/ab542c44-fd12-496b-82a1-4cb47e259228" />

2. GitHub scans the newly pushed content  
3. Secret alerts appear under **Security → Secret Scanning**  
<img width="1300" height="833" alt="image" src="https://github.com/user-attachments/assets/b33b7c94-4062-48a8-adbb-12c192382669" />

4. You will validate alerts and capture screenshots  
5. Alerts can then be marked as **resolved**, **revoked**, or **dismissed**
<img width="1300" height="615" alt="image" src="https://github.com/user-attachments/assets/dec38880-6ef4-432b-8822-27703d2cfea6" />

---

## 🏷️ Closure Reasons Explained

GitHub requires selecting a valid reason before marking alerts as resolved:

| Close Reason   | When to Use It                                  | What It Means                                          |
|----------------|--------------------------------------------------|--------------------------------------------------------|
| **Revoked**    | When the leaked secret is invalidated or rotated | Secret cannot be exploited anymore                     |
| **Used in tests** | Demo/sandbox/testing credentials only        | No real risk to production                             |
| **False positive** | Detection is incorrect                      | Not actually a real secret                             |
| **Won’t fix**  | Accepted risk in PoC/demo                       | No remediation needed — but risky if used in production |

---

### 📌 Best Practices

- ✔ Always rotate real secrets immediately  
- ✔ Use **“Used in tests”** only for intentionally fake/testing keys  
- ✔ Use **“False positive”** only when 100% sure  
- ✔ Avoid **“Won’t fix”** unless in a safe PoC environment  

