#!/bin/bash

echo "========================================"
echo "EXPENSE TRACKER - PUSH TO GITHUB"
echo "========================================"
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "ERROR: Git tidak ditemukan!"
    echo "Silakan install Git terlebih dahulu"
    echo "Ubuntu/Debian: sudo apt-get install git"
    echo "CentOS/RHEL: sudo yum install git"
    echo "macOS: brew install git"
    exit 1
fi

echo "Git ditemukan, memulai proses push ke GitHub..."
echo

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo "Inisialisasi Git repository..."
    git init
    echo
fi

# Add all files
echo "Menambahkan semua file ke staging area..."
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "Tidak ada perubahan untuk di-commit"
    echo
else
    echo
    echo "Commit perubahan..."
    git commit -m "Initial commit: Expense Tracker Application with Java Backend and SQLite Database"
    echo
fi

# Check if remote origin exists
if ! git remote | grep -q "origin"; then
    echo
    echo "Remote origin belum dikonfigurasi"
    echo "Masukkan URL GitHub repository Anda:"
    read -p "GitHub URL (contoh: https://github.com/username/repo-name.git): " github_url
    
    if [ -z "$github_url" ]; then
        echo "URL tidak boleh kosong!"
        exit 1
    fi
    
    echo "Menambahkan remote origin..."
    git remote add origin "$github_url"
    echo
fi

# Push to GitHub
echo "Push ke GitHub repository..."
echo

# Check current branch
current_branch=$(git branch --show-current 2>/dev/null)
if [ -z "$current_branch" ]; then
    echo "Membuat branch main..."
    git branch -M main
fi

# Push with upstream tracking
echo "Push ke branch main..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo
    echo "========================================"
    echo "BERHASIL! Project berhasil di-push ke GitHub"
    echo "========================================"
    echo
    echo "Repository: $github_url"
    echo "Branch: main"
    echo
    echo "Langkah selanjutnya:"
    echo "1. Buka repository di GitHub"
    echo "2. Tambahkan README.md jika belum ada"
    echo "3. Setup GitHub Pages jika diperlukan"
    echo "4. Tambahkan collaborators jika diperlukan"
    echo
else
    echo
    echo "ERROR: Gagal push ke GitHub!"
    echo "Periksa:"
    echo "- URL repository sudah benar"
    echo "- Akses ke repository sudah diberikan"
    echo "- Internet connection stabil"
    echo
    exit 1
fi
