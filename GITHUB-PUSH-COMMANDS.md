# 🚀 Push Project ke GitHub - Command Manual

Panduan lengkap untuk push project Expense Tracker ke GitHub repository.

## 📋 Prerequisites

1. **Git installed** di komputer
2. **GitHub account** sudah dibuat
3. **Repository baru** sudah dibuat di GitHub
4. **Internet connection** stabil

## 🔧 Setup Awal

### 1. **Install Git**
```bash
# Windows: Download dari https://git-scm.com/downloads
# Ubuntu/Debian
sudo apt-get install git

# CentOS/RHEL
sudo yum install git

# macOS
brew install git
```

### 2. **Konfigurasi Git (Pertama kali)**
```bash
git config --global user.name "Nama Anda"
git config --global user.email "email@example.com"
```

### 3. **Buat Repository di GitHub**
1. Buka [GitHub.com](https://github.com)
2. Klik tombol **"New repository"**
3. Isi nama repository (contoh: `expense-tracker`)
4. Pilih **Public** atau **Private**
5. **JANGAN** centang "Initialize this repository with a README"
6. Klik **"Create repository"**

## 🚀 Command Manual Step by Step

### **Step 1: Inisialisasi Git Repository**
```bash
# Masuk ke folder project
cd /path/to/expense-tracker-project

# Inisialisasi git repository
git init
```

### **Step 2: Tambahkan Remote Origin**
```bash
# Ganti dengan URL repository GitHub Anda
git remote add origin https://github.com/username/expense-tracker.git

# Verifikasi remote
git remote -v
```

### **Step 3: Tambahkan File ke Staging**
```bash
# Tambahkan semua file
git add .

# Atau tambahkan file spesifik
git add index.html
git add style.css
git add script.js
git add admin.html
git add admin-style.css
git add admin-script.js
git add pom.xml
git add src/
git add database-schema.sql
git add README.md
```

### **Step 4: Commit Perubahan**
```bash
# Commit pertama
git commit -m "Initial commit: Expense Tracker Application with Java Backend and SQLite Database"

# Atau commit dengan deskripsi lebih detail
git commit -m "Initial commit: Complete Expense Tracker Application

- Frontend: HTML, CSS, JavaScript with admin panel
- Backend: Java Spring Boot with REST API
- Database: SQLite with complete schema
- Features: User management, categories, transactions, budgets
- Admin panel: Settings, analytics, backup/restore"
```

### **Step 5: Buat Branch Main**
```bash
# Buat dan switch ke branch main
git branch -M main
```

### **Step 6: Push ke GitHub**
```bash
# Push pertama dengan upstream tracking
git push -u origin main

# Push selanjutnya
git push
```

## 🔄 Update Project (Setelah Perubahan)

### **1. Lihat Status Perubahan**
```bash
git status
git diff
```

### **2. Tambahkan Perubahan**
```bash
git add .
git add nama-file-yang-diubah
```

### **3. Commit Perubahan**
```bash
git commit -m "Update: deskripsi perubahan"
```

### **4. Push ke GitHub**
```bash
git push
```

## 📁 Struktur File yang Akan Di-push

```
expense-tracker/
├── Frontend/
│   ├── index.html
│   ├── style.css
│   ├── script.js
│   ├── admin.html
│   ├── admin-style.css
│   └── admin-script.js
├── Backend/
│   ├── pom.xml
│   ├── src/main/java/
│   ├── src/main/resources/
│   └── README-BACKEND.md
├── Database/
│   ├── database-schema.sql
│   ├── run-database.sql
│   └── DATABASE-README.md
├── Scripts/
│   ├── create-database.bat
│   ├── create-database.sh
│   ├── push-to-github.bat
│   └── push-to-github.sh
├── Documentation/
│   ├── README.md
│   └── GITHUB-PUSH-COMMANDS.md
└── .gitignore
```

## ⚡ Quick Commands (Copy-Paste)

### **Setup Awal (Ganti URL repository)**
```bash
git init
git remote add origin https://github.com/username/expense-tracker.git
git add .
git commit -m "Initial commit: Expense Tracker Application"
git branch -M main
git push -u origin main
```

### **Update Project**
```bash
git add .
git commit -m "Update: deskripsi perubahan"
git push
```

## 🔍 Troubleshooting

### **1. Error: "fatal: remote origin already exists"**
```bash
# Hapus remote yang ada
git remote remove origin

# Tambahkan remote baru
git remote add origin https://github.com/username/expense-tracker.git
```

### **2. Error: "fatal: refusing to merge unrelated histories"**
```bash
# Jika repository GitHub sudah ada isi
git pull origin main --allow-unrelated-histories
```

### **3. Error: "fatal: The current branch has no upstream branch"**
```bash
# Set upstream branch
git push -u origin main
```

### **4. Error: "Permission denied"**
```bash
# Pastikan sudah login ke GitHub
# Gunakan Personal Access Token jika diperlukan
git remote set-url origin https://username:token@github.com/username/repo.git
```

### **5. Error: "Authentication failed"**
```bash
# Setup Personal Access Token
# 1. GitHub → Settings → Developer settings → Personal access tokens
# 2. Generate new token
# 3. Copy token dan gunakan sebagai password
```

## 📚 GitHub Repository Setup

### **1. Tambahkan README.md**
- Repository akan otomatis menampilkan README.md
- File ini akan menjadi halaman utama repository

### **2. Setup GitHub Pages (Opsional)**
- Settings → Pages
- Source: Deploy from a branch
- Branch: main
- Folder: / (root)

### **3. Tambahkan Topics**
- Tambahkan topics: `expense-tracker`, `java`, `spring-boot`, `sqlite`, `web-app`

### **4. Setup Branch Protection (Opsional)**
- Settings → Branches
- Add rule untuk branch main
- Require pull request reviews

## 🎯 Best Practices

1. **Commit Message yang Jelas**
   - Gunakan present tense
   - Deskripsikan perubahan dengan jelas
   - Gunakan prefix: `feat:`, `fix:`, `docs:`, `style:`

2. **Regular Commits**
   - Commit setiap fitur selesai
   - Jangan commit terlalu banyak perubahan sekaligus

3. **Branch Management**
   - Gunakan branch untuk fitur baru
   - Merge ke main setelah testing

4. **Documentation**
   - Update README.md secara berkala
   - Tambahkan screenshots jika diperlukan

## 🚀 Setelah Push Berhasil

1. **Buka repository di GitHub**
2. **Verifikasi semua file sudah ter-upload**
3. **Tambahkan description repository**
4. **Setup GitHub Pages jika diperlukan**
5. **Share repository dengan tim/komunitas**

---

**Happy Coding & Happy Pushing! 🎉**
