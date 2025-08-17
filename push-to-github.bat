@echo off
echo ========================================
echo EXPENSE TRACKER - PUSH TO GITHUB
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git tidak ditemukan!
    echo Silakan install Git terlebih dahulu
    echo Download dari: https://git-scm.com/downloads
    pause
    exit /b 1
)

echo Git ditemukan, memulai proses push ke GitHub...
echo.

REM Check if this is a git repository
if not exist ".git" (
    echo Inisialisasi Git repository...
    git init
    echo.
)

REM Add all files
echo Menambahkan semua file ke staging area...
git add .

REM Check if there are changes to commit
git diff --cached --quiet
if %errorlevel% equ 0 (
    echo Tidak ada perubahan untuk di-commit
    echo.
) else (
    echo.
    echo Commit perubahan...
    git commit -m "Initial commit: Expense Tracker Application with Java Backend and SQLite Database"
    echo.
)

REM Check if remote origin exists
git remote -v | findstr "origin" >nul
if %errorlevel% neq 0 (
    echo.
    echo Remote origin belum dikonfigurasi
    echo Masukkan URL GitHub repository Anda:
    set /p github_url="GitHub URL (contoh: https://github.com/username/repo-name.git): "
    
    if "%github_url%"=="" (
        echo URL tidak boleh kosong!
        pause
        exit /b 1
    )
    
    echo Menambahkan remote origin...
    git remote add origin %github_url%
    echo.
)

REM Push to GitHub
echo Push ke GitHub repository...
echo.

REM Check current branch
git branch --show-current >nul 2>&1
if %errorlevel% neq 0 (
    echo Membuat branch main...
    git branch -M main
)

REM Push with upstream tracking
echo Push ke branch main...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo BERHASIL! Project berhasil di-push ke GitHub
    echo ========================================
    echo.
    echo Repository: %github_url%
    echo Branch: main
    echo.
    echo Langkah selanjutnya:
    echo 1. Buka repository di GitHub
    echo 2. Tambahkan README.md jika belum ada
    echo 3. Setup GitHub Pages jika diperlukan
    echo 4. Tambahkan collaborators jika diperlukan
    echo.
) else (
    echo.
    echo ERROR: Gagal push ke GitHub!
    echo Periksa:
    echo - URL repository sudah benar
    echo - Akses ke repository sudah diberikan
    echo - Internet connection stabil
    echo.
)

pause
