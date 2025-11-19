# 🚀 Secret Scanning PoC
**Owner:** Himanshu Parashar  
**Mentors:** Deepak Gupta / Deepak Chauhan  
**Date:** 19 Nov 2025  
**Contact:** himanshu.parashar.snaatak@mygurukulam.co
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

Commit and push the file to the **main** branch.

This file will be used to demonstrate GitHub's Secret Scanning feature.

---

# 🛠️ Enable Secret Scanning

Before detection begins, ensure Secret Scanning is enabled for the repository.

### **1️⃣ Go to repository Settings**

### **2️⃣ Navigate to “Code security and analysis” / “Advanced Security”**

### **3️⃣ Under “Secret Protection”, enable:**
- **Secret scanning**
- *(Optional)* **Push protection**

Once enabled, GitHub will automatically scan **new commits** for exposed secrets.

---

# 🕒 Expected Flow

1. After enabling the feature, go to the **Security** tab in your repository  
2. GitHub scans the newly pushed content  
3. Secret alerts appear under **Security → Secret Scanning**  
4. You will validate alerts and capture screenshots  
5. Alerts can then be marked as **resolved**, **revoked**, or **dismissed**
