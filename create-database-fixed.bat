@echo off
echo ========================================
echo EXPENSE TRACKER DATABASE CREATOR - FIXED
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

REM Remove old database if exists
if exist "expense_tracker.db" (
    echo Menghapus database lama...
    del expense_tracker.db
)

REM Create database with fixed schema
echo Membuat database dengan schema yang diperbaiki...
sqlite3 expense_tracker.db < database-schema-fixed.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Database berhasil dibuat!
    echo File: expense_tracker.db
    echo ========================================
    echo.
    echo Verifikasi database...
    echo.
    
    REM Verify database
    sqlite3 expense_tracker.db "SELECT 'Database verification:' as info; SELECT 'users' as table_name, COUNT(*) as record_count FROM users UNION ALL SELECT 'categories', COUNT(*) FROM categories UNION ALL SELECT 'transactions', COUNT(*) FROM transactions UNION ALL SELECT 'budgets', COUNT(*) FROM budgets UNION ALL SELECT 'settings', COUNT(*) FROM settings;"
    
    echo.
    echo ========================================
    echo Database siap digunakan!
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
    echo SELECT * FROM budgets;
    echo.
) else (
    echo.
    echo ERROR: Gagal membuat database!
    echo Periksa file SQL dan coba lagi
)

pause
