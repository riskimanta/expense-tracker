@echo off
echo ========================================
echo EXPENSE TRACKER DATABASE CREATOR
echo ========================================
echo.

REM Check if SQLite is installed
sqlite3 --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: SQLite3 tidak ditemukan!
    echo Silakan install SQLite3 terlebih dahulu
    echo Download dari: https://www.sqlite.org/download.html
    pause
    exit /b 1
)

echo SQLite3 ditemukan, membuat database...
echo.

REM Create database
sqlite3 expense_tracker.db < run-database.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Database berhasil dibuat!
    echo File: expense_tracker.db
    echo ========================================
    echo.
    echo Untuk membuka database:
    echo sqlite3 expense_tracker.db
    echo.
    echo Untuk melihat struktur tabel:
    echo .schema
    echo.
    echo Untuk melihat data:
    echo SELECT * FROM users;
    echo SELECT * FROM categories;
    echo SELECT * FROM transactions;
    echo.
) else (
    echo.
    echo ERROR: Gagal membuat database!
    echo Periksa file SQL dan coba lagi
)

pause
